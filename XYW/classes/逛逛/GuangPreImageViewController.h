//
//  GuangPreImageViewController.h
//  XYW
//
//  Created by xueyognwei on 2017/6/12.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuangModel.h"
@protocol GuangPreImageViewControllerDelegate <NSObject>
- (void)showImageOfIndex:(NSInteger )index;
- (void)detailVCDismissWithIndex:(NSInteger )index;
@end

@interface GuangPreImageViewController : UIViewController
@property (nonatomic,weak) id <GuangPreImageViewControllerDelegate> delegate;
@property (nonatomic, strong)  NSMutableArray <GuangModel *> *guangModelsArray;
@property (nonatomic, assign) NSInteger currentImageIndex;
-(void)reloadData;
@end
