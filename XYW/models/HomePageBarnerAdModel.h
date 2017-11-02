//
//  HomePageBarnerAdModel.h
//  XYW
//
//  Created by xueyognwei on 2017/6/7.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <InMobiSDK/InMobiSDK.h>
typedef NS_ENUM(NSInteger,Url_actionStyle) {
    Url_actionStyleH5_inner,
    Url_actionStyleSystem_action,
    Url_actionStyleLocalImage,
};

@interface HomePageBarnerAdModel : NSObject
@property (nonatomic,strong) IMNative *native;
@property (nonatomic,copy) NSString *title;//这里是标题
@property (nonatomic,copy) NSString *banner;//图片URL
@property (nonatomic,copy) NSString *url;//跳转商店的URL地址
@property (nonatomic,assign) Url_actionStyle url_action;//URL对应的操作 1=h5_inner, 2=system_action
-(void)openAd;
@end
