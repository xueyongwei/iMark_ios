//
//  PathModel.m
//  PictureViewer
//
//  Created by xueyongwei on 16/3/23.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "PathModel.h"

@implementation PathModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.path forKey:@"path"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.type = [[aDecoder decodeObjectForKey:@"type"] intValue];
        self.path = [aDecoder decodeObjectForKey:@"path"];
    }
    return self;
}
@end
