//
//  PrePhotosCollectionViewCell.m
//  XYW
//
//  Created by xueyognwei on 2017/6/1.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "PrePhotosCollectionViewCell.h"

@implementation PrePhotosCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    
    __weak typeof(self) wkSelf = self;
    [asset thumbnail:^(UIImage *result, NSDictionary *info) {
        wkSelf.imageView.image = result;
    }];
    [asset thumbnail:CGSizeMake(750, 1334) resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            wkSelf.imageView.image = result;
        }else{
            
        }
    }];
}
@end
