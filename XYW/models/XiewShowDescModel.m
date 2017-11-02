//
//  XiewShowDescModel.m
//  XYW
//
//  Created by xueyognwei on 2017/5/24.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "XiewShowDescModel.h"

@implementation XiewShowDescModel
-(void)setCenter:(CGPoint)center
{
    _center = center;
    DbLog(@"%@ center %@",self,NSStringFromCGPoint(center));
}
@end
