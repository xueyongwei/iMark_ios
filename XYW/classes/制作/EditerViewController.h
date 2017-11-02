//
//  EditerViewController.h
//  XYW
//
//  Created by xueyongwei on 16/3/21.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XassetModel.h"
#import "EditView.h"
#import "LLImageHandler.h"
@interface EditerViewController : BaseViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *naviBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *naviScrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIView *ipTV;
@property (nonatomic, strong) NSArray <PHAsset *>*assetArray;
//-(void)setWannaEditPHAssetArray:(NSArray *)assetArray;
@end
