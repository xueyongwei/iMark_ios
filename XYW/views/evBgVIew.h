//
//  evBgVIew.h
//  XYW
//
//  Created by xueyongwei on 16/4/11.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Xview.h"
#import "EditingPicModel.h"
@interface evBgVIew : UIView
@property (nonatomic,strong) void(^addSubViewBlock)(Xview *Xview);
//@property (nonatomic,strong) void(^addSubXviewModelBlock)(XviewModel *aXviewModel);
@end
