//
//  XLabel.h
//  XYW
//
//  Created by xueyongwei on 16/3/29.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import <YYKit.h>
#import <CoreLocation/CoreLocation.h>
@interface XLabel : UILabel <CLLocationManagerDelegate>

//typedef void(^xLabelTextChangedBlock) (XLabel *label);

@property (nonatomic,assign) CGFloat xTop;
@property (nonatomic,assign) CGFloat xBottom;
@property (nonatomic,assign) CGFloat xLeft;
@property (nonatomic,assign) CGFloat xRight;
@property (nonatomic,assign) CGFloat xAspet;

@property (nonatomic,assign) CGFloat xTextFontHeight;
@property (nonatomic,assign)CGFloat xTextMaxLength;
@property (nonatomic,assign)CGFloat xTextMinLength;
@property (nonatomic,assign)NSInteger xTextAlignType;
@property (nonatomic,assign)NSInteger xverticalFormType;
@property (nonatomic,copy)NSString *xTextColor;
@property (nonatomic,copy)NSString *xText;
@property (nonatomic,assign) BOOL xTextEidtable;

@property (nonatomic,assign) BOOL xuBorder;
@property (nonatomic,assign) BOOL stopEdit;
@property (nonatomic,assign) NSUInteger maxlenth;
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic,strong) void(^textChangedBlock)(NSString *newText);

-(void)addTapRecognizer;
-(void)setXLabelItem:(Item *)itm;
-(void)showLabelInSuperView:(UIView *)spView;
@end
