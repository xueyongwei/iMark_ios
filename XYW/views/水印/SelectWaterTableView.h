//
//  SelectWaterTableView.h
//  XYW
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XhorTableView.h"
#import "XhorTableView.h"
#import "WaterCollectionViewCell.h"
#import "PathModel.h"
#import "ShangChengViewController.h"
#import "ShangChengCollectionViewCell.h"
#import "EditView.h"
@interface localWaterModel :NSObject
@property (nonatomic,copy)NSString *imgName;
@property (nonatomic,strong) UIImage *thumbImage;
@end

@interface SelectWaterTableView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet XhorTableView *XtableView;
@property (weak, nonatomic) IBOutlet UIButton *onBtn;

@property (nonatomic,strong) UIImage *thumbnail;//缩略图
@property (nonatomic,retain) UIViewController *vc;
@property (nonatomic,strong) EditView *ev;
-(void)reloadCollection;
-(void)refreshData;
@end
