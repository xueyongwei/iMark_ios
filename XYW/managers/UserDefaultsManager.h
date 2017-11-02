//
//  UserDefaultsManager.h
//  XYW
//
//  Created by xueyognwei on 2017/5/3.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PicQuality) {
    PicQualityNormal,//默认0
    PicQualityHeight,
    PicQualityOriginal,
};
@interface UserDefaultsManager : NSObject

//设置图片质量
+(void)setPicQuality:(PicQuality)quality;
+(PicQuality)CurrentPicQuality;

//自动保存到相册
+(void)setSaveImageAuto:(BOOL)autoSave;
+(BOOL)isAutoSaveImage;

//设置本地字体models
+(void)setFontsModels:(NSArray *)fontModels;
+(NSArray *)fontsModelsInstalled;

//设置本地模版models
+(void)setTemplateModels:(NSArray *)templateModels;
+(NSArray *)templateModelsInstalled;

//设置已下载模版的ID
+(void)setDowmloadTemplateModelIDs:(NSArray *)dowmloadTemplateModelIDs;
+(NSArray *)dowmloadTemplateModelIDs;

//是否已解锁9张
+(void)setHaveUnlock9:(BOOL)unlock;
+(BOOL)HaveUnlock9;

//分享到逛逛限制
+(void)setAddOnceShareToGuang;
+(BOOL)canShareToGuangToday;

//显示广告时间限制
+(void)setShowFlashADOnce;
+(BOOL)canShowFlashAD;
@end
