//
//  XlocalView.m
//  XYW
//
//  Created by xueyognwei on 2017/5/11.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "XlocalView.h"
#import "SandBoxManager.h"
@implementation XlocalView
-(Xview *)returnWordView:(NSString *)imagePath onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block
{
    if (!imagePath) {
        return nil;
    }
    self.tapBlock = block;
    CGFloat maxLenth = MIN(spView.bounds.size.width, spView.bounds.size.height)*0.6;
    UIImage *image = [UIImage imageWithContentsOfFile:[[SandBoxManager localXviewDir] stringByAppendingPathComponent:imagePath]];
    if (!image) {
        DbLog(@"图片不存在！");
        return nil;
    }
    CGSize size = CGSizeZero;
    if (image.size.width>image.size.height) {
        size.width = maxLenth;
        size.height = maxLenth*(image.size.height/image.size.width);
    }else{
        size.height = maxLenth;
        size.width = maxLenth*(image.size.width/image.size.height);
    }
    self.frame = CGRectMake(0, 0, size.width+20, size.height+20);
    
    self.XbgView.frame = CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
    self.XbgView.layer.borderColor = [UIColor redColor].CGColor;
    self.XbgView.layer.borderWidth = 1.0f;
    self.XbgView.clipsToBounds = YES;
    
    self.xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
    self.delBtn.frame = CGRectMake(0, 0, 20, 20);
    
    XImageView *imgv = [[XImageView alloc]init];
    imgv.xTop = 0;
    imgv.xBottom = 0;
    imgv.xLeft = 0;
    imgv.xRight = 0;
    self.imageView = imgv;
//    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.frame = self.XbgView.bounds;
    [self.XbgView addSubview:self.imageView];
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
-(void)setXselected:(BOOL)Xselected
{
    [super setXselected:Xselected];
//    [self labelShouBorder:Xselected];
}
-(void)labelShouBorder:(BOOL)should
{
    for (UIView *v  in self.XbgView.subviews) {
        if ([v isKindOfClass:[XLabel class]]) {
            XLabel *lb = (XLabel *)v;
            lb.xuBorder = should?YES:NO;
        }
    }
}



@end
