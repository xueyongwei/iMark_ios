//
//  JsonResolver.m
//  PictureViewer
//
//  Created by xueyongwei on 16/3/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "JsonResolver.h"
#import "waterModel.h"

@implementation JsonResolver
{
    returnBlock tempBlock;
}
-(id)initWIthJson:(NSString *)jsonStr return:(returnBlock)block
{
    self = [super init];
    if (self) {
        tempBlock = block;
        [self getModelFromeJsonStr:jsonStr];
    }
    return self;
}
-(void)getModelFromeJsonStr:(NSString *)jsonStr
{
    waterModel *model = [waterModel mj_objectWithKeyValues:jsonStr];
    DbLog(@"%@",model.items);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.tag = model.tag.integerValue;
    tempBlock(view);
}
@end
