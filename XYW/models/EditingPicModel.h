//
//  EditingPicModel.h
//  XYW
//
//  Created by xueyongwei on 16/4/11.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLImageHandler.h"
#import "Xview.h"

@interface XviewModel : NSObject
@property (nonatomic,assign)CGRect frame;
@property (nonatomic,assign)CGAffineTransform transform;
@property (nonatomic,strong)Xview *view;
@end

@interface EditingPicModel : NSObject
@property (nonatomic,strong)UIImage *img;
@property (nonatomic,strong)PHAsset *asset;//图片信息
@property (nonatomic,assign)NSInteger index;//当前下标

//@property (nonatomic,strong)NSMutableArray *subXviewModelsArray;
@property (nonatomic,assign)CGSize modelOptSize;//对应的操作台大小
@end
