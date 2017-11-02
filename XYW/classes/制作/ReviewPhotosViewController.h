//
//  ReviewPhotosViewController.h
//  XYW
//
//  Created by xueyognwei on 2017/6/1.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLImageHandler.h"
@protocol ReviewPhotosViewControllerDelegate <NSObject>
- (void)selectedPhassetAtIndex:(NSInteger )index;
- (void)deSelectedPhassetAtIndex:(NSInteger )index;
@end

@interface ReviewPhotosViewController : UIViewController
@property (nonatomic,weak) id<ReviewPhotosViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray <PHAsset *>*phAssetsArray;
@property (nonatomic, strong) NSMutableArray <PHAsset *>*selectePHAssets;
@property (nonatomic, assign) NSInteger currentAssetIndex;

@end
