//
//  Xview.h
//  XYW
//
//  Created by xueyongwei on 16/3/30.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGestureRecognizer.h"
//XLabel是可点击有虚线边框的label
#import "XLabel.h"
#import "XImageView.h"
#import "XiewShowDescModel.h"
typedef enum {
    //以下是枚举成员 TestA = 0,
    XviewTypeWater,
    XviewTypeWord,
    XviewTypeScawl
}XviewType;


@interface Xview : UIView <UIGestureRecognizerDelegate>
typedef void(^tapWaterViewBlock) (Xview *Xview);
typedef void(^xViewChangedBlock) (Xview *Xview);
typedef void(^xViewDeleteBlock) (Xview *Xview);

@property (nonatomic,assign)CGFloat xAscpecRatio;//宽高比
@property (nonatomic,strong)UIButton *xzBtn;
@property (nonatomic,strong)UIButton *delBtn;
@property (nonatomic,strong)UIButton *colorBtn;
@property (nonatomic,assign)BOOL Xselected;
@property (nonatomic,strong)tapWaterViewBlock tapBlock;//点击了该视图后掉用的代码块
@property (nonatomic,strong)xViewChangedBlock changedBlock;//移动或缩放了这个xview
@property (nonatomic,strong)xViewDeleteBlock deleteBlock;//移动或缩放了这个xview
@property (nonatomic,strong)UIView *XbgView;//除了旋转和删除按钮，其他视图放在bgView上
@property (nonatomic,assign)XviewType type;//当前视图的类型
@property (nonatomic,assign)NSUInteger showViewIndex;//当前显示的下标
@property (nonatomic,strong)NSMutableArray <XiewShowDescModel *>*showDescModels;//在各图片上显示的描述模型数组

@property (nonatomic,strong)NSMutableArray *colorBtnsArray;
@property (nonatomic,assign) BOOL showColorBtn;//显示了颜色选择按钮
-(void)ontapSelf;
-(void)viewMoved;
-(void)labelCanEdit;
-(void)willSetXSelected:(BOOL)Xselected;//子类通过重写达到一定目的
- (UIViewController *)getPresentedViewController;
@end
