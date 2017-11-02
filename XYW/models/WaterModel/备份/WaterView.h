//
//  WaterView.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "waterModel.h"
#import "XsingleRotationRecoginzer.h"
#import "UIColor+Extend.h"
#import "InputTextViewController.h"
typedef void(^tapWaterViewBlock) (UIView *Xview);
@interface WaterView : UIView
@property (nonatomic,strong)UIButton *xzBtn;
@property (nonatomic,strong)UIButton *delBtn;
@property (nonatomic,assign)BOOL Xselected;
@property (nonatomic,strong)NSMutableArray *labels;
-(UIView *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView;
-(UIView *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block;
@end
