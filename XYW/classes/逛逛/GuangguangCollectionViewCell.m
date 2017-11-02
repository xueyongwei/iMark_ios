//
//  GuangguangCollectionViewCell.m
//  XYW
//
//  Created by xueyognwei on 2017/6/8.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "GuangguangCollectionViewCell.h"
#import <YYKit.h>
@implementation GuangguangCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(GuangModel *)model
{
    _model = model;
    [self.imageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:nil];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"图库"]];
}
@end
