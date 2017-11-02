//
//  XtableCell.h
//  VtableView
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XtableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgView;
@property (nonatomic,assign)BOOL hasLine;
@property(nonatomic,copy)NSString *typeName;
@end
