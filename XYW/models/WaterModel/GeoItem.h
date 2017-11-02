//
//  GeoItem.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoItem : NSObject
@property (nonatomic,assign)BOOL bold;
@property (nonatomic,copy)NSString *color;
@property (nonatomic,assign)NSNumber *font;
@property (nonatomic,assign)NSNumber *fontHeight;
@property (nonatomic,assign)NSNumber *geoType;
@property (nonatomic,assign)NSNumber *maxLength;
@end
