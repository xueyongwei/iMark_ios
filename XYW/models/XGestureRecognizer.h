//
//  XGestureRecognizer.h
//  XYW
//
//  Created by xueyongwei on 16/3/30.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置目标视图的tag即可改变拖动还是旋转的状态
typedef enum {
    XTuodong,
    XXuanzhuan,
}XSTAY;
@interface XGestureRecognizer : UIGestureRecognizer
@property (nonatomic,assign)BOOL pan;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat detLenth;
@property (nonatomic, assign) CGFloat detW;
@property (nonatomic, assign) CGFloat detH;
@end
