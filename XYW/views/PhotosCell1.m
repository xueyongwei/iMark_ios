//
//  PhotosCell.m
//  XYW
//
//  Created by xueyongwei on 16/3/15.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "PhotosCell1.h"

@implementation PhotosCell1

-(void)setAsset:(PHAsset *)asset
{
    _asset = asset;
//    __weak typeof(self) wkSelf = self;
    [asset thumbnail:^(UIImage *result, NSDictionary *info) {
        self.imgView.image = result;
    }];
}
//-(void)setImage:(UIImage *)image
//{
//    self.imgView.image = image;
//}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _corverButton.selected = selected;
}
@end
