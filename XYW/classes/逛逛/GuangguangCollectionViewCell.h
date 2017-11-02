//
//  GuangguangCollectionViewCell.h
//  XYW
//
//  Created by xueyognwei on 2017/6/8.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuangModel.h"
@interface GuangguangCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)GuangModel *model;
@end
