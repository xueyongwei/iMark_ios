//
//  SelectedPhotoCell.h
//  XYW
//
//  Created by xueyongwei on 16/3/15.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLImageHandler.h"
@interface SelectedPhotoCell : UITableViewCell
@property (nonatomic,strong)PHAsset *asset;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,strong)UIImage *img;
@end
