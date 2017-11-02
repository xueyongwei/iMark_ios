//
//  EditView.h
//  XYW
//
//  Created by xueyongwei on 16/3/21.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Xview.h"
#import "evBgVIew.h"

typedef void(^touchBlock) (UIView *touchedView);
@interface EditView : UIView

@property (strong, nonatomic) IBOutlet evBgVIew *bgView;
@property (nonatomic,strong)UIImage *img;
@property (weak,nonatomic) Xview *currentWaterView;
@property (nonatomic,strong) void(^addSubViewBlock)(Xview *Xview);
@property (nonatomic,strong) void(^tapEmptyBlock)(void);
@property (nonatomic,strong) void(^addSubXviewModelBlock)(XviewModel *aXviewModel);
-(void)noSelected;
@end
