//
//  SelectWordView.h
//  XYW
//
//  Created by xueyongwei on 16/4/1.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "Xview.h"

@interface SelectWordView : Xview
@property (weak, nonatomic) IBOutlet UIButton *tianjiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *zitiBtn;
@property (weak, nonatomic) IBOutlet UIButton *yanseBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *fontScrolView;
@property (weak, nonatomic) IBOutlet UIScrollView *colorScrolView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end
