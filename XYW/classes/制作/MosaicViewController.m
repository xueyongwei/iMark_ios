//
//  MosaicViewController.m
//  XYW
//
//  Created by xueyognwei on 2017/6/7.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "MosaicViewController.h"
#import "LSDrawView.h"
#import "XYWVerticalButton.h"
#import "AppDelegate.h"
#import <YYKit.h>
#import "UIImage+Color.h"
@interface MosaicViewController ()
@property (nonatomic,strong)LSDrawView *drawView;

@property (weak, nonatomic) IBOutlet XYWVerticalButton *undoBtn;
@property (weak, nonatomic) IBOutlet XYWVerticalButton *redoBtn;
@property (weak, nonatomic) IBOutlet XYWVerticalButton *resetBtn;
@property (weak, nonatomic) IBOutlet XYWButton *penBtn;
@property (weak, nonatomic) IBOutlet XYWButton *earaBtn;
@property (weak, nonatomic) IBOutlet UIButton *detaultPBtn;
@property (weak, nonatomic) IBOutlet UIButton *detaultPenTypeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *pencialTypeScrolView;

@property (nonatomic,strong) NSMutableArray *pencailsArray;

@property (nonatomic,weak) UIButton *currentPointBtn;

@end

@implementation MosaicViewController
-(NSArray *)pencailsArray{
    if (!_pencailsArray) {
//        _pencailsArray = [[NSMutableArray alloc]init];
        NSArray *colorHexStringArr = @[@{@"mascaicPenTypeMascaic":@"mosaic"},@{@"mascaicPenTypeLove":@"mascaicLovePen"},@{@"mascaicPenTypeRange":@"mascaicRangePen"},@{@"mascaicPenTypeFoot":@"mascaicFootPen"},@{@"mascaicPenTypeNewco":@"mascaicNewcoPen"},@{@"mascaicPenTypeFlower":@[@"mascaicFlowerPen0",@"mascaicFlowerPen1",@"mascaicFlowerPen2"]},@{@"mascaicPenTypeHeart":@[@"mascaicHeartPen0",@"mascaicHeartPen1",@"mascaicHeartPen2",@"mascaicHeartPen3"]},@{@"color":@"ff8a80"},@{@"color":@"ff3d00"},@{@"color":@"e91e63"},@{@"color":@"9c27b0"},@{@"color":@"673ab7"},@{@"color":@"2962ff"},@{@"color":@"4caf50"},@{@"color":@"ffce1a"},@{@"color":@"212121"},@{@"color":@"ffffff"}];
        _pencailsArray = [[NSMutableArray alloc]initWithArray:colorHexStringArr];
//        for (NSString *hexString in colorHexStringArr) {
//            UIColor *color = [UIColor colorWithHexColorString:hexString];
//            [_pencailsArray addObject:color];
//        }

    }
    return _pencailsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:@"choosePhotobg"];
    [self customDrawView];
    [self customPencialView];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).canShowADInWiondw = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CoreSVPCenterMsg(@"马赛克仅对单张图片生效");
    });
    
    // Do any additional setup after loading the view from its nib.
}
-(void)dealloc
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).canShowADInWiondw = YES;
}
-(void)customDrawView{
    CGRect rect = CGRectZero;
    CGSize imgSize = self.editImage.size;
    CGFloat imgRatio = imgSize.width/imgSize.height;
    if (imgRatio>=1) {//宽大于高
        rect.size.width = SCREEN_W;
        rect.size.height = rect.size.width/imgRatio;
    }else{
        rect.size.height = SCREEN_H - 135;
        rect.size.width = rect.size.height*imgRatio;
    }
    
    self.drawView = [[LSDrawView alloc] initWithFrame:rect];
    self.drawView.clipsToBounds = YES;
    self.drawView.center = CGPointMake(SCREEN_W/2, (SCREEN_H - 135)/2);
//    self.drawView.brushColor = self.pencailsArray[1];
    self.drawView.brushColor = nil;
    self.drawView.brushWidth = 17;
    self.drawView.shapeType = LSShapeCurve;
    self.drawView.backgroundImage = self.editImage;
    [self.view addSubview:self.drawView];
    self.currentPointBtn = self.detaultPBtn;
    __weak typeof(self) wkSelf = self;
    self.drawView.redoStateChangedBlock = ^{
        [wkSelf checkState];
    };
}
-(void)customPencialView{
    self.pencialTypeScrolView.contentSize = CGSizeMake(10+40*self.pencailsArray.count, 0);
    self.pencialTypeScrolView.backgroundColor = [UIColor colorWithHexColorString:@"f9f9f9"];
    for (int i =0; i<self.pencailsArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        btn.frame = CGRectMake(10+40*i, 5, 37, 37);
        [self.pencialTypeScrolView addSubview:btn];
        
        NSDictionary *colorDic = self.pencailsArray[i];
        NSString *colorKey = colorDic.allKeys.firstObject;
        
        if ([colorKey isEqualToString:@"color"]) {//纯色画笔
            btn.backgroundColor = [UIColor colorWithHexString:colorDic[@"color"]];
            [btn setImage:[UIImage imageNamed:@"choseColorCheck"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageFromContextWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
        }else{//包含马赛克，重复填充笔和贴图笔
            if ([colorDic[colorKey] isKindOfClass:[NSArray class]]) {//贴图笔
                
//                btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.01];
                btn.backgroundColor = [UIColor whiteColor];
                [btn setBackgroundImage:[UIImage imageNamed:colorKey] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"choseColorCheck"] forState:UIControlStateSelected];
                [btn setImage:[UIImage imageFromContextWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
            }else{//包含马赛克重复填充笔
                if ([colorDic[colorKey] isEqualToString:@"mosaic"]) {//马赛克
                    btn.backgroundColor = nil;
                    [btn setBackgroundImage:[UIImage imageNamed:colorKey] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"choseColorCheck"] forState:UIControlStateSelected];
                    [btn setImage:[UIImage imageFromContextWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
                    btn.selected = YES;
                    self.detaultPenTypeBtn = btn;
                }else{//重复填充笔
                    NSString *colorImgNameStr = colorDic[colorKey];
                    UIImage *colorImg = [UIImage imageNamed:colorImgNameStr];
                    btn.backgroundColor = [UIColor colorWithPatternImage:colorImg];
                    [btn setBackgroundImage:[UIImage imageNamed:colorKey] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"choseColorCheck"] forState:UIControlStateSelected];
                    [btn setImage:[UIImage imageFromContextWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}
-(void)colorBtnHandle:(UIButton *)sender{
    _detaultPenTypeBtn.selected = NO;
    self.detaultPenTypeBtn = sender;
    _detaultPenTypeBtn.selected = YES;
    self.drawView.brushColor = sender.backgroundColor;
    NSDictionary *colorDic = self.pencailsArray[sender.tag-100];
    NSString *colorKey = colorDic.allKeys.firstObject;
    if ([colorDic[colorKey] isKindOfClass:[NSArray class]]) {
        self.drawView.penImages = colorDic[colorKey];
    }else{
        self.drawView.penImages = nil;
    }
}
-(void)checkState{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.undoBtn.enabled =self.drawView.canUnDo;
        self.redoBtn.enabled = self.drawView.canReDo;
        self.resetBtn.enabled = self.drawView.canReDo||self.drawView.canUnDo || self.drawView.mascialAdded;
    });
}
#pragma mark -- 点击瞬间
- (IBAction)onPenClick:(UIButton *)sender {
    self.earaBtn.selected = NO;
    sender.selected = YES;
    self.drawView.isEraser = NO;
}
- (IBAction)onEaraClick:(UIButton *)sender {
    self.penBtn.selected = NO;
    sender.selected = YES;
    self.drawView.isEraser = YES;
//    self.drawView.brushColor = [UIColor clearColor];
}

-(void)setCurrentPointBtn:(UIButton *)currentPointBtn
{
    _currentPointBtn.selected = NO;
    _currentPointBtn = currentPointBtn;
    _currentPointBtn.selected = YES;
}
- (IBAction)onP1Click:(UIButton *)sender {
    self.currentPointBtn = sender;
    self.drawView.brushWidth = 5;
}
- (IBAction)onP2Click:(UIButton *)sender {
    self.currentPointBtn = sender;
    self.drawView.brushWidth = 10;
}
- (IBAction)onP3Click:(UIButton *)sender {
    
    self.currentPointBtn = sender;
    self.drawView.brushWidth = 15;
}
- (IBAction)onP4Click:(UIButton *)sender {
    self.currentPointBtn = sender;
    self.drawView.brushWidth = 20;
}
- (IBAction)onP5Click:(UIButton *)sender {
    self.currentPointBtn = sender;
    self.drawView.brushWidth = 30;
}

- (IBAction)onUndoClick:(UIButton *)sender {
    [self.drawView unDo];
    [self checkState];
}
- (IBAction)onReduClick:(UIButton *)sender {
    [self.drawView reDo];
    [self checkState];
}
- (IBAction)onResetClick:(UIButton *)sender {
    [self.drawView clean];
    [self checkState];
}






- (IBAction)onCloseClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onOkClick:(UIButton *)sender {
    UIImage *image = [self.drawView getResultImage];
    if (self.editFinishedBlock) {
        self.editFinishedBlock(image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
