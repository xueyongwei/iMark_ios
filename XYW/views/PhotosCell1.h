//
//  PhotosCell.h
//  XYW
//
//  Created by xueyongwei on 16/3/15.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLImageHandler.h"
@interface PhotosCell1 : UICollectionViewCell
//@property (nonatomic,strong)UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *corverButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong)PHAsset *asset;
@end
