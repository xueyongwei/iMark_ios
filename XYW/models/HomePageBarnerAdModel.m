//
//  HomePageBarnerAdModel.m
//  XYW
//
//  Created by xueyognwei on 2017/6/7.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "HomePageBarnerAdModel.h"

@implementation HomePageBarnerAdModel

/**
 代开服务器的广告
 */
-(void)openAd{
    NSURL *url = [NSURL URLWithString:self.url];
    if (url && [[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
}
@end
