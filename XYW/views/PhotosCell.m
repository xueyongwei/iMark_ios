//
//  PhotosCell.m
//  XYW
//
//  Created by xueyognwei on 2017/6/7.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "PhotosCell.h"

@implementation PhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    [asset thumbnail:^(UIImage *result, NSDictionary *info) {
        self.imgView.image = result;
    }];
}
- (IBAction)onSelectedClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectedCell:)]) {
        [self.delegate selectedCell:self];
    }
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _corverButton.selected = selected;
}
@end
