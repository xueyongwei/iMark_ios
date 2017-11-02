//
//  water.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/16.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "Sitem.h"
//#import "AreaItem.h"


@interface waterModel : NSObject
@property (nonatomic,strong) NSDate* buildTime;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSNumber *language;
@property (nonatomic,assign)NSNumber *lastUsedTime;
@property (nonatomic,assign)NSNumber *state;
@property (nonatomic,assign)NSNumber *tag;
@property (nonatomic,assign)NSNumber *version;
@end
