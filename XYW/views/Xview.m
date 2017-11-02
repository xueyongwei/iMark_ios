//
//  Xview.m
//  XYW
//
//  Created by xueyongwei on 16/3/30.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "Xview.h"
@class EditView;

@implementation Xview
-(void)ontapSelf{
    DbLog(@"子类需要重写我");
}
#pragma mark -- 🎬 父视图的btn
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]||[otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }else{
        return NO;
    }
}
-(NSMutableArray *)colorBtnsArray
{
    if (!_colorBtnsArray) {
        _colorBtnsArray = [[NSMutableArray alloc]init];
    }
    return _colorBtnsArray;
}
-(UIButton *)xzBtn
{
    if (!_xzBtn) {
        _xzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xzBtn.userInteractionEnabled = YES;
     
        [_xzBtn setBackgroundImage:[UIImage imageNamed:@"xz"] forState:UIControlStateNormal];
        [_xzBtn addTarget:self action:@selector(onXzTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.xzBtn];
        _xzBtn.frame = CGRectMake(self.bounds.size.width-50, self.bounds.size.height-50, 50, 50);
    }
    
    [self bringSubviewToFront:_xzBtn];
    return _xzBtn;
}
-(UIButton *)colorBtn
{
    if (!_colorBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"write_inputfield_color"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(self.bounds.size.width-20, 0, 20, 20);
        //            btn.backgroundColor = [UIColor redColor];
        _colorBtn = btn;
    }
    return _colorBtn;
}

-(UIButton *)delBtn
{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.userInteractionEnabled = YES;
        
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(onDelclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.delBtn];
        _delBtn.frame = CGRectMake(0, 0, 50, 50);
    }
    
    [self bringSubviewToFront:_delBtn];
    return _delBtn;
}
#pragma mark -- 🖐️ 父视图的btn点击事件
-(void)onDelclick:(UIButton *)sender
{
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}
-(void)onXzTouchDown:(UIButton *)sender
{
    self.tag = XXuanzhuan;
}
#pragma mark -- 🔌 初始化父视图
-(UIView *)XbgView
{
    if (!_XbgView) {
        _XbgView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_XbgView];
    }
    return _XbgView;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.showDescModels = [[NSMutableArray alloc]init];
        [self XviewOpear];
    }
    return self;
}

-(void)setShowViewIndex:(NSUInteger)showViewIndex
{
    _showViewIndex = showViewIndex;
    XiewShowDescModel *showModel = self.showDescModels[showViewIndex];
    if (showModel.hidden) {
        if ([[NSThread currentThread]isMainThread]) {
            self.hidden = YES;
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.hidden = YES;
            });
        }
    }else{
        CGRect spViewBounds = self.superview.bounds;
        if ([[NSThread currentThread]isMainThread]) {
            [self setSelfFrameWithShowModel:showModel inSpViewOfBounds:spViewBounds];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self setSelfFrameWithShowModel:showModel inSpViewOfBounds:spViewBounds];
            });
        }
    }
}

-(void)setSelfFrameWithShowModel:(XiewShowDescModel *)showModel inSpViewOfBounds:(CGRect)spViewBounds
{
    self.hidden = NO;
    DbLog(@"当前显示图片的操作台大小%@",NSStringFromCGRect(spViewBounds));
    
//    CGFloat aspectRatio = (float)self.width/self.height;
    CGFloat aspectRatio = self.xAscpecRatio;
     DbLog(@"水印视图的宽高比：%f",aspectRatio);
    CGPoint finalCenter = CGPointZero;
    finalCenter.x = showModel.xScale * spViewBounds.size.width;
    finalCenter.y = showModel.yScale * spViewBounds.size.height;
    
    CGRect finalFrame = CGRectZero;
    if (spViewBounds.size.width>spViewBounds.size.height) {//宽大于高
        CGFloat height = spViewBounds.size.height*(1-showModel.xtop-showModel.xbottom);
        CGFloat width = height * aspectRatio;
        finalFrame = CGRectMake(0, 0, width, height);
//        CGFloat minH = spViewBounds.size.height *showModel.minLenthScale;
//        CGFloat viewW = minH * aspectRatio;
//        finalFrame = CGRectMake(0, 0, viewW, minH);
        
        
    }else{
//        CGFloat minW = spViewBounds.size.width *showModel.minLenthScale;
//        CGFloat viewH = minW / (float)aspectRatio;
//        finalFrame = CGRectMake(0, 0, minW , viewH);
        CGFloat width = spViewBounds.size.width*(1-showModel.xleft-showModel.xright);
        CGFloat height = width/aspectRatio;
        finalFrame = CGRectMake(0, 0, width, height);
    }

    self.bounds = finalFrame;
    self.center = finalCenter;
    self.transform = showModel.transform;
    
    [self layoutXviewSubviews];
    
}

/**
 刷新下子控件的布局
 */
-(void)layoutXviewSubviews{
    [self setNeedsDisplay];
    self.XbgView.frame = CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
    self.delBtn.frame =CGRectMake(0, 0, 20, 20);
    self.xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
    self.colorBtn.frame = CGRectMake(self.bounds.size.width-20, 0, 20, 20);
    [self setNeedsDisplay];
    DbLog(@"当前显示XbgView大小%@",NSStringFromCGRect(self.XbgView.frame));
    
    for (UIView *subView in self.XbgView.subviews) {//布局子控件
        if ([subView isKindOfClass:[XLabel class]]) {
            XLabel *label = (XLabel *)subView;
            
            [label showLabelInSuperView:self.XbgView];
        }else if ([subView isKindOfClass:[XImageView class]]){
            XImageView *ximageView = (XImageView *)subView;
            [ximageView showXImageViewInSuperView:self.XbgView];
        }
    }
}
-(void)XviewOpear
{
    XGestureRecognizer *xs = [[XGestureRecognizer alloc]initWithTarget:self action:@selector(onXsHandle:)];
    xs.delegate = self;
    [self addGestureRecognizer:xs];
    self.Xselected = YES;
}

//必须先缩放后旋转
-(void)onXsHandle:(XGestureRecognizer *)recognizer
{
    CGRect orgiBounds = self.bounds;
    CGRect finalBounds = CGRectZero;
    
    finalBounds.size.width = orgiBounds.size.width * recognizer.scale ;
    finalBounds.size.height = orgiBounds.size.height * recognizer.scale ;
    
    self.bounds = finalBounds;
    
    DbLog(@"frame=%@ bounds=%@",NSStringFromCGRect(self.frame) ,NSStringFromCGRect(self.bounds));

    //重新布局子控件
    [self layoutXviewSubviews];
    
    //旋转
    self.transform = CGAffineTransformRotate(self.transform, recognizer.rotation);
    recognizer.rotation = 0;
    [self setNeedsDisplay] ;
    __weak typeof(self) wkSelf = self;
    DbLog(@"changedBlock..");
    self.changedBlock(wkSelf);
    
}
-(void)viewMoved{
    DbLog(@"如果想要在视图移动的时候做些什么，可以重写我");
}
-(void)labelCanEdit{
    DbLog(@"labelCanEdit，可以重写我");
}
-(void)setXselected:(BOOL)Xselected
{
    if (self.showColorBtn) {
        for (UIButton *btn in self.colorBtnsArray) {
            [btn removeFromSuperview];
        }
        self.showColorBtn = NO;
        return;
    }
    DbLog(@"父类 Xselectef = %d",Xselected);
    [self willSetXSelected:Xselected];
    _Xselected = Xselected;
    self.xzBtn.hidden = Xselected?NO:YES;
    self.delBtn.hidden = Xselected?NO:YES;
    self.colorBtn.hidden = Xselected?NO:YES;
    self.XbgView.layer.borderWidth = Xselected?1.0f:0.0f;
    
}
-(void)willSetXSelected:(BOOL)Xselected{
    DbLog(@"如果想要在设置selected之前做些什么，可以重写我");
}
- (UIViewController *)getPresentedViewController
{
    //取VC
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
        CGPoint xzbuttonPoint = [_xzBtn convertPoint:point fromView:self];
        if ([_xzBtn pointInside:xzbuttonPoint withEvent:event]) {
            self.tag = XXuanzhuan;
        }
        CGPoint dlbuttonPoint = [_delBtn convertPoint:point fromView:self];
        if ([_delBtn pointInside:dlbuttonPoint withEvent:event]) {
            [self onDelclick:nil];
            return nil;
        }
        return view;
}





@end
