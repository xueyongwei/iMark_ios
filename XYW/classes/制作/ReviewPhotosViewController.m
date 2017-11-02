//
//  ReviewPhotosViewController.m
//  XYW
//
//  Created by xueyognwei on 2017/6/1.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "ReviewPhotosViewController.h"
#import "PrePhotosCollectionViewCell.h"
#import "GDTMobBannerView.h"
#import "UIImage+Color.h"
#import "EditerViewController.h"
#import "UserDefaultsManager.h"
#import "AppDelegate.h"
#import <InMobiSDK/InMobiSDK.h>

@interface ReviewPhotosViewController () <UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GDTMobBannerViewDelegate,IMInterstitialDelegate>
{
    GDTMobBannerView *_bannerView;
}
@property (weak, nonatomic) IBOutlet UIView *adBgView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *naviCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adBgViewHeightConst;
@property (nonatomic,strong) IMInterstitial *rewardAD;

@end

@implementation ReviewPhotosViewController
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initBannerView];
    }
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initBannerView];
    }
    return self;
}
-(void)initBannerView{
    _bannerView = [[GDTMobBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:@"1106152866" placementId:@"6080924320420642"];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat const kLineSpacing = 20;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H-45);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, kLineSpacing);
        layout.minimumLineSpacing = kLineSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W + kLineSpacing, SCREEN_H-44) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [self.view insertSubview:_collectionView belowSubview:self.adBgView];
    }
    return _collectionView;
}
#pragma mark -- viewDidLoad
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.5]] forBarMetrics:0];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:0.5];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor colorWithHexColorString:@"e84f3c"]] forBarMetrics:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBannerView];
   
    [self customBackNaviBarBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customCollectionView];
    self.startBtn.enabled = self.selectePHAssets.count>0;
    NSString *btnTitle = [NSString stringWithFormat:@"开始制作（%lu）",(unsigned long)self.selectePHAssets.count];
    [self.startBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.startBtn setTitle:@"至少选一张" forState:UIControlStateDisabled];
    self.rewardAD = [[IMInterstitial alloc]initWithPlacementId:1497624300317 delegate:self];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DbLog(@"dealoc");
}
/**
 定制导航栏
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
-(void)backHandle
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadBannerView{
    _bannerView.delegate = self;
    _bannerView.currentViewController = self;
    _bannerView.interval = 3.0;
    _bannerView.showCloseBtn = YES;
    [self.adBgView addSubview:_bannerView];
    [_bannerView loadAdAndShow];
}
-(void)customCollectionView{
    self.view.backgroundColor = [UIColor blackColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrePhotosCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PrePhotosCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
//    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.currentAssetIndex * self.collectionView.width, 0) animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma makr -- collectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.phAssetsArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PrePhotosCollectionViewCell";
    
    PrePhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    DbLog(@"%@",indexPath);
    PHAsset *asset = self.phAssetsArray[indexPath.item];
    cell.asset = asset;
//    if ([self.selectePHAssets containsObject:asset]) {
//        self.naviCheckBtn.selected = YES;
//        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//    }else{
//        self.naviCheckBtn.selected = NO;
//    }
    return cell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    return NO;
}
#pragma makr -- scrollView
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    self.currentAssetIndex = round(scrollView.contentOffset.x / scrollView.width);
//    PHAsset *asset = self.phAssetsArray[self.currentAssetIndex];
//    if ([self.selectePHAssets containsObject:asset]) {
//        self.naviCheckBtn.selected = YES;
//    }else{
//        self.naviCheckBtn.selected = NO;
//    }
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentAssetIndex = round(scrollView.contentOffset.x / scrollView.width);
    PHAsset *asset = self.phAssetsArray[self.currentAssetIndex];
    if ([self.selectePHAssets containsObject:asset]) {
        self.naviCheckBtn.selected = YES;
    }else{
        self.naviCheckBtn.selected = NO;
    }
}
#pragma mark -- 点击事件

- (IBAction)onNaviCheckClick:(UIButton *)sender {
    if (sender.selected) {//选中状态
        sender.selected = !sender.selected;
        if ([self.delegate respondsToSelector:@selector(deSelectedPhassetAtIndex:)]) {
            [self.delegate deSelectedPhassetAtIndex:self.currentAssetIndex];
        }
    }else{
        if ([self canGoonSelecteAsset]) {
            sender.selected = !sender.selected;
            if ([self.delegate respondsToSelector:@selector(selectedPhassetAtIndex:)]) {
                [self.delegate selectedPhassetAtIndex:self.currentAssetIndex];
            }
        }
    }
    self.startBtn.enabled = self.selectePHAssets.count>0;
    NSString *btnTitle = [NSString stringWithFormat:@"开始制作（%lu）",(unsigned long)self.selectePHAssets.count];
    [self.startBtn setTitle:btnTitle forState:UIControlStateNormal];
}
- (IBAction)onStartClick:(UIButton *)sender {
    if (self.selectePHAssets.count==0) {
        CoreSVPCenterMsg(@"客官，至少选一张嘛～");
    }else{
        [self performSegueWithIdentifier:@"EditerViewController" sender:nil];
    }
}
-(BOOL)canGoonSelecteAsset{
    if ([UserDefaultsManager HaveUnlock9]) {
        if (self.selectePHAssets.count==9) {
            CoreSVPCenterMsg(@"最多选9张！");
            return NO;
        }
    }else{
        if (self.selectePHAssets.count==5) {
            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"解锁更多批量", nil) message:NSLocalizedString(@"浏览视频广告，即可获得9张批量权限", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:LocalStr(@"开始"), nil];
            alv.tag = 666;
            [alv show];
            return NO;
        }
    }
    return YES;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -- alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 666) {//解锁批量
        if (buttonIndex == 1) {
            [self.rewardAD load];
        }
    }
}

#pragma mark -- 广告时间到
-(void)bannerViewDidReceived
{
    DbLog(@"广告获取成功 ");
    self.adBgViewHeightConst.constant = 50;
    [self.view layoutIfNeeded];

}
// 请求广告条数据失败后调用
- (void)bannerViewFailToReceived:(NSError *)error{
    DbLog(@"获取广告失败了 %ld %@",error.code,error.localizedDescription);
}
-(void)bannerViewWillClose{
    self.adBgViewHeightConst.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
-(void)bannerViewClicked
{
    DbLog(@"广告点击一次 ");
}

- (void)showVideo
{
    [self.rewardAD showFromViewController:self withAnimation:kIMInterstitialAnimationTypeCoverVertical];
    ((AppDelegate *) [UIApplication sharedApplication].delegate).canShowADInWiondw = NO;
//    if ([self.rewardAD isReady]) {
//        
//    }else{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self showVideo];
//        });
//    }
}
#pragma mark --imbobi delegate
- (void)interstitial:(IMInterstitial *)rewardedAd didFailToLoadWithError:(IMRequestStatus *)error{
    DbLog(@"Rewarded Ad Failed to load with error: %@",error.description);
    [CoreSVP dismiss];
    CoreSVPCenterMsg(@"广告拉取失败，稍后重试");
}
- (void)interstitial:(IMInterstitial *)rewardedAd didFailToPresentWithError:(IMRequestStatus *)error {
    DbLog(@"Rewarded Ad Failed to Present with error : %@",error.description);
}
- (void)interstitial:(IMInterstitial *)rewardedAd didInteractWithParams:(NSDictionary *)params {
    DbLog(@"Rewarded Ad did interact with param : %@",params);
}
- (void)interstitial:(IMInterstitial *)rewardedAd rewardActionCompletedWithRewards:(NSDictionary *)rewards {
    //Write code here to parse the rewards that you have set up and pass it on to the user.
    DbLog(@"Rewarded Ad action completed with Rewards : %@",rewards);
    [UserDefaultsManager setHaveUnlock9:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).canShowADInWiondw = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        CoreSVPCenterMsg(@"已获得9张批量权限！");
    });
    
}
- (void)interstitialDidDismiss:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Did Dismiss");
}
- (void)interstitialDidFinishLoading:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Did Finish Loading");
    [CoreSVP dismiss];
    [self showVideo];
    //    [self.rewardAD showFromViewController:self withAnimation:kIMInterstitialAnimationTypeCoverVertical];
}
- (void)interstitialDidPresent:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Did Present");
    ((AppDelegate *) [UIApplication sharedApplication].delegate).canShowADInWiondw = YES;
}
- (void)interstitialWillDismiss:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Will Dismiss");
}
- (void)interstitialWillPresent:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Will Present");
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditerViewController"]) {
        EditerViewController *edv = segue.destinationViewController;
        edv.assetArray = self.selectePHAssets;
    }
}



@end
