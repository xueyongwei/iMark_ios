//
//  SCDldCollectionViewCell.h
//  XYW
//
//  Created by xueyongwei on 16/4/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCdlModel.h"
@protocol SCDldCollectionViewCellDelegate <NSObject>
-(void)onCellDldBtnClick:(UIButton *)sender;
@end
@interface SCDldCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) id<SCDldCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *dldBtn;
@property (nonatomic,copy)NSString *downLoadUrl;
@property (nonatomic,strong) SCdlModel *model;
@end
