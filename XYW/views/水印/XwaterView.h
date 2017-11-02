//
//  Xwater.h
//  XYW
//
//  Created by xueyongwei on 16/3/30.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "Xview.h"
#import "waterModel.h"
#import "UIColor+Extend.h"
#import "InputTextViewController.h"

@interface XwaterView : Xview <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray *labels;

-(Xview *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView;
-(Xview *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block;
@end
