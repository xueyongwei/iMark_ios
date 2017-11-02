//
//  XscrawlView.m
//  XYW
//
//  Created by xueyongwei on 16/4/1.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XscrawlView.h"

@implementation XscrawlView

-(Xview *)returnScrawlView:(UIImage *)scrawlImage onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block
{
    if (!scrawlImage) {
        return nil;
    }
    
    self.tapBlock = block;
    CGSize size = scrawlImage.size;
    self.frame = CGRectMake(0, 0, size.width+20, size.height+20);
    self.XbgView.frame = CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
    self.XbgView.layer.borderColor = [UIColor redColor].CGColor;
    self.XbgView.layer.borderWidth = 1.0f;
    self.XbgView.clipsToBounds = YES;

    self.xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
    self.delBtn.frame = CGRectMake(0, 0, 20, 20);
    
    self.center = CGPointMake(spView.bounds.size.width/2, spView.bounds.size.height/2);
    
    XImageView *imgv = [[XImageView alloc]init];
    imgv.xTop = 0;
    imgv.xBottom = 0;
    imgv.xLeft = 0;
    imgv.xRight = 0;
    
    imgv.frame = self.XbgView.bounds;
    imgv.clipsToBounds = YES;
    imgv.image = scrawlImage;
    [self.XbgView addSubview:imgv];
    
    [spView addSubview:self];
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.tapBlock) {
        self.tapBlock(self);
        DbLog(@"我被掉用了");
    }
}
-(void)ontapSelf
{
    DbLog(@"touch Xview");
    if (self.tapBlock) {
        self.tapBlock(self);
        DbLog(@"我被掉用了");
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
