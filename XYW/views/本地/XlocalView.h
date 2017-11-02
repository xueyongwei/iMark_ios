//
//  XlocalView.h
//  XYW
//
//  Created by xueyognwei on 2017/5/11.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "Xview.h"

@interface XlocalView : Xview
@property (nonatomic,copy)NSString *imagePath;
@property (nonatomic,strong)UIImageView *imageView;
-(Xview *)returnWordView:(NSString *)imagePath onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block;
@end
