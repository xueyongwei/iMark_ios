//
//  SCdlModel.m
//  XYW
//
//  Created by xueyongwei on 16/4/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SCdlModel.h"

@implementation SCdlModel
/*
 @property (nonatomic,copy)NSString *category;
 @property (nonatomic,copy)NSString *downloadUrl;
 @property (nonatomic,copy)NSString *iconUrl;
 @property (nonatomic,copy)NSString *name;
 @property (nonatomic,copy)NSString *Dlid;
 @property (nonatomic,copy)NSString *Tp;
 @property (nonatomic,copy)NSString *size;
 */

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.downloadUrl forKey:@"downloadUrl"];
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.Dlid forKey:@"Dlid"];
    [aCoder encodeObject:self.Tp forKey:@"Tp"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.localDirPath forKey:@"localDirPath"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.downloadUrl = [aDecoder decodeObjectForKey:@"downloadUrl"];
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.Dlid = [aDecoder decodeObjectForKey:@"Dlid"];
        self.Tp = [aDecoder decodeObjectForKey:@"Tp"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.localDirPath = [aDecoder decodeObjectForKey:@"localDirPath"];
    }
    return self;
}
@end
