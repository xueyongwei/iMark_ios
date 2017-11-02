//
//  UploadManager.m
//  XYW
//
//  Created by xueyognwei on 2017/6/9.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "UploadManager.h"
#import <YYKit.h>
#import "AFHTTPSessionManager+SharedManager.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <QiniuSDK.h>
#import "UserDefaultsManager.h"
@implementation UploadManager
{
    NSArray *_images;
}
+(instancetype)manager
{
    static UploadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UploadManager alloc]init];
    });
    return manager;
}
-(void)uploadImages:(NSArray *)images
{
    _images = images;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    
    NSString *app_id = [UIApplication sharedApplication].appBundleID;
    NSString *version = [UIApplication sharedApplication].appVersion;
    NSString *uid = @"";
    if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
        uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        uid = [@"r_" stringByAppendingString:[[NSUUID UUID] UUIDString]];
    }
    NSString *platform = @"iOS";
    NSString *sign = [NSString stringWithFormat:@"app_id=%@&platform=%@&uid=%@&version=%@%@",app_id,platform,uid,version,app_id];
    NSString *urlstr = [NSString stringWithFormat:@"https://api.tools.superlabs.info/i_guang/v1.0/get_token?app_id=%@&platform=%@&uid=%@&version=%@&sign=%@",app_id,platform,uid,version,sign.md5String.uppercaseString];
    [manager GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DbLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            [self setLocalShareTimes];
            [self uploadToQiniuWithToken:responseObject[@"upload_token"] andIP:responseObject[@"ip"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DbLog(@"%@",error.localizedDescription);
    }];
}
-(void)setLocalShareTimes{
    [UserDefaultsManager setAddOnceShareToGuang];
}
-(NSString *)uploadKeyOf:(NSData *)uploadData{
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"gg/"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMM"];
    NSString *ym = [formatter stringFromDate:date];
    [formatter setDateFormat:@"dd"];
    NSString *d = [formatter stringFromDate:date];
    [str appendFormat:@"%@/%@",ym,d];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    [str appendFormat:@"%lu_%.0f",(unsigned long)uploadData.length,interval ];
    //时间错
    DbLog(@"key %@",str);
    return str;
}
-(void)uploadToQiniuWithToken:(NSString *)token andIP:(NSString *)uploadIp{
    DbLog(@"uploadToQiniuWithToken %@",token);
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:uploadIp forKey:@"x:ip"];
    //防止新的图片数组导致当前要上传的图片丢失
    NSArray *imageArr = [[NSArray alloc]initWithArray:_images];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (UIImage *image in imageArr) {
            NSData *imgData = UIImagePNGRepresentation(image);
            [self uploadImageData:imgData withToken:token param:param];
        }
    });
}
-(void)uploadImageData:(NSData *)imgData withToken:(NSString *)token param:(NSDictionary *)param{
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithRecorder:nil];
    //上传参数
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        DbLog(@"%f",percent);
    } params:param checkCrc:YES cancellationSignal:^BOOL{
        return NO;
    }];
    //上传文件
    
    [upManager putData:imgData key:[self uploadKeyOf:imgData] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.isOK) {//movie上传完成
            DbLog(@"上传成功！");
        }else{
            
        }
        if (info.error) {
            DbLog(@"上传失败！ %@",info.error);
        }
    } option:opt];
}
-(NSString *)newWorkString{
    AFNetworkReachabilityStatus networkState = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (networkState) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"4G";
            break;
        default:
            return @"unknown";
            break;
    }
    
}
- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

@end
