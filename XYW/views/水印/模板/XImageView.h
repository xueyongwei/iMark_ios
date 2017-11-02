//
//  XImageView.h
//  XYW
//
//  Created by xueyognwei on 2017/5/25.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@interface XImageView : UIImageView <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,assign) CGFloat xTop;
@property (nonatomic,assign) CGFloat xBottom;
@property (nonatomic,assign) CGFloat xLeft;
@property (nonatomic,assign) CGFloat xRight;
@property (nonatomic,assign) CGFloat xAspet;
@property (nonatomic,assign) CGFloat xEditable;
@property (nonatomic,copy) NSString *xPath;
-(void)setXImageViewItem:(Item *)itm path:(NSString *)path index:(NSInteger)index;
-(void)setXImageViewItem:(Item *)itm path:(NSString *)path;
-(void)showXImageViewInSuperView:(UIView *)spView;
-(void)changeToIndex:(NSInteger )index;
@end
