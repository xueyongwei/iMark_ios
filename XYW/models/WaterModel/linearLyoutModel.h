//
//  linearLyoutModel.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AreaItem;

@interface linearLyoutModel : NSObject
@property (nonatomic,strong) AreaItem *areaItem;
@property (nonatomic,assign) BOOL horizon;
@end
