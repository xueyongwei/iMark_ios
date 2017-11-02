//
//  SCDldCollectionViewCell.m
//  XYW
//
//  Created by xueyongwei on 16/4/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SCDldCollectionViewCell.h"
#import "PathModel.h"
#import "waterModel.h"
#import <SSZipArchive.h>

@implementation SCDldCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SCdlModel *)model
{
//    model.showBtn = self.dldBtn;
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.downLoadUrl = model.downloadUrl;
    //设置cell的标题
    if (model.haveDownloaded) {
        [self.dldBtn setTitle:@"卸载" forState:UIControlStateNormal];
        [self.dldBtn setBackgroundColor:[UIColor darkGrayColor]];
    }else{
        [self.dldBtn setTitle:@"下载" forState:UIControlStateNormal];
        [self.dldBtn setBackgroundColor:[UIColor redColor]];
    }
    
    self.nameLabel.text = model.name;
    
}
- (IBAction)onDeleteClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onCellDldBtnClick:)]) {
        [self.delegate onCellDldBtnClick:sender];
    }
}
@end
