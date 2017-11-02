//
//  ScrewlView.m
//  XYW
//
//  Created by xueyongwei on 16/3/29.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SelectScrewlView.h"
#import "XscrawlView.h"
@interface SelectScrewlView ()<DrawVieweDelegate>
@property (weak, nonatomic) IBOutlet UIButton *userHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *penToolBtn;
@property (weak, nonatomic) IBOutlet UIButton *unDoBtn;
@property (weak, nonatomic) IBOutlet UIButton *reDoBtn;

@end
@implementation SelectScrewlView

//-(id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame: frame]) {
//        self = [self.class viewFromXIB];
//        
//    }
//    return self;
//}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.DrawView.delegate  = self;
    [self customBtnImageContentModel];
    [self customColorPickerBtn];
}
-(void)DrawViewChanged
{
    self.reDoBtn.enabled =self.DrawView.undoManager.canRedo;
    self.unDoBtn.enabled =self.DrawView.undoManager.canUndo;
}
-(void)customBtnImageContentModel{
    self.userHistoryBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.penToolBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.unDoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.reDoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)customColorPickerBtn
{
    int i = 0;
    self.colorPickerScrolView.contentSize = CGSizeMake(40*self.colorArr.count, 40);
    for (UIColor *color in self.colorArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40*i++, 0, 40, 40);
        btn.backgroundColor = color;
        [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorPickerScrolView addSubview:btn];
    }
    
}
-(void)colorBtnHandle:(UIButton *)sender
{
//    if (self.DrawView.erase) {
//        return;
//    }
    self.DrawView.color = sender.backgroundColor;
}

-(NSMutableArray *)colorArr
{
    if (!_colorArr) {
        _colorArr = [[NSMutableArray alloc]init];
        for (float i = 0; i<3; i++) {
            for (float j = 0; j<3; j++) {
                for (float k = 0; k<3; k++) {
                    UIColor *color = [UIColor colorWithRed:k*0.5 green:j*0.5 blue:i*0.5 alpha:1.0f];
                    [_colorArr addObject:color];
                }
            }
        }
    }
    return _colorArr;
}
- (IBAction)onCharuClick:(UIButton *)sender {
    XscrawlView *xsw = (XscrawlView*)[[[XscrawlView alloc]init] returnScrawlView:[self.DrawView getImage] onSuperView:self.ev.bgView tapBlock:^(Xview *Xview) {
        self.ev.currentWaterView = Xview;
    }];
    if (!xsw) {
        return;
    }
    self.ev.currentWaterView = xsw;
    
    [self onCancleClick:nil];
}

- (IBAction)onCancleClick:(UIButton *)sender {
   
//    [self.DrawView.undoManager removeAllActions];
//    for (UIView *view  in self.DrawView.subviews) {
//        [view removeFromSuperview];
//    }
    self.bgBottomConst.constant = -350;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            while ([self.DrawView.undoManager canUndo]) {
                [self.DrawView.undoManager undo];
            }
            if (self.dissMissBlock) {
                self.dissMissBlock();
            }
        }
    }];
//    [self removeFromSuperview];
}
-(void)animateShow{
    self.bgBottomConst.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)onGerenClick:(UIButton *)sender {
    
}
- (IBAction)onHuabiClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.DrawView.erase = sender.selected;
//    if (self.DrawView.erase) {
//        self.DrawView.erase = NO;
//             [sender setBackgroundImage:[UIImage imageNamed:@"涂鸦_铅笔"] forState:UIControlStateNormal];
//    }else
//    {
//        self.DrawView.erase = YES;
//        [sender setBackgroundImage:[UIImage imageNamed:@"涂鸦_橡皮"] forState:UIControlStateNormal];
//    }
}
- (IBAction)onChexiaoClick:(UIButton *)sender {
    [self.DrawView unDo];
}
- (IBAction)onChoongzuoCLick:(UIButton *)sender {
    [self.DrawView reDo];
}
- (IBAction)on1Click:(UIButton *)sender {
    self.DrawView.lWidth = 5.0;
}
- (IBAction)on2Click:(UIButton *)sender {
    self.DrawView.lWidth = 3.0;
}
- (IBAction)on3Click:(UIButton *)sender {
    self.DrawView.lWidth = 2.0;
}
- (IBAction)on4Click:(UIButton *)sender {
    self.DrawView.lWidth = 0.0;
}





@end
