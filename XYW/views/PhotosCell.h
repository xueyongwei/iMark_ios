//
//  PhotosCell.h
//  XYW
//
//  Created by xueyognwei on 2017/6/7.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLImageHandler.h"
@protocol PhotosCellDelegate <NSObject>
-(void)selectedCell:(UICollectionViewCell *)photosCell;
@end

@interface PhotosCell : UICollectionViewCell
@property (nonatomic,weak) id<PhotosCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *corverButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)PHAsset *asset;
@end
