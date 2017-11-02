//
//  SelectedPhotoCell.m
//  XYW
//
//  Created by xueyongwei on 16/3/15.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SelectedPhotoCell.h"
@interface SelectedPhotoCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end
@implementation SelectedPhotoCell
-(void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    __weak typeof(self) wkSelf = self;
    [asset thumbnail:^(UIImage *result, NSDictionary *info) {
        wkSelf.imgView.image = result;
    }];
}
-(void)setImg:(UIImage *)img
{
    self.imgView.image = img;
    
}

@end
