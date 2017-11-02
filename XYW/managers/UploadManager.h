//
//  UploadManager.h
//  XYW
//
//  Created by xueyognwei on 2017/6/9.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadManager : NSObject
+(instancetype)manager;
-(void)uploadImages:(NSArray *)images;
@end
