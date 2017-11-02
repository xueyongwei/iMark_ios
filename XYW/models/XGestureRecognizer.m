//
//  XGestureRecognizer.m
//  XYW
//
//  Created by xueyongwei on 16/3/30.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "Xview.h"
@implementation XGestureRecognizer

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 判断手势数目,单指手势
    DbLog(@"%lu",[[event touchesForGestureRecognizer:self]count]);
    if ([[event touchesForGestureRecognizer:self]count] > 1) {
        [self setState:UIGestureRecognizerStateFailed];
    }
    Xview *view = (Xview *)[self view];
    [view ontapSelf];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DbLog(@"移动");
    if (self.state == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateBegan];
    } else {
        [self setState:UIGestureRecognizerStateChanged];
    }
    
    Xview *view = (Xview *)[self view];
 
    UITouch *touch = [touches anyObject];
    if (self.view.tag == XXuanzhuan) {
        // 获取手势作用视图
        
        CGPoint center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
        // 获取当前作用手势位置
        CGPoint currentPoint = [touch locationInView:view];
        // 获取之前手势作用位置
        CGPoint previousPoint = [touch previousLocationInView:view];
       
        // 计算x和y差,然后利用tan反函数计算当前角度和手势作用之前角度
        CGFloat currentRotation = atan2f((currentPoint.y - center.y), (currentPoint.x - center.x));
        CGFloat previousRotation = atan2f((previousPoint.y - center.y), (previousPoint.x - center.x));
        // 得出前后手势作用旋转角度（有正负，表示顺时针还是逆时针）
        [self setRotation:(currentRotation - previousRotation)];
        [self ViewShouldsuofang:previousPoint andCur:currentPoint];
        
        return;
    }
    CGPoint tuoPreviousPoint = [touch previousLocationInView:[self getPresentedViewController].view];
    CGPoint tuoCurrentPoint = [touch locationInView:[self getPresentedViewController].view];
    [self viewShouldMove:tuoPreviousPoint andCur:tuoCurrentPoint];
    [((Xview *)self.view) viewMoved];
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
-(void)ViewShouldsuofang:(CGPoint)prevouesPoint andCur:(CGPoint)currentPoint
{
    UIView *view = [self view];
    CGPoint centet = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    double preLen = sqrt((prevouesPoint.x-centet.x)*(prevouesPoint.x-centet.x)+(prevouesPoint.y-centet.y)*(prevouesPoint.y-centet.y));
    double currenLen = sqrt((currentPoint.x-centet.x)*(currentPoint.x-centet.x)+(currentPoint.y-centet.y)*(currentPoint.y-centet.y));
    
    double times = currenLen/preLen;
    
    [self setDetW:currentPoint.x - prevouesPoint.x ];
    [self setDetH:currentPoint.y - prevouesPoint.y ];
    
    [self setScale:times];
}

-(void)viewShouldMove:(CGPoint)prevouesPoint andCur:(CGPoint)currentPoint
{
    //拖动期间不能旋转和缩放
    self.rotation = 0;
    self.scale = 1;
    //计算拖动后的位置
    double deltX = currentPoint.x - prevouesPoint.x;
    double deltY = currentPoint.y - prevouesPoint.y;
    self.view.center = CGPointMake(self.view.center.x+deltX, self.view.center.y+deltY);
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //旋转(拖动)完毕立即设置为拖动状态
    [self view].tag = XTuodong;
    if (self.state == UIGestureRecognizerStateRecognized) {
        [self setState:UIGestureRecognizerStateEnded];
    }else {
        [self setState:UIGestureRecognizerStateFailed];
    }
    [((Xview *)self.view) labelCanEdit];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setState:UIGestureRecognizerStateFailed];
}

@end
