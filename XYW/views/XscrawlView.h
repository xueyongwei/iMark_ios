//
//  XscrawlView.h
//  XYW
//
//  Created by xueyongwei on 16/4/1.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "Xview.h"

@interface XscrawlView : Xview
-(Xview *)returnScrawlView:(UIImage *)scrawlImage onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block;
@end
