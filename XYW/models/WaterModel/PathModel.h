//
//  PathModel.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/23.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathModel : NSObject<NSCoding>
@property (nonatomic,assign)int type;
@property (nonatomic,copy)NSString *path;
@end
