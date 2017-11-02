//
//  EditerViewController.m
//  XYW
//
//  Created by xueyongwei on 16/3/21.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "EditerViewController.h"
#import "SelectWaterTableView.h"
#import "SelectScrewlView.h"
#import "XwaterView.h"
#import "SelectWordView.h"
#import "InputView.h"
#import "XwordView.h"
#import "FontModel.h"
#import "ShareViewController.h"
#import <CoreText/CoreText.h>
#import "EditingPicModel.h"
#import "SandBoxManager.h"
#import "UserDefaultsManager.h"
#import "XiewShowDescModel.h"
#import "UIImage+Color.h"
#import "MosaicViewController.h"
#import "UINavigationController+WXSTransition.h"

@interface EditerViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *naviBackBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConst;
@property (weak, nonatomic) IBOutlet UIButton *batchEditBtn;//批量处理按钮
@property (weak, nonatomic) IBOutlet UIView *editView;//放置操作台的view

@property (nonatomic,strong)EditView *ev;//操作台
@property (nonatomic,strong) SelectWaterTableView *waterSelectview;
@property (nonatomic,strong) SelectWordView *WordSelectView;
@property (nonatomic,strong) SelectScrewlView *screwlSelectView;
@property (nonatomic,strong)UIButton *currentAssetThumbBtn;
@property (nonatomic,strong)UIView *toolView;


/**
 当前显示的第几张图片
 */
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)UIColor *colorOfTextToAdd;//当前选中的字体颜色
@property (nonatomic,weak)UIButton *currentSelectedFontBtn;
@property (nonatomic,weak)UIButton *currentSelectedColorBtn;
@property (nonatomic,copy)NSString *nameOfFontToAdd;//当前选中的字体name


@property (nonatomic,assign)NSUInteger currentProductIndex;//当前正在生成图片的下标

@property (nonatomic,strong) NSMutableArray *colorArr;//字体换颜色的颜色数组
@property (nonatomic,strong)NSMutableArray *fontArr;//本地字体数组
@property (nonatomic,strong)NSMutableArray <EditingPicModel *>*editingPicModelArray;//待编辑的图片模型数组
@property (nonatomic,strong)NSMutableArray <UIImage *>*productPhotos;//编辑过的图片数组
@property (nonatomic,strong)NSMutableArray <Xview *>*xViewsArray;//水印数组数组
@end

@implementation EditerViewController
-(NSMutableArray *)xViewsArray
{
    if (!_xViewsArray) {
        _xViewsArray = [[NSMutableArray alloc]init];
    }
    return _xViewsArray;
}
-(NSMutableArray *)productPhotos
{
    if (!_productPhotos) {
        _productPhotos = [[NSMutableArray alloc]init];
    }
    return _productPhotos;
}
-(NSMutableArray *)editingPicModelArray
{
    if (!_editingPicModelArray) {
        _editingPicModelArray = [[NSMutableArray alloc]init];
    }
    return _editingPicModelArray;
}

//获取本地的字体模型
-(void)loadLocalFonts{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _fontArr = [NSMutableArray new];
        NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
        NSArray *arr = [usf objectForKey:@"fontModels"];
        for (NSData *data in arr) {
            FontModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (model) {
                [_fontArr addObject:model];
            }
        }
    });
}
-(void)tapXview:(Xview *)xview{
    //    if (self.ev.currentWaterView != xview) {
    //        if ([xview isKindOfClass:[XwordView class]]) {
    //
    //        }
    //    }
}

/**
 设置编辑的asset，同时生成要处理的

 @param assetArray 带处理的asset
 */
-(void)setAssetArray:(NSArray<PHAsset *> *)assetArray
{
    _assetArray = assetArray;
//    __weak typeof(self) wkSelf = self;
    
}
#pragma mark -- 🔌 viewDidLoad
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (self.waterSelectview) {
        [self.waterSelectview refreshData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
    if (self.toolView && [self.toolView isKindOfClass:[SelectWaterTableView class]]) {
        //如果是水印选择的工具栏，则需要刷新这个工具栏的背景图
        SelectWaterTableView *waterV = (SelectWaterTableView *)self.toolView;
        [waterV refreshData];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CoreSVP dismiss];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexColorString:@"e84f3c"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLocalFonts];
    self.currentIndex = 0;
    self.currentProductIndex = 0;
    
    [self customNavi];
    [self customBackNaviBarBtn];
    

    NSDictionary *att = @{@"photosCount":@(self.productPhotos.count)};
    [MobClick event:@"editcount" attributes:att];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 🔌 绘制界面
/**
 定义顶部缩略图
 */
-(void)customNavi{
    self.naviBgView.frame = CGRectMake(0, 0, SCREEN_W-120, 35);
    self.naviScrollView.contentSize = CGSizeMake(3+40*self.assetArray.count, 0);
    //导航栏上缩略图界面绘制
    for (int i = 0; i<self.assetArray.count; i++) {
        PHAsset *asset = self.assetArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(3+i*40, 2, 35, 35);
        button.backgroundColor = [UIColor lightGrayColor];
        button.tag = 100+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [asset thumbnail:^(UIImage *result, NSDictionary *info) {
            [button setImage:result forState:UIControlStateNormal];
        }];
        [button addTarget:self action:@selector(onimgThumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviScrollView addSubview:button];
        if (i==0) {
            self.currentAssetThumbBtn = button;
            [self borderBtn:button];
        }
    }
    //将会递归调用，直到生成所有
    CoreSVPLoading(@"waiting..", YES);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initEditPicModelOfIndex:0];
    });
    
}

/**
 定义返回键
 */
-(void)customBackNaviBarBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 12, 21);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itm = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width = -10;
    self.navigationItem.leftBarButtonItems = @[fix,itm];
}
#pragma mark -- 🔌 handle
/**
 返回键的handle
 */
-(void)backHandle
{
    if (self.ev.bgView.subviews.count>1) {
        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"是否放弃操作？" message:nil delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"取消", nil];
        alv.delegate = self;
        alv.tag = 101;
        [alv show];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 是否放弃本次操作
 
 @param alertView alert
 @param buttonIndex 选择的
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        }
    }
}

#pragma mark ---🔌 textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



/**
 生成每个图片对应的操作模型
 
 @param asset 相册照片
 */
-(void)initPicEditingModels{
    __weak typeof(self) wkSelf = self;
    for (NSInteger i =0; i<self.assetArray.count; i++) {
        PHAsset *asset = self.assetArray[i];
        [asset requestImageForTargetSize:[self currentUserSetSize] resultHandler:^(UIImage *result, NSDictionary *info) {
            EditingPicModel *emodle = [[EditingPicModel alloc]init];
            emodle.asset = asset;
            emodle.index = i;
            CGSize modelSize = CGSizeZero;
            if (result.size.width>=result.size.height) {
                modelSize.width = self.ev.width;
                modelSize.height = self.ev.width*result.size.height/result.size.width;
            }else{
                modelSize.height = self.ev.height;
                modelSize.width = self.ev.height*result.size.width/result.size.height;
            }
            emodle.modelOptSize = modelSize;
            [wkSelf.editingPicModelArray addObject:emodle];
        }];
    }

//    [asset requestImageForTargetSize:[self currentUserSetSize] resultHandler:^(UIImage *result, NSDictionary *info) {
//        EditingPicModel *emodle = [[EditingPicModel alloc]init];
//        
//        //        CGSize imgSize = result.size;
//        CGSize modelSize = CGSizeZero;
//        if (result.size.width>=result.size.height) {
//            modelSize.width = self.ev.width;
//            modelSize.height = self.ev.width*result.size.height/result.size.width;
//        }else{
//            modelSize.height = self.ev.height;
//            modelSize.width = self.ev.height*result.size.width/result.size.height;
//        }
//        emodle.modelOptSize = modelSize;
//        [wkSelf.editingPicModelArray addObject:emodle];
//    }];
    
}
-(void)initEditPicModelOfIndex:(NSInteger)index{
    DbLog(@"准备生成第%ld个EditingPicModel",index);
    if (index>self.assetArray.count-1) {
        DbLog(@"所有editPicModel生成完毕,显示工具栏");
        dispatch_async(dispatch_get_main_queue(), ^{
            [CoreSVP dismiss];
            [self customReuseScrolView];
        });
        return;
    }
    __block PHAsset *asset = self.assetArray[index];
    __weak typeof(self) wkSelf = self;
    __block EditingPicModel *emodle = [[EditingPicModel alloc]init];
    emodle.asset = asset;
    emodle.index = index;
    [self.editingPicModelArray addObject:emodle];
//    CGSize userSize = [self currentUserSetSize];
    CGSize userSize = CGSizeMake(750, 1334);
   
    [asset thumbnail:userSize resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            emodle.img = result;
            CGSize modelSize = CGSizeZero;
            if (result.size.width>=result.size.height) {
                modelSize.width = wkSelf.ev.width;
                modelSize.height = wkSelf.ev.width*result.size.height/result.size.width;
            }else{
                modelSize.height = wkSelf.ev.height;
                modelSize.width = wkSelf.ev.height*result.size.width/result.size.height;
            }
            emodle.modelOptSize = modelSize;
            DbLog(@"第%ld个EditingPicModel生成完毕",index);
            [self initEditPicModelOfIndex:index+1];
        }
    }];

}
/**
 点击了缩略图
 
 @param sender 按钮
 */
-(void)onimgThumBtnClick:(UIButton *)sender{
    [self borderBtn:sender];
    //    EditingPicModel *model = self.picEdingModels[self.currentIndex];
    //    for (XviewModel *xViewModel in model.subXviewModelsArray) {
    //        xViewModel.view.hidden = YES;
    //    }
    self.currentIndex = sender.tag -100;
    [self loadImage:sender.tag-100 animate:YES];
//    [self loadSubviews:self.currentIndex];
}

/**
 给缩略图加框
 
 @param sender aaa
 */
-(void)borderBtn:(UIButton *)sender{
    self.currentAssetThumbBtn.layer.borderWidth = 0.0f;
    sender.layer.borderWidth = 2.0f;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
    self.currentAssetThumbBtn = sender;
}
#pragma mark ---🎬ev控制台
//中间操作台使用“复用”机制，省内存
-(void)customReuseScrolView{
    [self.view layoutIfNeeded];
    
    self.scrView.contentSize = CGSizeMake((self.bgView.bounds.size.width)*3, 0);
    self.scrView.delegate = self;
    
    __weak typeof(self) wkSelf = self;
    
    EditView *ev = [EditView viewFromXIB];
    self.ev = ev;
    ev.addSubViewBlock= ^(Xview *xview){
        DbLog(@"添加了一个xview：%@",xview);
        [wkSelf addSubXView:xview];
    };
    ev.tapEmptyBlock = ^{
        [wkSelf dismissToolView];
    };
    [self.editView addSubview:ev];
    [ev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(wkSelf.editView);
    }];
    ev.bgView.autoresizingMask = YES;
    ev.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrView.scrollEnabled = self.assetArray.count>1;
    
    
    [self customToolView];
    [self.scrView setContentOffset:CGPointMake(wkSelf.scrView.bounds.size.width, 0)];
    
    //延迟加载操作台，更好的视觉效果，防止突兀出现
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wkSelf loadImage:self.currentIndex animate:YES];
    });
    
}


/**
 准备下方的工具条
 */
-(void)customToolView{
    //    选择水印view
    SelectWaterTableView *waterview = [SelectWaterTableView viewFromXIB];
    self.waterSelectview = waterview;
    waterview.vc = self;
    waterview.ev = self.ev;
    [waterview.onBtn addTarget:self action:@selector(onSelectWordViewOkClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:waterview];
    __weak typeof(self)wkSelf = self;
    [waterview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(wkSelf.view);
        make.height.mas_equalTo(135);
        make.top.equalTo(wkSelf.view.mas_bottom);
    }];
    
    //    选择文字view
    SelectWordView *swod = [SelectWordView viewFromXIB];
    self.WordSelectView = swod;
    [swod.tianjiaBtn addTarget:self action:@selector(onAddwordClick:) forControlEvents:UIControlEventTouchUpInside];
    [swod.okBtn addTarget:self action:@selector(onSelectWordViewOkClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [swod.zitiBtn addTarget:self action:@selector(onZitiCLick:) forControlEvents:UIControlEventTouchUpInside];
//    [swod.yanseBtn addTarget:self action:@selector(onYanseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:swod];
    //设置位置
    [swod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(wkSelf.view);
        make.height.mas_equalTo(135);
        make.top.equalTo(wkSelf.view.mas_bottom);
    }];
    
    swod.colorScrolView.contentSize = CGSizeMake(10+35*self.colorArr.count, 0);
    swod.colorScrolView.backgroundColor = [UIColor colorWithHexColorString:@"f9f9f9"];
    for (int i =0; i<self.colorArr.count; i++) {
        UIColor *color = self.colorArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+35*i, 10, 25, 25);
        btn.backgroundColor = color;
        [btn setImage:[UIImage imageNamed:@"choseColorCheck"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageFromContextWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
        [swod.colorScrolView addSubview:btn];
        if (i==0) {
            self.currentSelectedColorBtn = btn;
            self.currentSelectedColorBtn.selected = YES;
        }
    }
    
    swod.fontScrolView.contentSize = CGSizeMake(100*self.fontArr.count, 0);
    swod.colorScrolView.backgroundColor = [UIColor colorWithHexColorString:@"f9f9f9"];
    for (int i = 0;i<self.fontArr.count;i++) {
        FontModel *model = self.fontArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100*i, 0, 100, 43);
        btn.backgroundColor = [UIColor colorWithHexColorString:@"f9f9f9"];
        NSString *title = nil;
        btn.titleLabel.font = [UIFont fontWithName:[UIFont fontNamesForFamilyName:model.fontName].firstObject size:20];
        if (model.language.integerValue ==2) {//英文
            title = @"watermark";
        }if (model.language.integerValue ==1) {//中文
            title = @"爱水印";
        }
        [btn setTitleColor:[UIColor colorWithHexColorString:@"666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexColorString:@"e84f3c"] forState:UIControlStateSelected];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(fontBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
        [swod.fontScrolView addSubview:btn];
        if (i==0) {
            self.currentSelectedFontBtn = btn;
            self.currentSelectedFontBtn.selected = YES;
        }
    }
    
    //    选择涂鸦view
    SelectScrewlView *sw = [SelectScrewlView viewFromXIB];
    self.screwlSelectView = sw;
    __block SelectScrewlView *bSw = sw;
    sw.dissMissBlock = ^{
        [bSw mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(wkSelf.navigationController.view);
            make.height.mas_equalTo(wkSelf.view.height);
            make.top.equalTo(wkSelf.navigationController.view.mas_bottom);
        }];
//        wkSelf.shareBtn.selected = NO;
    };
    [self.navigationController.view addSubview:sw];
    sw.ev = self.ev;
    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(wkSelf.navigationController.view);
        make.height.mas_equalTo(wkSelf.view.height);
        make.top.equalTo(wkSelf.navigationController.view.mas_bottom);
    }];
}

/**
 添加了一个新的图层
 
 @param view 要添加的view
 */
-(void)addSubXView:(Xview *)view
{
    DbLog(@"add view %@",view);
    view.autoresizingMask = YES;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    __weak typeof(self) wkSelf = self;
    view.changedBlock = ^(Xview *Xview) {
        [wkSelf xviewChanged:Xview];
    };
    view.deleteBlock = ^(Xview *Xview) {
        [wkSelf xviewDelete:Xview];
    };
    if ([view isKindOfClass:[XwordView class]]) {
        XwordView *wv = (XwordView *)view;
        __block typeof(wv) WkWV = wv;
        wv.xWordViewTextChangedBlock = ^{
            [wkSelf xWorkViewTextChanged:WkWV];
        };
    }
    [self.xViewsArray addObject:view];
    //对每个图片都生成一个该水印的showModel
    view.xAscpecRatio = view.bounds.size.width/view.bounds.size.height;
    for (NSInteger i=0; i<self.editingPicModelArray.count; i++) {
        EditingPicModel *edtModel = self.editingPicModelArray[i];
        XiewShowDescModel *showModel = [[XiewShowDescModel alloc]init];
//        showModel.xaspectRito = view.bounds.size.width/view.bounds.size.height;
        showModel.optViewSize = edtModel.modelOptSize;
        [view.showDescModels addObject:showModel];
        if (i==self.currentIndex) {//当前的一定是加上去的
            showModel.hidden = NO;
            DbLog(@"添加显示描述到当前显示的图片");
        }else{
            if (self.batchEditBtn.selected) {//只有是批量处理，才换算其他的大小
                showModel.hidden = NO;
                DbLog(@"添加显示描述到其他图片%ld",(long)i);
            }else{
                showModel.hidden = YES;
                DbLog(@"非批量，不添加其他的");
            }
        }
    }
    //适配每个图片的水印显示模型
//    [self fitShowDescModelOfaXview:view];
    [self updateShowDescOfXview:view];
}


/**
 更新显示描述

 @param aXview 要更新的xview
 */
-(void)updateShowDescOfXview:(Xview *)aXview{
    CGRect origFrame = aXview.frame;
    CGAffineTransform origTransform = aXview.transform;
    CGRect spBounds = aXview.superview.bounds;
    CGFloat minLenthScale = 0;
    DbLog(@"当前水印的父试图大小 %@ ",NSStringFromCGRect(spBounds));
    CGFloat centerXscale = aXview.center.x/spBounds.size.width;
    CGFloat centerYscale = aXview.center.y/spBounds.size.height;
    
    if (spBounds.size.width>spBounds.size.height) {//miniScale
        minLenthScale = origFrame.size.height/spBounds.size.height;
    }else{
        minLenthScale = origFrame.size.width/spBounds.size.width;
    }
    
    
//    CGFloat xScale = (float)origFrame.origin.x/spBounds.size.width;
//    CGFloat yScale = (float)origFrame.origin.y/spBounds.size.height;
    CGFloat wScale = (float)origFrame.size.width/spBounds.size.width;
    CGFloat hScale = (float)origFrame.size.height/spBounds.size.height;
    
    CGFloat xleft = aXview.frame.origin.x/spBounds.size.width;
    CGFloat xright = (spBounds.size.width-aXview.frame.origin.x-aXview.frame.size.width)/spBounds.size.width;
    CGFloat xtop = aXview.frame.origin.y/spBounds.size.height;
    CGFloat xbottom = (spBounds.size.height-aXview.frame.origin.y-aXview.frame.size.height)/spBounds.size.height;
    
    if (self.batchEditBtn.selected) {//批量模式
        for (XiewShowDescModel *showModel in aXview.showDescModels) {
            if (!showModel.hidden) {
                showModel.xScale = centerXscale;
                showModel.yScale = centerYscale;
                showModel.minLenthScale = minLenthScale;
                
//                showModel.xScale = xScale;
//                showModel.yScale = yScale;
                showModel.wScale = wScale;
                showModel.hScale = hScale;
                
                showModel.xtop = xtop;
                showModel.xbottom = xbottom;
                showModel.xleft = xleft;
                showModel.xright = xright;
                
                showModel.transform = origTransform;
                DbLog(@"水印已适配为xscale %f ",minLenthScale);
            }else{
                DbLog(@"当前水印已从此图删除");
            }
        }
    }else{
        XiewShowDescModel *currentPicShowModel = aXview.showDescModels[_currentIndex];
        currentPicShowModel.xScale = centerXscale;
        currentPicShowModel.yScale = centerYscale;
        currentPicShowModel.minLenthScale = minLenthScale;
//        currentPicShowModel.xScale = xScale;
//        currentPicShowModel.yScale = yScale;
        currentPicShowModel.wScale = wScale;
        currentPicShowModel.hScale = hScale;
        currentPicShowModel.transform = origTransform;
        
        currentPicShowModel.xtop = xtop;
        currentPicShowModel.xbottom = xbottom;
        currentPicShowModel.xleft = xleft;
        currentPicShowModel.xright = xright;
        
        DbLog(@"只更新这个图xcale %f",currentPicShowModel.xScale);
    }
}
///**
// 将当前的水印frame适配到指定编辑模型上
// 
// @param rect 当前水印的frame
// @param model 指定的模型
// @return 适配后的frame
// */
//-(void)fitShowDescModelOfaXview:(Xview *)view {
//    CGRect rect = view.bounds;
//    CGPoint origin = view.frame.origin;
//    for (NSInteger i =0; i<view.showDescModels.count; i++) {//遍历xview在每个图片上的显示描述
//        XiewShowDescModel *model = view.showDescModels[i];
//        if (i==self.currentIndex) {//当前显示的这个
////            model.bounds = view.bounds;
////            model.center = view.center;
//            model.frame = CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);;
//            model.transform = view.transform;
//            DbLog(@"当前水印已适配正显示的图 %@",NSStringFromCGRect(model.frame));
//        }else{//看是否需要更新其他图片上的显示描述，隐藏的不做操作
//            if (self.batchEditBtn.selected) {//只有是批量处理，才换算其他的大小
//                if (model.hidden) {
//                    DbLog(@"当前水印已从%ld移除",i);
//                }else{
//                    
//                    CGRect finalRect = CGRectZero;
//                    CGFloat wscale = model.optViewSize.width/self.ev.bgView.frame.size.width;
//                    CGFloat hscale = model.optViewSize.height/self.ev.bgView.frame.size.height;
////                    CGFloat centerXscale = center.x/self.ev.bgView.frame.size.width;
////                    CGFloat centerYscale = center.y/self.ev.bgView.frame.size.height;
//                    if (fabs(wscale-1) >fabs(hscale-1)) {//按变化最大的人算
//                        finalRect = CGRectMake(0, 0, rect.size.width *wscale, rect.size.height *wscale);
//                        origin.x *=wscale;
//                        origin.y *=wscale;
//                    }else{
//                        finalRect = CGRectMake(0, 0, rect.size.width *hscale, rect.size.height *hscale);
//                        origin.x *=hscale;
//                        origin.y *=hscale;
//                    }
//                    model.bounds = finalRect;
//                    model.frame = CGRectMake(origin.x, origin.y, finalRect.size.width, finalRect.size.height);
//                    model.transform = view.transform;
//                    DbLog(@"当前水印已适配%ld %@",i,NSStringFromCGRect(model.frame));
//                }
//            }else{//不是批量，其他的都不更改显示描述
//                DbLog(@"非批量，不更改%ld",i);
//            }
//        }
//    }
////    for (XiewShowDescModel *model in view.showDescModels) {
////        
////    }
////    for (NSInteger i = 0; i<self.editingPicModelArray.count; i++) {
////        
////    }
////    for (EditingPicModel *edtModel in self.editingPicModelArray) {
////        
////        if (edtModel == currentEdtModel) {
////            model.hidden = NO;
////            model.bounds = view.bounds;
////            model.center = view.center;
////            model.transform = view.transform;
////        }else{//处理其他的
////            if (self.batchEditBtn.selected) {//批量处理，换算其他的大小
////                
////                CGRect finalRect = CGRectZero;
////                CGFloat wscale = model.optViewSize.width/self.ev.bgView.frame.size.width;
////                CGFloat hscale = model.optViewSize.height/self.ev.bgView.frame.size.height;
////                if (fabs(wscale-1) >fabs(hscale-1)) {//按变化最大的人算
////                    finalRect = CGRectMake(0, 0, rect.size.width *wscale, rect.size.height *wscale);
////                    center.x *=wscale;
////                    center.y *=wscale;
////                }else{
////                    finalRect = CGRectMake(0, 0, rect.size.width *hscale, rect.size.height *hscale);
////                    center.x *=hscale;
////                    center.y *=hscale;
////                }
////                model.bounds = finalRect;
////                model.center = center;
////                model.transform = view.transform;
////                model.hidden = NO;
////            }else{//不是批量，其他的都设为隐藏（隐藏的都不处理）
////                model.hidden = YES;
////            }
////        }
////    }
//    //    return finalRect;
//}
-(void)xviewDelete:(Xview *)aXview
{
    aXview.hidden = YES;
    if (self.batchEditBtn.selected) {
        for (XiewShowDescModel *showModel in aXview.showDescModels) {
            showModel.hidden = YES;
        }
    }else{
        XiewShowDescModel *showModel = aXview.showDescModels[_currentIndex];
        showModel.hidden = YES;
    }
}
-(void)xWorkViewTextChanged:(XwordView *)aWordView{
    aWordView.xAscpecRatio = aWordView.bounds.size.width/aWordView.bounds.size.height;
    [self xviewChanged:aWordView];
}
-(void)xviewChanged:(Xview *)aXview{
    DbLog(@"更新显示描述");
    [self updateShowDescOfXview:aXview];
}

/**
 滑动结束，重设编辑界面
 
 @param scrollView 滑动视图
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    DbLog(@"%f",scrollView.contentOffset.x/self.scrView.bounds.size.width);
    if (scrollView.contentOffset.x/self.scrView.bounds.size.width<1) {
        self.currentIndex -=1;
        if (self.currentIndex <0) {
            self.currentIndex = self.assetArray.count-1;
        }
    }else if (scrollView.contentOffset.x/self.scrView.bounds.size.width == 1){
        return;
    }else{
        self.currentIndex +=1;
        if (self.currentIndex > self.assetArray.count-1) {
            self.currentIndex = 0;
        }
    }
    //设置导航栏图片缩略图的btn
    UIButton *btn = (UIButton *)[self.naviScrollView viewWithTag:self.currentIndex+100];
    [self borderBtn:btn];
    //加载新的图片和水印
    [self loadImage:self.currentIndex animate:YES];
//    [self loadSubviews:self.currentIndex];
    //滚动回去
    [scrollView setContentOffset:CGPointMake(self.scrView.bounds.size.width, 0)];
    
}

//-(void)setToolView:(UIView *)toolView
//{
//    if (_toolView == toolView) {
//        return;
//    }
//    _toolView = toolView;
//    
////    if (toolView == nil) {
//////        [self.navigationController setNavigationBarHidden:NO animated:YES];
////        self.shareBtn.hidden = NO;
////        self.naviBackBtn.hidden = NO;
////    }else{
//////        [self.navigationController setNavigationBarHidden:YES animated:YES];
////        self.shareBtn.hidden = YES;
////        self.naviBackBtn.hidden = YES;
////    }
//}
#pragma mark ---🎬水印相关
- (IBAction)onWaterClick:(UIButton *)sender {//点击了水印
    __weak typeof(self) wkSelf = self;
    
    PHAsset *asset = self.assetArray[self.currentIndex];
    [asset thumbnail:^(UIImage *result, NSDictionary *info) {
        wkSelf.waterSelectview.thumbnail = result;
        [wkSelf.waterSelectview reloadCollection];
        [self.waterSelectview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wkSelf.view.mas_bottom).offset(-135);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [wkSelf.view layoutIfNeeded];
        }];
    }];
    self.toolView = self.waterSelectview;
//    self.shareBtn.selected = YES;
    
}
-(void)loadImage:(NSInteger)index animate:(BOOL)animate{
    EditingPicModel *emodel = self.editingPicModelArray[index];
    if ([self.toolView isKindOfClass:[SelectWaterTableView class]]) {
        //如果是水印选择的工具栏，则需要刷新这个工具栏的背景图
        SelectWaterTableView *waterV = (SelectWaterTableView *)self.toolView;
        [emodel.asset thumbnail:^(UIImage *result, NSDictionary *info) {
            waterV.thumbnail = result;
            [waterV reloadCollection];
        }];
    }
    [self loadXviewsOfPicModelAtIndex:index];
    if (emodel.img) {
        if (animate) {
            self.ev.alpha = 0;
        }
        self.ev.img = emodel.img;
        
        if (animate) {
            [UIView animateWithDuration:0.2 animations:^{
                self.ev.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (finished) {
                }
            }];
        }
    }else{
        __weak typeof(self) wkSelf = self;
        if (animate) {
            wkSelf.ev.alpha = 0;
        }
        [emodel.asset thumbnail:^(UIImage *result, NSDictionary *info) {
            if (result) {
                wkSelf.ev.img = result;
                emodel.img = result;
                if (animate) {
                    [UIView animateWithDuration:0.2 animations:^{
                        wkSelf.ev.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        if (finished) {
                        }
                    }];
                }
            }
        }];
        [emodel.asset thumbnail:CGSizeMake(750, 1334) resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                wkSelf.ev.img = result;
                emodel.img = result;
            }else{
                
            }
        }];
    }
    
}

-(void)loadXviewsOfPicModelAtIndex:(NSInteger)index{
    DbLog(@"loadXviewsOfPicModelAtIndex %ld",index);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (Xview *aXview in self.xViewsArray) {
            //取出在当前图片上的显示描述
            [aXview setShowViewIndex:index];
        }
    });
}


#pragma mark ---🎬 文字相关
- (IBAction)onWordClick:(UIButton *)sender {//点击了文字
    __weak typeof(self) wkSelf = self;
    [self.WordSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.height.mas_equalTo(100);
        make.top.equalTo(wkSelf.view.mas_bottom).offset(-135);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.toolView = self.WordSelectView;
//    self.shareBtn.selected = YES;
    
}
-(void)onAddwordClick:(UIButton *)sender{
    InputView *ipv = [[[NSBundle mainBundle]loadNibNamed:@"InputView" owner:self options:nil]lastObject];
    ipv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.navigationController.view addSubview:ipv];
    //    [[UIApplication sharedApplication].windows.lastObject addSubview:ipv];
    DbLog(@"%@",self.fontArr);
}

-(void)onZitiCLick:(UIButton *)sender{
    
    SelectWordView *swv = (SelectWordView *)self.toolView;
    for (UIButton *btn in swv.fontScrolView.subviews) {
        [btn removeFromSuperview];
    }
    swv.fontScrolView.contentSize = CGSizeMake(100*self.fontArr.count, 50);
    
    for (int i = 0;i<self.fontArr.count;i++) {
        FontModel *model = self.fontArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100*i, 0, 100, 50);
        btn.backgroundColor = [UIColor blackColor];
        NSString *title = nil;
        ;
        btn.titleLabel.font = [UIFont fontWithName:[UIFont fontNamesForFamilyName:model.fontName].firstObject size:20];
        
        if (model.language.integerValue ==2) {//英文
            title = @"watermark";
        }if (model.language.integerValue ==1) {//中文
            title = @"爱水印";
        }
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(fontBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
        [swv.fontScrolView addSubview:btn];
    }
    
    
}
-(void)fontBtnHandle:(UIButton *)sender
{
    if (sender == self.currentSelectedFontBtn) {
        return;
    }
    self.currentSelectedFontBtn.selected = NO;
    self.currentSelectedFontBtn = sender;
    self.currentSelectedFontBtn.selected = YES;
    DbLog(@"font = %@",sender.titleLabel.font);
    self.nameOfFontToAdd = sender.titleLabel.font.fontName;
    
    Xview *view = self.ev.currentWaterView;
    if (view && [view isKindOfClass:[XwordView class]]) {
        XwordView *thisView = ((XwordView *)view);
        XLabel *label = thisView.label;
        label.font = [UIFont fontWithName:self.nameOfFontToAdd size:label.font.pointSize];
//        [thisView adjustFont:label.font];
        [label showLabelInSuperView:label.superview];
    }
    
}
-(UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    //加载本地字体并注册
    
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    
    
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    CGDataProviderRelease(fontDataProvider);
    return font;
}
//-(void)onYanseClick:(UIButton *)sender{
//    SelectWordView *swv = (SelectWordView *)self.toolView;
//    for (UIButton *btn in swv.ScrolView.subviews) {
//        [btn removeFromSuperview];
//    }
//    swv.ScrolView.contentSize = CGSizeMake(40*self.colorArr.count, 50);
//    int i = 0;
//    for (UIColor *color in self.colorArr) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(40*i++, 0, 40, 50);
//        btn.backgroundColor = color;
//        [btn addTarget:self action:@selector(colorBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
//        [swv.ScrolView addSubview:btn];
//    }
//}

-(void)colorBtnHandle:(UIButton *)sender
{
    if (sender == self.currentSelectedColorBtn) {
        return;
    }
    self.currentSelectedColorBtn.selected = NO;
    self.currentSelectedColorBtn = sender;
    self.currentSelectedColorBtn.selected = YES;
    DbLog(@"color = %@",sender.backgroundColor);
    self.colorOfTextToAdd = sender.backgroundColor;
    
    Xview *view = self.ev.currentWaterView;
    if (view && [view isKindOfClass:[XwordView class]]) {
        XLabel *label = ((XwordView *)view).label;
        label.textColor = sender.backgroundColor;
    }
}
-(NSMutableArray *)colorArr
{
    if (!_colorArr) {
        /*
#ff8a80  #ff5252  #f44336  #ff80ab  #ff4081  #e91e63  #ea80fc  #e040fb #e040fb
#b388ff  #7c4dff  #673ab7  #8c9eff #536dfe #3f51b5 #42a5f5 #2979ff #2962ff
#80d8ff #40c4ff  #03a9f4  #18ffff  #00bcd4 #64ffda  #1de9b6 #69f0ae #009688
#00e676 #4caf50 #b2ff59 #76ff03 #8bc34a  #cddc39  #ffce1a  #ffff00  #ff9800
#ef6c00 #ff5722 #ff3d00 #bf360c #6d4c41  #4e342e #37474f #455a64 #212121
#ffffff
         */
        NSArray *colorHexStringArr = @[@"ff8a80",@"ff5252",@"f44336",@"ff80ab",@"ff4081",@"e91e63",@"ea80fc",@"e040fb",@"9c27b0",
                                    @"b388ff",@"7c4dff",@"673ab7",@"8c9eff",@"536dfe",@"3f51b5",@"42a5f5",@"2979ff",@"2962ff",
                                    @"80d8ff",@"40c4ff",@"03a9f4",@"18ffff",@"00bcd4",@"64ffda",@"1de9b6",@"69f0ae",@"009688",
                                    @"00e676",@"4caf50",@"b2ff59",@"76ff03",@"8bc34a",@"cddc39",@"ffce1a",@"ffff00",@"ff9800",
                                    @"ef6c00",@"ff5722",@"ff3d00",@"bf360c",@"6d4c41",@"4e342e",@"37474f",@"455a64",@"212121",
                                       @"ffffff"];
        
        _colorArr = [[NSMutableArray alloc]init];
        for (NSString *hexString in colorHexStringArr) {
            UIColor *color = [UIColor colorWithHexColorString:hexString];
            [_colorArr addObject:color];
        }
//        for (float i = 0; i<3; i++) {
//            for (float j = 0; j<3; j++) {
//                for (float k = 0; k<3; k++) {
//                    UIColor *color = [UIColor colorWithRed:k*0.5 green:j*0.5 blue:i*0.5 alpha:1.0f];
//                    [_colorArr addObject:color];
//                }
//            }
//        }
    }
    return _colorArr;
}
- (void)onSelectWordViewOkClick:(UIButton *)sender {
    [self dismissToolView];
}

#pragma mark ---🔌添加文字
- (IBAction)onInsertTextClick:(UIButton *)sender {
    DbLog(@"ipt text %@",self.inputTF.text);
    __weak typeof(self) wkSelf = self;
    XwordView *xwv = (XwordView *)[[[XwordView alloc]init]returnWordView:self.inputTF.text color:self.colorOfTextToAdd fontName:wkSelf.nameOfFontToAdd onSuperView:wkSelf.ev.bgView tapBlock:^(Xview *Xview) {
        wkSelf.ev.currentWaterView = Xview;
        [wkSelf tapXview:Xview];
    }];
    
    self.ev.currentWaterView = xwv;
    //移除
    for (UIView *view  in self.ipTV.subviews) {//移除inputToolVIew子视图
        [view removeFromSuperview];
    }
    //移除inputView
    [self.ipTV.superview removeFromSuperview];
    if (self.ipTV) {
        [self.ipTV removeFromSuperview];
    }
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 键盘的frame发生改变时调用（显示、隐藏等）
    DbLog(@"键盘改变");
    if (!self.ipTV) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DbLog(@"keyb %@ screen %f %f",NSStringFromCGRect(keyboardF),SCREEN_H,SCREEN_W);
    // 执行动画
    __weak typeof(self) wkSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = wkSelf.ipTV.frame;
        rect.origin.y = keyboardF.origin.y-rect.size.height;
        wkSelf.ipTV.frame = rect;
    }];
}

#pragma mark ---涂鸦相关
- (IBAction)onScrawClick:(UIButton *)sender {//点击了涂鸦
    MosaicViewController *mosaicVC = [[MosaicViewController alloc]initWithNibName:@"MosaicViewController" bundle:nil];
    EditingPicModel *emodel = self.editingPicModelArray[_currentIndex];
    mosaicVC.editImage = emodel.img;
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//    [self wxs_presentViewController:mosaicVC makeTransition:^(WXSTransitionProperty *transition) {
//        transition.animationType = WXSTransitionAnimationTypeViewMoveNormalToNextVC;
//        
//        transition.animationTime = 0.2;
//        transition.startView  = self.ev.bgView;
//        transition.targetView = mosaicVC.imageView;
//    }];
    __weak typeof(self)wkSelf = self;
    mosaicVC.editFinishedBlock = ^(UIImage *image) {
        emodel.img = image;
        [wkSelf loadImage:_currentIndex animate:NO];
    };
    mosaicVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mosaicVC animated:YES completion:nil];
//    __weak typeof(self) wkSelf = self;
//    [self.screwlSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
//        //        make.top.equalTo(self.view.mas_top);
//        make.top.bottom.equalTo(wkSelf.navigationController.view);
//    }];
//    [self.view layoutIfNeeded];
//    [self.screwlSelectView animateShow];
//    self.toolView = self.screwlSelectView;
//    self.shareBtn.selected = YES;
}

-(void)dismissToolView{
    __weak typeof(self) wkSelf = self;
    [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wkSelf.view.mas_bottom);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.toolView = nil;
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    UIView *view = [touch view];
//    if ([view isKindOfClass:[evBgVIew class]]) {
//        if (self.ev.currentWaterView) {
//            self.ev.currentWaterView.Xselected = NO;
//            self.ev.currentWaterView = nil;
//        }
//    }
////    [self.ev noSelected];
//}
#pragma mark ---🖐️点击保存或者分享按钮
- (IBAction)onShareCLick:(UIButton *)sender {
    [self.ev noSelected];
    if (sender.selected) {
        [self dismissToolView];
        sender.selected = NO;
    }else{
        self.scrView.contentOffset = CGPointMake(0, 0);
        CoreSVPLoading(@"正在生成图片", YES);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self prepareProductPhotos];
        });
    }
}


/**
 准备生成图片
 */
-(void)prepareProductPhotos
{
    [self.productPhotos removeAllObjects];
    
    [self productPicAtIndex:0];
}


/**
 使用递归生成图片，防止异步处理导致的显示错乱

 @param index 当前处理的下标
 */
-(void)productPicAtIndex:(NSUInteger)index{
    EditingPicModel *emodel = self.editingPicModelArray[index];
    self.ev.img = emodel.img;
    for (Xview *aXview in self.xViewsArray) {
        //取出在当前图片上的显示描述
        [aXview setShowViewIndex:index];
    }
    //        [wkSelf loadXviewsOfPicModelAtIndex:index];
    //        [wkSelf loadSubviews:index];
    UIImage *img = [UIImage cutFromView:self.ev.bgView];
    [self.productPhotos addObject:img];
    if (index == self.editingPicModelArray.count-1) {
        [self loadImage:_currentIndex animate:YES];
        [CoreSVP dismiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ShareViewController" sender:self];
            [self.scrView setContentOffset:CGPointMake(self.scrView.bounds.size.width, 0)];
        });
    }else{
        [self productPicAtIndex:index +1];
    }
    
    /*
    PHAsset *asset = self.assetArray[index];
    __weak typeof(self)wkSelf = self;
    __block NSUInteger nxtIndex = index+1;
    
    [asset requestImageForTargetSize:[self currentUserSetSize] resultHandler:^(UIImage *result, NSDictionary *info) {
        
        wkSelf.ev.img = result;
        for (Xview *aXview in self.xViewsArray) {
            //取出在当前图片上的显示描述
            [aXview setShowViewIndex:index];
        }
//        [wkSelf loadXviewsOfPicModelAtIndex:index];
//        [wkSelf loadSubviews:index];
        UIImage *img = [UIImage cutFromView:wkSelf.ev.bgView];
        [wkSelf.productPhotos addObject:img];
        
        DbLog(@"生成了图片%@",img);
        if (index==wkSelf.editingPicModelArray.count-1) {//剪完了，返回去
            [wkSelf loadImage:wkSelf.currentIndex animate:YES];
            
//            [wkSelf loadSubviews:wkSelf.currentIndex];
            [CoreSVP dismiss];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wkSelf performSegueWithIdentifier:@"ShareViewController" sender:wkSelf];
                [wkSelf.scrView setContentOffset:CGPointMake(wkSelf.scrView.bounds.size.width, 0)];
            });
        }else{
            DbLog(@"加载下一个%ld",nxtIndex);
            [wkSelf productPicAtIndex:nxtIndex];
        }
    }];
     */
}

/**
 返回用户指定清晰度的图片
 
 @param image 原图
 @return 指定清晰度的图片
 */
-(UIImage *)returnTrueGerdImg:(UIImage *)image
{
    PicQuality quality = [UserDefaultsManager CurrentPicQuality];
    switch (quality) {
        case PicQualityNormal:
        {
            NSData *imgData = UIImageJPEGRepresentation(image, 0.6);
            
            return [UIImage imageWithData:imgData];
        }
            break;
        case PicQualityHeight:
        {
            NSData *imgData = UIImageJPEGRepresentation(image, 0.9);
            
            return [UIImage imageWithData:imgData];
        }
            break;
        case PicQualityOriginal:
        {
            return image;
        }
            break;
            
        default:
        {
            NSData *imgData = UIImageJPEGRepresentation(image, 0.6);
            
            return [UIImage imageWithData:imgData];
        }
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShareViewController"]) {
        ShareViewController *shavc = (ShareViewController*)segue.destinationViewController;
//        NSAssert(self.productPhotos, @"空数组！");
        shavc.photos = [NSArray arrayWithArray:self.productPhotos];
    }
}
- (IBAction)onPiliangClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}


/**
 当前设置的清晰度对应的图片大小

 @return 大小
 */
-(CGSize)currentUserSetSize{
    PicQuality currentQuality = [UserDefaultsManager CurrentPicQuality];
    switch (currentQuality) {
        case PicQualityNormal:
        {
            return CGSizeMake(750, 1334);
        }
            break;
        case PicQualityHeight:
        {
            return CGSizeMake(1080, 1920);
        }
            break;
        case PicQualityOriginal:
        {
            return PHImageManagerMaximumSize;
        }
            break;
        default:
        {
            return CGSizeMake(750, 1334);
        }
            break;
    }
}
@end
