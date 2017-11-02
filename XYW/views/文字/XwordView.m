//
//  XwordView.m
//  XYW
//
//  Created by xueyongwei on 16/4/5.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XwordView.h"
#import "InputTextViewController.h"

@implementation XwordView
{
    BOOL cannotEdit;
}
-(Xview *)returnWordView:(NSString *)text color:(UIColor *)color fontName:(NSString *)fontName onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block
{
    if (!text) {
        return nil;
    }
    self.tapBlock = block;
    UIFont *aFont = [UIFont fontWithName:fontName size:30];
    self.center = CGPointMake(spView.bounds.size.width/2, spView.bounds.size.height/2);
    [self resizeSpView:spView withText:text font:aFont];
    
    XLabel *label = [[XLabel alloc]init];
    label.xText = text;
    self.label = label;
//    label.frame = CGRectMake(5, 5, self.XbgView.bounds.size.width-10, self.XbgView.bounds.size.height-10);
    label.frame = CGRectMake(0, 0, self.XbgView.bounds.size.width, self.XbgView.bounds.size.height);

    label.xTop = 0;
    label.xBottom = 0;
    label.xLeft = 0;
    label.xRight = 0;
    label.xTextEidtable = YES;
    label.maxlenth = -1;
    __weak typeof(self) wkSelf = self;
    
    label.textChangedBlock = ^(NSString *newText) {
        [wkSelf resizeSpView:spView withText:newText font:wkSelf.label.font];
        [wkSelf.label showLabelInSuperView:wkSelf.XbgView];
    };
    [label addTapRecognizer];
    
    label.font = aFont;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = color?color:[UIColor colorWithHexString:@"ff8a80"];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = NO;

    label.xTextFontHeight = 30/self.XbgView.bounds.size.height;
    
    self.XbgView.layer.borderWidth = 0.0f;
    
    [self.XbgView addSubview:self.label];
    [self.label showLabelInSuperView:self.XbgView];
    [self bringSubviewToFront:self.xzBtn];
    [self bringSubviewToFront:self.delBtn];
    [spView addSubview:self];
    return self;
}
-(void)willSetXSelected:(BOOL)Xselected
{
    
}

-(void)resizeSpView:(UIView *)spView withText:(NSString *)text font:(UIFont *)aFont{
    NSDictionary *attrs = @{NSFontAttributeName : aFont};
    CGSize fontSize=[text sizeWithAttributes:attrs];
    
    CGRect selfBounds = CGRectMake(0, 0, fontSize.width+20, fontSize.height+20);
    self.bounds = selfBounds;
    
    self.XbgView.frame = CGRectMake(10, 10, selfBounds.size.width-20, selfBounds.size.height-20);
    self.XbgView.layer.borderColor = [UIColor redColor].CGColor;
    
    self.XbgView.clipsToBounds = NO;
    
    self.xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
    self.delBtn.frame = CGRectMake(0, 0, 20, 20);
    [self.label showLabelInSuperView:self.XbgView];
    if (self.xWordViewTextChangedBlock) {
        self.xWordViewTextChangedBlock();
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
    [self.label setXuBorder:Xselected];
}
-(void)viewMoved
{
    DbLog(@"viewMoved");
    self.label.stopEdit = YES;
}
-(void)labelCanEdit
{
    DbLog(@"labelCanEdit");
    self.label.stopEdit = NO;
//    if (self.label.stopEdit) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.label.stopEdit = NO;
//        });
//        
//    }else{
//        
//    }
    
}

@end
