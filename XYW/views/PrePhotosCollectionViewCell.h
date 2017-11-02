//
//  PrePhotosCollectionViewCell.h
//  XYW
//
//  Created by xueyognwei on 2017/6/1.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "LLImageHandler.h"
@interface PrePhotosCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)PHAsset *asset;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
