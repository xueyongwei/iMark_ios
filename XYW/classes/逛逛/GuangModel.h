//
//  GuangModel.h
//  XYW
//
//  Created by xueyognwei on 2017/6/9.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuangModel : NSObject
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *created_time;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)BOOL use_webp;
@property (nonatomic,assign)BOOL adView;
@property (nonatomic,copy) NSString *linkUrl;
@property (nonatomic,strong) NSDictionary *nativeADInfo;
@end
