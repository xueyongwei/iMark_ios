//
//  ShareViewController.m
//  XYW
//
//  Created by xueyongwei on 16/4/8.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ShareViewController.h"
#import "SavePicCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UMengSocial/UMSocial.h>
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "GDTMobBannerView.h"
#import "AFHTTPSessionManager+SharedManager.h"
#import <YYKit.h>
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <QiniuSDK.h>
#import "UploadManager.h"
#import "UserDefaultsManager.h"
#import "LLImageHandler.h"
@interface ShareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,GDTMobBannerViewDelegate>
{
    GDTMobBannerView *_bannerView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *shareBoardVIew;
@property (weak, nonatomic) IBOutlet UIButton *saveToAlbumBtn;
@property (weak, nonatomic) IBOutlet UIView *BannerBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerBgViewHeightConst;

@property (nonatomic,copy)NSString *uploadIp;
@end

@implementation ShareViewController
{
    UIActivityViewController *activityViewController;
}
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
    _bannerView = [[GDTMobBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:@"1106152866" placementId:@"1030420276266036"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBannerView];
    [self createAlbumInPhoneAlbum];
    [self.collectionView registerClass:[SavePicCollectionViewCell class] forCellWithReuseIdentifier:@"SavePicCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    dispatch_async(dispatch_queue_create("pub_xyw_preparedata",DISPATCH_QUEUE_CONCURRENT), ^{
        activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:self.photos
                                          applicationActivities:nil];
//        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    });
    [self SvaeToAlbum];
    // Do any additional setup after loading the view.
//    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
//    NSNumber *nubSave = [usf objectForKey:@"autosave"];
//    if (nubSave) {
//        if (nubSave.integerValue ==1) {
//            [self saveToAlbumBtn];
//            self.saveToAlbumBtn.hidden = YES;
//        }else
//        {
//            self.saveToAlbumBtn.hidden = NO;
//        }
//    }
    [self custonShareBord];
    [self customBackNaviBarBtn];
    
}

-(void)loadBannerView{
    _bannerView.delegate = self;
    _bannerView.currentViewController = self;
    _bannerView.interval = 3.0;
//    _bannerView.frame = CGRectMake(0, 0, SCREEN_W, 50);
    _bannerView.showCloseBtn = YES;
    [self.BannerBgView addSubview:_bannerView];
//    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.bottom.top.equalTo(self.BannerBgView);
//    }];
    [_bannerView loadAdAndShow];
}
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
-(void)custonShareBord
{
    //短信
    int i = 0,j=0;
    UIButton *btnDX = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDX.titleLabel.textColor = [UIColor redColor];
    [btnDX setImage:[UIImage imageNamed:@"分享到短信"] forState:UIControlStateNormal];
    btnDX.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    btnDX.frame = CGRectMake(10+i*(SCREEN_W-20)/5, 30+j*55, (SCREEN_W-20)/5, 60);
    [btnDX addTarget:self action:@selector(onshareToSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBoardVIew addSubview:btnDX];
    i++;
    //微博
    UIButton *btnWB = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWB.titleLabel.textColor = [UIColor redColor];
    btnWB.frame = CGRectMake(10+i*(SCREEN_W-20)/5, 30+j*55, (SCREEN_W-20)/5, 60);
    [btnWB setImage:[UIImage imageNamed:@"分享到微博"] forState:UIControlStateNormal];
    btnWB.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnWB addTarget:self action:@selector(onshareToWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBoardVIew addSubview:btnWB];
    i++;
    //微信
    /*
    if ([WXApi isWXAppInstalled]) {
        UIButton *btnWX = [UIButton buttonWithType:UIButtonTypeCustom];
        btnWX.titleLabel.textColor = [UIColor redColor];
        [btnWX setImage:[UIImage imageNamed:@"分享到微信"] forState:UIControlStateNormal];
        btnWX.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnWX.frame = CGRectMake(20+i*SCREEN_W/4, 30+j*55, SCREEN_W/5-40, 50);
        [btnWX addTarget:self action:@selector(onshareToWX) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBoardVIew addSubview:btnWX];
        i++;
        UIButton *btnPYQ = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPYQ.titleLabel.textColor = [UIColor redColor];
        [btnPYQ setImage:[UIImage imageNamed:@"分享到朋友圈"] forState:UIControlStateNormal];
        btnPYQ.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnPYQ.frame = CGRectMake(20+i*SCREEN_W/4, 30+j*55, SCREEN_W/5-40, 50);
        [btnPYQ addTarget:self action:@selector(onshareToPYQ) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBoardVIew addSubview:btnPYQ];
        i++;
    }
    
    if (i>3) {
        j=1;
        i=0;
    }
      */
    if ([QQApiInterface isQQInstalled]) {
        UIButton *btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
        btnQQ.titleLabel.textColor = [UIColor redColor];
        [btnQQ setImage:[UIImage imageNamed:@"分享到QQ" ] forState:UIControlStateNormal];
        btnQQ.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnQQ.frame = CGRectMake(10+i*(SCREEN_W-20)/5, 30+j*55, (SCREEN_W-20)/5, 60);
        [btnQQ addTarget:self action:@selector(onshareToQQ) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBoardVIew addSubview:btnQQ];
        i++;
        UIButton *btnKJ = [UIButton buttonWithType:UIButtonTypeCustom];
        btnKJ.titleLabel.textColor = [UIColor redColor];
        [btnKJ setImage:[UIImage imageNamed:@"分享到空间"] forState:UIControlStateNormal];
        btnKJ.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnKJ.frame = CGRectMake(10+i*(SCREEN_W-20)/5, 30+j*55, (SCREEN_W-20)/5, 60);
        [btnKJ addTarget:self action:@selector(onshareToKJ) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBoardVIew addSubview:btnKJ];
        i++;
    }
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMore.titleLabel.textColor = [UIColor redColor];
    [btnMore setImage:[UIImage imageNamed:@"分享到更多"] forState:UIControlStateNormal];
    btnMore.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnMore.frame = CGRectMake(10+i*(SCREEN_W-20)/5, 30+j*55, (SCREEN_W-20)/5, 60);
    [btnMore addTarget:self action:@selector(onshareToMore:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBoardVIew addSubview:btnMore];
}

-(void)onshareToSMS
{
    [MobClick event:@"sharecount"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:@"分享照片" image:self.photos.lastObject location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DbLog(@"分享成功！");
            [MobClick event:@"shareSucess"];
        }
    }];
}

- (void)onshareToWeibo:(UIButton *)sender {
    [MobClick event:@"sharecount"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享照片" image:self.photos.lastObject location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DbLog(@"分享成功！");
            [MobClick event:@"shareSucess"];
        }
    }];
}
-(void)onshareToWX
{
    [MobClick event:@"sharecount"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"爱水印" image:self.photos.lastObject location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DbLog(@"分享成功！");
            [MobClick event:@"shareSucess"];
        }
    }];
}
-(void)onshareToPYQ
{
    [MobClick event:@"sharecount"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"爱水印" image:self.photos.lastObject location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DbLog(@"分享成功！");
            [MobClick event:@"shareSucess"];
        }
    }];
}
-(void)onshareToQQ
{
    [MobClick event:@"sharecount"];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享照片" image:self.photos.lastObject location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DbLog(@"分享成功！");
            [MobClick event:@"shareSucess"];
        }
    }];
}
-(void)onshareToKJ
{
    [MobClick event:@"sharecount"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"分享照片" image:self.photos.lastObject location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
           DbLog(@"分享成功！");
            [MobClick event:@"shareSucess"];
        }
    }];
}
- (void)onshareToMore:(UIButton *)sender {
    [MobClick event:@"sharecount"];
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         [MobClick event:@"shareSucess"];
                     }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-20)/3-1, (SCREEN_W-20)/3-1);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5,5);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DbLog(@"%@",self.photos[indexPath.row]);
    SavePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SavePicCollectionViewCell" forIndexPath:indexPath];
    cell.imgView.image = self.photos[indexPath.item];
    return cell;
}
-(PHAssetCollection *)createAssetCollection{
    
    //判断是否已存在
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection * assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:@"爱水印"]) {
            //说明已经有哪对象了
            return assetCollection;
        }
    }
    
    //创建新的相簿
    __block NSString *assetCollectionLocalIdentifier = nil;
    NSError *error = nil;
    //同步方法
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"爱水印"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error)return nil;
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}
#pragma mark ---🔌保存到“爱水印”的相册
/**
 *  获得刚才添加到【相机胶卷】中的图片
 */
- (PHFetchResult<PHAsset *> *)createdAssets:(UIImage *)image
{
    __block NSString *createdAssetId = nil;
    
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    if (createdAssetId == nil) return nil;
    
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

/**
 *  获得【自定义相册】
 */
- (PHAssetCollection *)createdCollection
{
    // 获取软件的名字作为相册的标题
    NSString *title = @"爱水印";
    
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    // 代码执行到这里，说明还没有自定义相册
    
    __block NSString *createdCollectionId = nil;
    
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    if (createdCollectionId == nil) return nil;
    
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}

/**
 *  保存图片到相册
 */
- (void)saveImageIntoAlbum
{
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    for (UIImage *image in self.photos) {
        // 获得相片
        PHFetchResult<PHAsset *> *createdAssets = [self createdAssets:image];
        if (createdAssets == nil || createdCollection == nil) {
            CoreSVPCenterMsg(@"保存失败！");
            return;
        }
        // 将相片添加到相册
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
            [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
    }
}
- (void)SvaeToAlbum{
    [self saveImageIntoAlbum];
    /*
    PHAssetCollection *createdAssetCollection = [self createAssetCollection];
    if (createdAssetCollection == nil) {
        DbLog(@"保存图片成功----(创建相簿失败!)");
        return;
    }
    CoreSVPLoading(@"waiting..", NO);
    for (UIImage *image in self.photos) {
        __block  NSString *assetLocalIdentifier;
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            //1.保存图片到相机胶卷中----创建图片的请求
            assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success == NO){
                DbLog(@"保存图片失败----(创建图片的请求)");
                return ;
            }
            DbLog(@"保存图片成功----》移动到爱水印相册");
//            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
//                //获得图片
//                PHFetchResult *assetsResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil];
//                if (assetsResult.count==0) {
//                    CoreSVPCenterMsg(@"保存失败！");
//                }
//                PHAsset *asset = assetsResult.firstObject;
//                //添加图片到相簿中的请求
//                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
//                // 添加图片到相簿
//                if (!asset) {
//                    CoreSVPCenterMsg(@"保存失败！");
//                }
//                [request addAssets:@[asset]];
//            } completionHandler:^(BOOL success, NSError * _Nullable error) {
//                if(success){
//                    NSLog(@"保存图片到创建的相簿成功");
//                }else{  
//                    NSLog(@"保存图片到创建的相簿失败");  
//                }  
//            }];  
        }];
//        [self saveToAlbumWithMetadata:nil imageData:UIImageJPEGRepresentation(image, 1) customAlbumName:@"爱水印" completionBlock:^{
//            CoreSVPCenterMsg(@"已保存到相册");
//        } failureBlock:^(NSError *error) {
//            CoreSVPCenterMsg(error.localizedDescription);
//        }];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onHomeClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark --🔌创建爱水印的相册
- (void)createAlbumInPhoneAlbum
{
    //判断是否已存在
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection * assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:@"爱水印"]) {
            //说明已经有哪对象了
            return ;
        }
    }
    //创建新的相簿
    __block NSString *assetCollectionLocalIdentifier = nil;
    NSError *error = nil;
    //同步方法
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"爱水印"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error){
        DbLog(@"相册创建失败 ");
    }
}


#pragma mark -- 分享到逛逛
- (IBAction)onShareAlertOkClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];

}

- (IBAction)onShareToGuangClick:(UIButton *)sender {
    
    if (![UserDefaultsManager canShareToGuangToday]) {
        UIView *showV = [[[NSBundle mainBundle]loadNibNamed:@"ShareGuagTimesLimitView" owner:self options:nil]lastObject];
        [self.navigationController.view addSubview:showV];
        [showV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.navigationController.view);
        }];
        return;
        
//        ShareGuagTimesLimitView
//        UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"每天仅可分享至逛逛三次，明天再来哦~" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
//        [alv show];
        return;
    }
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus ==AFNetworkReachabilityStatusNotReachable) {
        CoreSVPCenterMsg(@"未检测到网络，请查看网络设置");
    }else{
        CoreSVPCenterMsg(@"已上传");
        [[UploadManager manager] uploadImages:self.photos];
        sender.enabled = NO;
    }
}

#pragma mark -- 广告时间到
-(void)bannerViewDidReceived
{
     DbLog(@"广告获取成功 ");
    self.bannerBgViewHeightConst.constant = 50;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
// 请求广告条数据失败后调用
- (void)bannerViewFailToReceived:(NSError *)error{
    DbLog(@"获取广告失败了 %ld %@",error.code,error.localizedDescription);
}
-(void)bannerViewWillClose{
    self.bannerBgViewHeightConst.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];

}
-(void)bannerViewClicked
{
    DbLog(@"广告点击一次 ");
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
