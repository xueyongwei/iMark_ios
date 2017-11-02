//
//  SCdlModel.h
//  XYW
//
//  Created by xueyongwei on 16/4/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCdlModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString *category;
@property (nonatomic,copy)NSString *downloadUrl;
@property (nonatomic,copy)NSString *iconUrl;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *Dlid;
@property (nonatomic,copy)NSString *Tp;
@property (nonatomic,copy)NSString *size;
@property (nonatomic,copy)NSString *localDirPath;
@property (nonatomic,assign)BOOL haveDownloaded;
@property (nonatomic,assign)CGFloat currentProgress;
//@property (nonatomic,weak)UIButton *showBtn;
@end
