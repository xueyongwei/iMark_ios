//
//  PHPhotosManager.m
//  XYW
//
//  Created by xueyognwei on 2017/5/16.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "PHPhotosManager.h"

@implementation PHPhotosManager
+(instancetype)shareInstance{
    static PHPhotosManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
@end
