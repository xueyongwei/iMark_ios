//
//  XassetModel.h
//  XYW
//
//  Created by xueyongwei on 16/3/15.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface XassetModel : NSObject
@property (nonatomic,strong) ALAsset *asset;//asset
@property (nonatomic,copy) NSURL *imageURL;//原图url
@property (nonatomic,assign) BOOL isSelected;//是否被选中
- (void)originalImage:(void (^)(UIImage *image))returnImage;//获取原图
-(UIImage *)thumbnail;
-(UIImage *)originalImage;
@end
