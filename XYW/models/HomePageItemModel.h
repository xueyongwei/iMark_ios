//
//  HomePageItemModel.h
//  XYW
//
//  Created by xueyognwei on 2017/5/31.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <InMobiSDK/InMobiSDK.h>
@interface HomePageItemModel : NSObject
@property (nonatomic,strong) IMNative *native;
@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,copy)NSString *titleName;
@property (nonatomic,copy)NSString *segueIdentifier;
+(id)modelWithImageName:(NSString *)imageName titleName:(NSString *)titleName segueIdentifier:(NSString *)segueIdentifier;
@end
