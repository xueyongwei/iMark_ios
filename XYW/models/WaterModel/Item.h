//
//  Item.h
//  aaa
//
//  Created by xueyongwei on 16/3/16.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImgItem.h"
#import "TextItem.h"
#import "GeoItem.h"
#import "linearLyoutModel.h"

@class Sitem;

@interface Item : NSObject
@property (nonatomic,strong)NSNumber *alpha;
@property (nonatomic,strong)NSNumber *aspectRatio;
@property (nonatomic,strong) ImgItem *imgItem;
@property (nonatomic,strong) NSArray *imgItems;
@property (nonatomic,strong) TextItem *textItem;
@property (nonatomic,strong) Sitem *linearLyout;
@property (nonatomic,strong) GeoItem *geoItem;
@property (nonatomic,strong)NSNumber *bottom;
@property (nonatomic,strong)NSNumber *extendAlignType;
@property (nonatomic,strong)NSNumber *left;
@property (nonatomic,strong)NSNumber *right;
@property (nonatomic,strong)NSNumber *rotate;
@property (nonatomic,assign)BOOL rotateable;
@property (nonatomic,assign)BOOL scaleable;
@property (nonatomic,strong)NSNumber *top;
@property (nonatomic,assign)BOOL ranslateable;
@property (nonatomic,strong)NSNumber *translateDrt;
@property (nonatomic,strong)NSNumber *type;//0主层areaItem 1文字textItem 2图片imgItem
@end
