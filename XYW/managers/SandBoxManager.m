//
//  SandBoxManager.m
//  XYW
//
//  Created by xueyognwei on 2017/5/8.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "SandBoxManager.h"

@implementation SandBoxManager
+(NSString *)documentDir{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}
+(NSString *)tepmlateDir{
    return [[self documentDir] stringByAppendingPathComponent:@"template"];
}
+(NSString *)fontDir{
    return [[self documentDir] stringByAppendingPathComponent:@"font"];
}
+(NSString *)localXviewDir{
    return [[self documentDir] stringByAppendingPathComponent:@"localWater"];
}
@end
