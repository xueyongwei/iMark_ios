//
//  HomePageItemModel.m
//  XYW
//
//  Created by xueyognwei on 2017/5/31.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "HomePageItemModel.h"

@implementation HomePageItemModel
+(id)modelWithImageName:(NSString *)imageName titleName:(NSString *)titleName segueIdentifier:(NSString *)segueIdentifier{
    HomePageItemModel *model = [[HomePageItemModel alloc]init];
    model.imageName = imageName;
    model.titleName = titleName;
    model.segueIdentifier = segueIdentifier;
    return model;
}
@end
