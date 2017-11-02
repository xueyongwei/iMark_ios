//
//  InputView.m
//  XYW
//
//  Created by xueyongwei on 16/4/1.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "InputView.h"

@implementation InputView
- (IBAction)onCancleClick:(UIButton *)sender {
    for (UIView *view  in self.subviews) {//移除inputToolVIew子视图
        [view removeFromSuperview];
    }
    //移除inputToolVIew
    [self removeFromSuperview];
    //移除inputView
    [self.superview removeFromSuperview];
}


@end
