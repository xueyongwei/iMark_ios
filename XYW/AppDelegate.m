//
//  AppDelegate.m
//  XYW
//
//  Created by xueyongwei on 16/3/3.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "AppDelegate.h"
#import "PathModel.h"
#import <SSZipArchive.h>
#import "waterModel.h"
#import "FontModel.h"
#import <UMengSocial/UMSocial.h>
#import <UMengSocial/UMSocialWechatHandler.h>
#import <UMengSocial/UMSocialQQHandler.h>
#import "SandBoxManager.h"
#import <CoreText/CoreText.h>
#import "UserDefaultsManager.h"
#import <XYWVersonManager.h>
#import "HYFileManager.h"
#import <YYKit.h>
#import <InMobiSDK/InMobiSDK.h>
@interface AppDelegate ()
@property (nonatomic,strong) NSMutableArray *pathModels;
@end

@implementation AppDelegate
-(NSMutableArray *)pathModels
{
    if (!_pathModels) {
        _pathModels = [[NSMutableArray alloc]init];
    }
    return _pathModels;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    
    //开屏广告初始化并展示代码
    self.canShowADInWiondw = YES;
    //开启网络监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [IMSdk initWithAccountID:@"450e020617004cd9ae73bb1f01fe1b7b"];
    
    
    [self mainAsynOpera];
    
    return YES;
}
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //加载开屏广告
    [self loadSplashView];
    //低权重的异步操作
    [self asynOpera];
    return YES;
}
/**
 创建一个新的开屏广告
 */
-(void)loadSplashView{
    GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:@"1106152866" placementId:@"5060321256632228"];
    self.splash = nil;
    self.splash = splashAd;
    splashAd.delegate = self;//设置代理
    UIImage *bgColorImage = [[UIImage imageNamed:@"bgimage"] imageByResizeToSize:[UIScreen mainScreen].bounds.size contentMode:UIViewContentModeScaleAspectFit];
    splashAd.backgroundColor = [UIColor colorWithPatternImage:bgColorImage];
    //设置开屏拉取时长限制，若超时则不再展示广告
    splashAd.fetchDelay = 3;
    [splashAd loadAdAndShowInWindow:self.window];

//    if (self.canShowADInWiondw || [[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        if ([[NSThread currentThread] isMainThread]) {
//            [splashAd loadAdAndShowInWindow:self.window];
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [splashAd loadAdAndShowInWindow:self.window];
//            });
//        }
//    }
}
//主线程操作
-(void)mainAsynOpera{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initUMeng];
    });
}
//子线程异步操作
-(void)asynOpera{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self unZipTemple];
        //1.2版本需要检测是否是升级来的，如果是需要清空之前的模版。
        CGFloat lastVersion = [XYWVersonManager lastVersionInter];
        if (lastVersion>0 && lastVersion<102) {
            //上个版本过早，需要
            [self clearLocalLastDoc];
        }
    });
}
-(void)initUMeng
{
    [UMSocialData setAppKey:@"57175172e0f55a89a600093b"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104102537" appKey:@"22jkOY63ZJHQW4SP" url:@"http://www.hlxmf.com/aishuiyin"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    //友盟统计
    [MobClick startWithAppkey:@"57231118e0f55af74f000925" reportPolicy:BATCH   channelId:@""];
    [MobClick setLogEnabled:YES];
}


/**
 清理本地缓存
 */
-(void)clearLocalLastDoc{
    [self resetDefaults];
    [self removeAllFilesInDoc];
}

/**
 解压水印
 */
-(void)unZipTemple{
    //解压自带的模板到doc目录
    NSString *path = [SandBoxManager documentDir];
    
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSArray *waterArr = [usf objectForKey:@"pathModels"];
    NSArray *fontArr = [usf objectForKey:@"fontModels"];
    if (!waterArr || waterArr.count==0) {
        //解压水印模版
        [UserDefaultsManager setSaveImageAuto:YES];
        [UserDefaultsManager setPicQuality:PicQualityOriginal];
        DbLog(@"解压水印路径：%@",[SandBoxManager tepmlateDir]);
        if ([SSZipArchive unzipFileAtPath:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"zip"] toDestination:path]) {
            [self initTemlateModel];
        }else{
            DbLog(@"❌解压水印模版失败！");
        }
//        [self calDirIntemAtPath:[NSString stringWithFormat:@"%@/template",path]];
    }else{
        
    }
    
    if (!fontArr || fontArr.count==0) {
        //解压字体
        DbLog(@"解压字体包路径：%@",[SandBoxManager fontDir]);
        if ([SSZipArchive unzipFileAtPath:[[NSBundle mainBundle]pathForResource:@"font" ofType:@"zip"] toDestination:path]) {
            [self initFontModel];
        }else{
            DbLog(@"❌解压字体包失败！");
        }
//        [self getFontModelAtPath:[NSString stringWithFormat:@"%@/font",path]];
    }else{//已有本地字体。注册到系统
        DbLog(@"已有本地字体。注册到系统");
        for (NSData *data in fontArr) {
            FontModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self registerCustomFontWithPath: [[SandBoxManager fontDir] stringByAppendingPathComponent:model.filePath]];
        }
    }
    
}


/**
 解析本地水印
 */
-(void)initTemlateModel{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    if ([usf objectForKey:@"pathModels"]) {
        DbLog(@"已存在模板！");
//        return;
    }
    //解压水印模版变为model
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[SandBoxManager tepmlateDir] error:&error];
    for (NSString *dir in fileList) {
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:[[SandBoxManager tepmlateDir] stringByAppendingPathComponent:dir] isDirectory:&isDir]) {
            if (isDir) {
                //根据tag判断类型
                PathModel *model = [[PathModel alloc]init];
                model.path = dir;
//                model.path = [NSString stringWithFormat:@"%@/%@",path,dir];
                //取tag值是多少
                NSString *filePath = [NSString stringWithFormat:@"%@/%@/des",[SandBoxManager tepmlateDir],dir];
                NSString *str =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                waterModel *wmodel = [waterModel mj_objectWithKeyValues:str];
                
                model.type = wmodel.tag.intValue;
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [self.pathModels addObject:data];
            }else
            {
            }
        }
    }
    //存储到本地
    [UserDefaultsManager setTemplateModels:self.pathModels];;
}

/**
 解析本地字体
 */
-(void)initFontModel{
    //解压字体变为model
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    if ([usf objectForKey:@"fontModels"]) {
        DbLog(@"已存在字体！");
//        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList;
    fileList = [fileManager contentsOfDirectoryAtPath:[SandBoxManager fontDir] error:&error];
    NSMutableArray *fontArrs = [[NSMutableArray alloc]init];
    for (NSString *dir in fileList) {
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[SandBoxManager fontDir],dir] isDirectory:&isDir]) {
            if (isDir) {
                //根据tag判断类型
                NSString *str =[NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/des",[SandBoxManager fontDir],dir] encoding:NSUTF8StringEncoding error:nil];
                FontModel *model = [FontModel mj_objectWithKeyValues:str];
//                model.filePath = [NSString stringWithFormat:@"%@/font.TTF",dir];
                DbLog(@"filePath %@",model.filePath);
                
                [self registerCustomFontWithPath: [[SandBoxManager fontDir] stringByAppendingPathComponent:model.filePath]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [fontArrs addObject:data];
            }else
            {
            }
        }
    }
    //存到本地
    [UserDefaultsManager setFontsModels:fontArrs];
    
}

/**
 注册自定义字体到系统

 @param path 字体路径
 */
-(void)registerCustomFontWithPath:(NSString*)path
{
    //加载本地字体并注册
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        DbLog(@"不存在这个字体：%@",path);
        return;
    }
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    
    DbLog(@"注册本地字体：%@ ..",path);
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    
    CFErrorRef error;
    if(!CTFontManagerRegisterGraphicsFont(fontRef, &error)){
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }else{
        DbLog(@"注册成功！");
    }
    CGFontRelease(fontRef);
    CGDataProviderRelease(fontDataProvider);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DbLog(@"windows = %ld",[UIApplication sharedApplication].windows.count);
    if ([UserDefaultsManager canShowFlashAD]) {
        [self loadSplashView];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -- 清理本地的所有资料
- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
-(void)removeAllFilesInDoc{
    NSError *error = nil;
    [HYFileManager removeItemAtPath:[SandBoxManager tepmlateDir] error:&error];
    if (error) {
        DbLog(@"%@",error);
    }
    [HYFileManager removeItemAtPath:[SandBoxManager fontDir] error:&error];
    if (error) {
        DbLog(@"%@",error);
    }
}

#pragma mark -- 广告时间到

//开屏广告成功展示
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    DbLog(@"开屏广告展示成功");
    [UserDefaultsManager setShowFlashADOnce];
}
//开屏广告展示失败
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    self.canShowADInWiondw = YES;
    DbLog(@"开屏广告展示失败 %ld %@",error.code,error.localizedDescription);
}
//应用进入后台时回调
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd{
    DbLog(@"开屏应用进入后台");
}
//开屏广告点击回调
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
    DbLog(@"开屏广告被点击");
}
//开屏广告关闭回调
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    DbLog(@"开屏广告被关闭");
    self.canShowADInWiondw = YES;
}

@end
