//
//  XassetModel.m
//  XYW
//
//  Created by xueyongwei on 16/3/15.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XassetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation XassetModel
- (void)originalImage:(void (^)(UIImage *))returnImage{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib assetForURL:self.imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        CGImageRef imageRef = rep.fullScreenImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        if (image) {
            returnImage(image);
        }else
        {
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
-(UIImage *)thumbnail
{
    UIImage *img = [UIImage imageWithCGImage:self.asset.thumbnail];
    return img;
}
-(UIImage *)originalImage
{
    UIImage *img = [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullScreenImage];
    return img;
}
@end
