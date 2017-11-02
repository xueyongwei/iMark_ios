//
//  LJBaseModel.m
//  Pinaster
//
//  Created by LJ_Keith on 16/12/8.
//  Copyright © 2016年 linyoulu. All rights reserved.
//

#import "LJBaseModel.h"
#import <YYKit.h>


@implementation LJBaseModel

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [self modelEncodeWithCoder:aCoder];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
    
}

-(id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
//    return [self yy_modelCopy];
    
}
-(NSUInteger)hash{
    
    return [self modelHash];
    
}

-(BOOL)isEqual:(id)object{

    return [self modelIsEqual:object];
    
}
//避开关键字
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id",
             @"Description" : @"description",
             };
}

@end

@implementation LSDrawModel


@end

@implementation LSPointModel


@end

@implementation LSBrushModel


@end

@implementation LSActionModel


@end

@implementation LSDrawPackage


@end

@implementation LSDrawFile


@end


