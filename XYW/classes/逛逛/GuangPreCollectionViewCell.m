//
//  GuangPreCollectionViewCell.m
//  XYW
//
//  Created by xueyognwei on 2017/6/12.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "GuangPreCollectionViewCell.h"
#import <YYKit.h>
@implementation GuangPreCollectionViewCell
-(void)setModel:(GuangModel *)model
{
    _model = model;
    [self.imageView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@""]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
