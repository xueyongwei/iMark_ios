//
//  EditView.m
//  XYW
//
//  Created by xueyongwei on 16/3/21.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "EditView.h"
#import "XwaterView.h"


@interface EditView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgVIewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewW;

@end
@implementation EditView

-(void)setImg:(UIImage *)img
{
    if (!img) {
        return;
    }
    self.bgView.addSubViewBlock = self.addSubViewBlock;
    CGSize boundsize = self.bounds.size;
    CGFloat imgRatio = img.size.width/img.size.height;
    CGFloat boundsRatio = boundsize.width/boundsize.height;
    
    if (imgRatio>=boundsRatio) {//宽大于高
        self.bgViewW.constant = boundsize.width;
        self.bgVIewH.constant = boundsize.width/imgRatio;
    }else {
        self.bgVIewH.constant = boundsize.height;
        self.bgViewW.constant = boundsize.height*imgRatio;
    }
//    if (img.size.width>=img.size.height) {
//        self.bgViewW.constant = self.bounds.size.width;
//        self.bgVIewH.constant = self.bounds.size.width*img.size.height/img.size.width;
//    }else{
//        self.bgVIewH.constant = self.bounds.size.height;
//        self.bgViewW.constant = self.bounds.size.height*img.size.width/img.size.height;
//    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.imgView.image = img;
}
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    DbLog(@"%@",view);
    return view;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    UIView *view = [touch view];
    if ([view isKindOfClass:[evBgVIew class]] || view == self) {
        if (self.currentWaterView) {
            self.currentWaterView.Xselected = NO;
//            _currentWaterView = nil;
        }
    }
    if (self.tapEmptyBlock) {
        self.tapEmptyBlock();
    }
}

-(void)setCurrentWaterView:(Xview *)currentWaterView
{
    Xview *preV = _currentWaterView;
    if (preV) {
        preV.Xselected = NO;
    }
    
    currentWaterView.Xselected = YES;
    _currentWaterView = currentWaterView;
    
}
-(void)noSelected
{
    self.currentWaterView.Xselected = NO;
}


//-(void)addSubview:(UIView *)view
//{
//    [self.bgView addSubview:view];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
