//
//  ScrewlView.h
//  XYW
//
//  Created by xueyongwei on 16/3/29.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "EditView.h"

@interface SelectScrewlView : UIView
@property (weak, nonatomic) IBOutlet DrawView *DrawView;

@property (weak, nonatomic) IBOutlet UIScrollView *colorPickerScrolView;
@property (weak, nonatomic) IBOutlet UIView *toolBgView;
@property (nonatomic,strong) EditView *ev;
@property (nonatomic,strong)NSMutableArray *colorArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgBottomConst;
@property (nonatomic,strong) void(^dissMissBlock)(void);
-(void)animateShow;
@end
