//
//  HadDldTableViewCell.h
//  XYW
//
//  Created by xueyongwei on 16/4/21.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HadDldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *catagoryNaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *catagoryIconImgView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end
