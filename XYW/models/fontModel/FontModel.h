//
//  FontModel.h
//  XYW
//
//  Created by xueyongwei on 16/4/7.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontModel : NSObject<NSCoding>
@property (nonatomic,retain)NSNumber *type;
@property (nonatomic,retain)NSNumber *language;
@property (nonatomic,retain)NSNumber *index;
@property (nonatomic,copy)NSString *showName;
@property (nonatomic,copy)NSString *filePath;
@property (nonatomic,copy)NSString *fontName;
@end
