//
//  evBgVIew.m
//  XYW
//
//  Created by xueyongwei on 16/4/11.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "evBgVIew.h"
@implementation evBgVIew

-(void)addSubview:(Xview *)view
{
    [super addSubview:view];
    if ([view isKindOfClass:[Xview class]]) {
        DbLog(@"添加了个%@",view);
        if (self.addSubViewBlock) {
            self.addSubViewBlock(view);
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
