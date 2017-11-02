//
//  AppDelegate.h
//  XYW
//
//  Created by xueyongwei on 16/3/3.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTSplashAd.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,GDTSplashAdDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GDTSplashAd *splash;
@property (nonatomic,assign) BOOL canShowADInWiondw;
@end

