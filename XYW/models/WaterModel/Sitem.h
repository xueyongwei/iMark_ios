//
//  Sitem.h
//  aaa
//
//  Created by xueyongwei on 16/3/16.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaItem.h"

@interface Sitem : NSObject
@property (nonatomic,assign)NSNumber *alpha;
@property (nonatomic,assign)NSNumber *aspectRatio;
@property (nonatomic,retain) AreaItem* areaItem;
@property (nonatomic,assign)NSArray *colors;
@property (nonatomic,assign)NSNumber *bottom;
@property (nonatomic,assign)NSNumber *extendAlignType;
@property (nonatomic,assign)NSNumber *left;
@property (nonatomic,assign)NSNumber *right;
@property (nonatomic,assign)NSNumber *rotate;
@property (nonatomic,assign)BOOL rotateable;
@property (nonatomic,assign)BOOL scaleable;
@property (nonatomic,assign)NSNumber *top;
@property (nonatomic,assign)BOOL ranslateable;
@property (nonatomic,assign)NSNumber *translateDrt;
@property (nonatomic,assign)NSNumber *type;//0主层areaItem 1文字textItem 2图片imgItem
@end
