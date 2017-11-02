//
//  XtableCell.m
//  VtableView
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XtableCell.h"

@implementation XtableCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)onBtnClick:(UIButton *)sender {
    DbLog(@"tap");
}
-(void)setTypeName:(NSString *)typeName
{
    DbLog(@"%@",typeName);
    [self.btn setTitle:typeName forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.btn.selected = selected;
    self.lineImgView.hidden = !selected;

    // Configure the view for the selected state
}

@end
