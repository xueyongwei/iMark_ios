//
//  JsonResolver.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^returnBlock) (UIView *view);
@interface JsonResolver : NSObject
-(id)initWIthJson:(NSString *)jsonStr return:(returnBlock)block;
@end
