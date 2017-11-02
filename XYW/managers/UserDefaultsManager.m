//
//  UserDefaultsManager.m
//  XYW
//
//  Created by xueyognwei on 2017/5/3.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "UserDefaultsManager.h"
#import "NSDate+Extend.h"
#import <YYKit.h>
@implementation UserDefaultsManager
//图片清晰度
+(void)setPicQuality:(PicQuality)quality{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setObject:@(quality) forKey:@"picQuality"];
    [usf synchronize];
}

+(PicQuality)CurrentPicQuality{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSNumber *nub = [usf objectForKey:@"picQuality"];
    return nub.integerValue;
}

+(void)setSaveImageAuto:(BOOL)autoSave{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setBool:autoSave forKey:@"autosave"];
    [usf synchronize];
}
+(BOOL)isAutoSaveImage{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf boolForKey:@"autosave"];;
}

+(void)setFontsModels:(NSArray *)fontModels{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setObject:fontModels forKey:@"fontModels"];
    [usf synchronize];
}
+(NSArray *)fontsModelsInstalled{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf objectForKey:@"fontModels"];
}

+(void)setTemplateModels:(NSArray *)template{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setObject:template forKey:@"pathModels"];
    [usf synchronize];
}
+(NSArray *)templateModelsInstalled{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf objectForKey:@"pathModels"];
}
+(void)setHaveUnlock9:(BOOL)unlock{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setBool:unlock forKey:@"HaveUnlock9"];
    [usf synchronize];
}
+(BOOL)HaveUnlock9{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf boolForKey:@"HaveUnlock9"];;
}

//设置已下载模版的ID
+(void)setDowmloadTemplateModelIDs:(NSArray *)dowmloadTemplateModelIDs{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setObject:dowmloadTemplateModelIDs forKey:@"dowmloadTemplateModelIDs"];
    [usf synchronize];
}
+(NSArray *)dowmloadTemplateModelIDs{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    return [usf objectForKey:@"dowmloadTemplateModelIDs"];
}

//分享到逛逛

+(void)setAddOnceShareToGuang{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSDictionary *timeDic = [usf objectForKey:@"ShareToGuangTimes"];
    NSDate *date =timeDic[@"date"];
    NSNumber *times = timeDic[@"times"];
    NSMutableDictionary *thisDic = [[NSMutableDictionary alloc]initWithDictionary:timeDic];
    if (date && [date isToday]) {
        [thisDic setObject:@(times.integerValue +1) forKey:@"times"];
    }else{
        [thisDic setObject:@(1) forKey:@"times"];
        [thisDic setObject:[NSDate date] forKey:@"date"];
    }
    [usf setObject:thisDic forKey:@"ShareToGuangTimes"];
    [usf synchronize];
}

+(BOOL)canShareToGuangToday{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSDictionary *timeDic = [usf objectForKey:@"ShareToGuangTimes"];
    NSDate *date =timeDic[@"date"];
    NSNumber *times = timeDic[@"times"];
    if (date && [date isToday]) {
        if (times.integerValue>=3) {//已保存了三次了
            return NO;
        }
    }
    return YES;
}
+(void)setShowFlashADOnce{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    [usf setObject:[NSDate date] forKey:@"ShowFlashADOnce"];
    [usf synchronize];
}
+(BOOL)canShowFlashAD{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSDate *date = [usf objectForKey:@"ShowFlashADOnce"];
    NSTimeInterval passtime = fabs([date timeIntervalSinceNow]);
    if (passtime/60>=1) {//超过1分钟
        return YES;
    }
    return NO;
//    NSDate *maxDate = [date dateByAddingMinutes:5];
//    
//    if ([[NSDate date] earlierDate:maxDate]) {
//        return NO;
//    }
//    return YES;
}
@end
