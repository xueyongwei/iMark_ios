//
//  XwordView.h
//  XYW
//
//  Created by xueyongwei on 16/4/5.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "Xview.h"

@interface XwordView : Xview
@property (nonatomic,copy)NSString *textFontName;
@property (nonatomic,strong)XLabel *label;
@property (nonatomic,strong) void(^xWordViewTextChangedBlock)(void);
-(Xview *)returnWordView:(NSString *)text color:(UIColor *)color fontName:(NSString *)fontName onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block;
//-(void)adjustFont:(UIFont *)aFont;
@end
