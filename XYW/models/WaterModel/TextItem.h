//
//  TextItem.h
//  aaa
//
//  Created by xueyongwei on 16/3/16.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextItem : NSObject
@property (nonatomic,assign)BOOL bold;
@property (nonatomic,copy)NSString *color;
@property (nonatomic,assign)BOOL eidtable;
@property (nonatomic,assign)NSNumber *font;
@property (nonatomic,assign)NSNumber *fontheight;
@property (nonatomic,assign)NSNumber *lineOrientation;
@property (nonatomic,assign)NSNumber *maxLength;
@property (nonatomic,assign)NSNumber *minLength;
@property (nonatomic,assign)NSNumber *space;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,assign)NSNumber *textOrientation;
@end
