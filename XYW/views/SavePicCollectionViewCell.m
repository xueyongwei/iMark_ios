//
//  SavePicCollectionViewCell.m
//  XYW
//
//  Created by xueyongwei on 16/4/13.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SavePicCollectionViewCell.h"

@implementation SavePicCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setImg:(UIImage *)img
{
    self.imgView.image = self.img;
}
@end
