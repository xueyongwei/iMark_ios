//
//  FontModel.m
//  XYW
//
//  Created by xueyongwei on 16/4/7.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "FontModel.h"

@implementation FontModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.language forKey:@"language"];
    [aCoder encodeObject:self.index forKey:@"index"];
    [aCoder encodeObject:self.showName forKey:@"showName"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.fontName forKey:@"fontName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.language = [aDecoder decodeObjectForKey:@"language"];
        self.index = [aDecoder decodeObjectForKey:@"index"];
        self.showName = [aDecoder decodeObjectForKey:@"showName"];
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.fontName = [aDecoder decodeObjectForKey:@"fontName"];
    }
    return self;
}
@end
