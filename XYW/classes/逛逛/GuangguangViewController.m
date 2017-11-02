//
//  GuangguangViewController.m
//  XYW
//
//  Created by xueyognwei on 2017/5/31.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "GuangguangViewController.h"
#import "UIImage+Color.h"
#import "WaterFlowLayout.h"
#import "GuangguangCollectionViewCell.h"
#import "AFHTTPSessionManager+SharedManager.h"
#import "GuangModel.h"
#import <YYKit.h>
//#import "ImageShowViewController.h"
#import "GuangPreImageViewController.h"
#import "UINavigationController+WXSTransition.h"
#import <MJRefresh.h>

#import <InMobiSDK/InMobiSDK.h>
@interface GuangguangViewController () <WaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate,GuangPreImageViewControllerDelegate,IMNativeDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *bgColorArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) UIView *retryView;
//@property (nonatomic,strong) AdNativeManager *nativeManager;
@property (nonatomic,strong) GuangPreImageViewController *showVC;
@property (nonatomic, strong) IMNative* native;
@end

@implementation GuangguangViewController
{
    BOOL _requestingData;
    NSInteger _currentBgColorIndex;
}
-(UIView *)retryView
{
    if (!_retryView) {
        _retryView = [[[NSBundle mainBundle]loadNibNamed:@"GuangRetryView" owner:self options:nil]lastObject];
    }
    return _retryView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CoreSVP dismiss];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor colorWithHexColorString:@"ffffff"]] forBarMetrics:0];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArray];
    [self customBackNaviBarBtn];
    [self customCollectionView];
//    self.nativeManager=[AdNativeManager managerWithAdNativeKey:@"SDK2017160804054084d3q45erwz3a93" WithDelegate:self];
    
    self.currentPage = 1;
    [self requestDataOfPage:self.currentPage];
    self.native = [[IMNative alloc] initWithPlacementId:1498109765717];
    self.native.delegate = self;
    [self.native load];
    // Do any additional setup after loading the view.
}
-(void)initArray{
    self.dataSource = [[NSMutableArray alloc]init];
    self.bgColorArray = @[@"f9f5ce",@"e7eaa8",@"dafaf8",@"fdd2fa",@"daefa9",@"ffd3b6",@"ffecba",@"ffdede",@"dbd8e3",@"b9dbe6"];
}
-(void)customBackNaviBarBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"naviDarkBack"] forState:UIControlStateNormal];
    //    [btn setTitle:@"❮ 返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 12, 21);
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itm = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = itm;
}
-(void)backHandle
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customCollectionView{
    WaterFlowLayout *water = [[WaterFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = water;
    water.delegate = self;
    UINib *cellNib=[UINib nibWithNibName:@"GuangguangCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"GuangguangCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // The drop-down refresh
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self requestDataOfPage:_currentPage];
    }];
    
    // The pull to refresh
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataOfPage:_currentPage];
    }];
}
#pragma mark -- 准备数据
-(void)requestDataOfPage:(NSInteger)page{
    if (_requestingData) {
        DbLog(@"正在请求，放弃");
        return;
    }
    _requestingData = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    __weak typeof(self) wkSelf = self;
    if (self.dataSource.count==0) {
        CoreSVPLoading(@"loading", YES);
    }
    NSString *url = [NSString stringWithFormat:@"%@/i_guang/v1.0/photos?page=%ld&per_page=10",HeadUrl,(long)page];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _requestingData = NO;
        [CoreSVP dismiss];
        [wkSelf.collectionView.mj_header endRefreshing];
        [wkSelf.collectionView.mj_footer endRefreshing];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *datas = [responseObject objectForKey:@"datas"];
            if (page ==1) {
                [wkSelf.dataSource removeAllObjects];
                [wkSelf.collectionView.mj_footer resetNoMoreData];
            }
            if (datas && datas.count>0) {
                DbLog(@"逛逛的数据：%@",datas);
                for (NSDictionary *data in datas) {
                    GuangModel *model = [GuangModel modelWithDictionary:data];
                    [wkSelf.dataSource addObject:model];
                }
                wkSelf.currentPage +=1;
                [wkSelf.collectionView reloadData];
                if (self.showVC) {
                    [self.showVC reloadData];
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [self.nativeManager loadNativeAd:1];
                });
            }else{
                [wkSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _requestingData = NO;
        [CoreSVP dismiss];
        [wkSelf showRetryView];
        [wkSelf.collectionView.mj_header endRefreshing];
        [wkSelf.collectionView.mj_footer endRefreshing];
        CoreSVPCenterMsg(error.localizedDescription);
    }];
}

#pragma mark --collectionView 代理

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GuangguangCollectionViewCell";
    GuangguangCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    GuangModel *model = self.dataSource[indexPath.item];
    cell.model = model;
    cell.backgroundColor = [self currentCellBgColor];
    [self tryToLoadNewDataWithIndexPath:indexPath.item];
    return cell;
}
-(UIColor *)currentCellBgColor{
    if (_currentBgColorIndex>self.bgColorArray.count-1) {
        _currentBgColorIndex = 0;
    }
    UIColor *color = [UIColor colorWithHexString:self.bgColorArray[_currentBgColorIndex]];
    _currentBgColorIndex ++;
    
    return color;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GuangModel *model = self.dataSource[indexPath.item];
    if (model.adView) {
        NSURL *url = [NSURL URLWithString:model.linkUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
        return;
    }
    GuangPreImageViewController *showVC = [[GuangPreImageViewController alloc]initWithNibName:@"GuangPreImageViewController" bundle:nil];
    showVC.guangModelsArray = self.dataSource;
    showVC.delegate = self;
    showVC.currentImageIndex = indexPath.item;
    self.showVC = showVC;
    showVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:showVC animated:YES completion:nil];
    
}
- (CGFloat)WaterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForRowAtIndexPath:(NSInteger )index itemWidth:(CGFloat)itemWidth
{
    GuangModel *model = self.dataSource[index];
    
    return itemWidth * model.height / model.width;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showRetryView{
    [self.view addSubview:self.retryView];
    [self.retryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.leading.equalTo(self.view);
    }];
}
- (IBAction)onRetryClick:(UIButton *)sender {
    [self.retryView removeAllSubviews];
    [self.retryView removeFromSuperview];
    self.retryView = nil;
    [self requestDataOfPage:self.currentPage];
}

#pragma mark -- 自动加载数据
-(void)tryToLoadNewDataWithIndexPath:(NSInteger )index{
    if (self.dataSource.count-index<5) {
        DbLog(@"尝试请求下一页:%ld",(long)_currentPage);
        [self requestDataOfPage:_currentPage];
    }
}
#pragma mark -- guangPreImageViewController 代理

-(void)showImageOfIndex:(NSInteger)index
{
    DbLog(@"showImageOfIndex %ld,will tryToLoadNewDataWithIndexPath",(long)index);
    [self tryToLoadNewDataWithIndexPath:index];
}
-(void)detailVCDismissWithIndex:(NSInteger)index
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

#pragma mark - IMNative Delegate

/**
 * The native ad has finished loading
 */
-(void)nativeDidFinishLoading:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSData* data = [native.adContent dataUsingEncoding:NSUTF8StringEncoding];
//    NSError* error = nil;
//    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSDictionary *screenshots = jsonDict[@"screenshots"];
//    /*The above lines of code convert the native JSON content to NSDictionary.*/
//    if (error == nil && jsonDict != nil)  {
//        // The native JSON is parsed and can be used.
//        NSString *imgUrlStr = screenshots[@"url"];
//        NSString *linkStr = jsonDict[@"landingURL"];
//        NSInteger height = [NSString stringWithFormat:@"%@",screenshots[@"height"]].integerValue ;
//        NSInteger width = [NSString stringWithFormat:@"%@",screenshots[@"width"]].integerValue ;
//        NSMutableDictionary* nativeJsonDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//        [nativeJsonDict setValue:[NSNumber numberWithBool:YES] forKey:@"isAd"];
//        GuangModel *model  = [[GuangModel alloc]init];
//        
//        model.url = imgUrlStr;
//        model.linkUrl = linkStr;
//        model.adView = YES;
//        model.width = width;
//        model.height = height;
//        model.nativeADInfo = nativeJsonDict;
//        DbLog(@"imgUrlStr=%@ linkStr=%@",imgUrlStr,linkStr);
//        if (self.dataSource.count>5) {
//            [self.dataSource insertObject:model atIndex:5];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:5 inSection:0]]];
//            });
//        }else{
//            [self.dataSource addObject:model];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self .collectionView reloadData];
//            });
//        }
//    }
//    NSLog(@"JSON content is %@", native);
    
}
-(void)nativeAdImpressed:(IMNative *)native
{
    
}
/**
 * The native ad has failed to load with error.
 */
-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Native ad failed to load with error %@", error);
}
/**
 * The native ad would be presenting a full screen content.
 */
-(void)nativeWillPresentScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The native ad has presented a full screen content.
 */
-(void)nativeDidPresentScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The native ad would be dismissing the presented full screen content.
 */
-(void)nativeWillDismissScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The native ad has dismissed the presented full screen content.
 */
-(void)nativeDidDismissScreen:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The user will be taken outside the application context.
 */
-(void)userWillLeaveApplicationFromNative:(IMNative*)native {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
