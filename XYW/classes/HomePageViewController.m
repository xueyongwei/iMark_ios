//
//  HomePageViewController.m
//  XYW
//
//  Created by xueyognwei on 2017/5/31.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageItemCollectionViewCell.h"

#import "HomePageItemModel.h"
#import "LLImageHandler.h"
#import "UIImage+Color.h"
#import "HomePageBarnerAdModel.h"
#import "AFHTTPSessionManager+SharedManager.h"
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>
#import <YYKit.h>
#import <InMobiSDK/InMobiSDK.h>
@interface HomePageViewController () <UICollectionViewDelegate,UICollectionViewDataSource,IMNativeDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *barnerPalceImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *TopScrolView;

@property (nonatomic,strong) NSMutableArray *itemsArray;//条目类型
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray <HomePageBarnerAdModel *> *barnerAds;
@property(nonatomic,strong) IMNative *InMobiNativeAd1;
@property(nonatomic,strong) IMNative *InMobiNativeAd2;
@property(nonatomic,strong) IMNative *InMobiNativeAdIcon1;
@end

@implementation HomePageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor colorWithHexColorString:@"e84f3c"]] forBarMetrics:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarnerAdsArray];
    [self setupTimer];
//    [self customBarnerView];
    [self customCollectionView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // Do any additional setup after loading the view.
}
-(void)dealloc {
    [self.InMobiNativeAd1 recyclePrimaryView];
    self.InMobiNativeAd1.delegate = nil;
    self.InMobiNativeAd1 = nil;
    
    [self.InMobiNativeAd2 recyclePrimaryView];
    self.InMobiNativeAd2.delegate = nil;
    self.InMobiNativeAd2 = nil;
}
-(void)refreshHomeADs{
    [self.TopScrolView removeAllSubviews];
    NSInteger i =0;
    
    CGFloat height = SCREEN_W/(256/135);
    if (self.barnerAds.count>0) {
        self.TopScrolView.contentSize = CGSizeMake(SCREEN_W*self.barnerAds.count, 0);
        
        self.barnerPalceImageView.image = [UIImage imageNamed:@"homPagePlaceHolder"];
        for (HomePageBarnerAdModel *model in self.barnerAds) {
            UIView *adPlaceView = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_W, 0, SCREEN_W, height)];
            adPlaceView.userInteractionEnabled = YES;
            [self.TopScrolView addSubview:adPlaceView];
            if (!model.native) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:adPlaceView.bounds];
                [imageView setImageURL:[NSURL URLWithString:model.banner]];
                [adPlaceView addSubview:imageView];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:model action:@selector(openAd)];
                [adPlaceView addGestureRecognizer:tap];
            }else{
                UIView* AdPrimaryViewOfCorrectWidth = [model.native primaryViewOfWidth:adPlaceView.bounds.size.width];
                AdPrimaryViewOfCorrectWidth.frame = adPlaceView.bounds;
                [AdPrimaryViewOfCorrectWidth setBackgroundColor:[UIColor whiteColor]];
                [adPlaceView addSubview:AdPrimaryViewOfCorrectWidth];
                
//                UITapGestureRecognizer *singleTapAndOpenLandingPage = [[UITapGestureRecognizer alloc] initWithTarget:model.native action:@selector(reportAdClickAndOpenLandingPage)];
//                [adPlaceView addGestureRecognizer:singleTapAndOpenLandingPage];
            }
            i++;
        }
        
    }else{
        self.barnerPalceImageView.image = [UIImage imageNamed:@"homPagePlaceHolder"];
    }
}
#pragma mark -- 自己的barner广告
-(void)initBarnerAdsArray{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        self.barnerAds = [[NSMutableArray alloc]init];
        [self loadAds];
    });
}
-(void)loadAds{
    [self.barnerAds removeAllObjects];
    [self requestServerBarnerAds];
    [self requestADViewNativeAds];
}
-(void)requestServerBarnerAds{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *bundle_id = [UIApplication sharedApplication].appBundleID;
        NSString *version = [UIApplication sharedApplication].appVersion;
        NSString *uid = @"";
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }else{
            uid = [[NSUUID UUID] UUIDString];
        }
        
        NSString *network = [self newWorkString];
        NSString *os_version = [NSString stringWithFormat:@"%.1f",[UIDevice systemVersion]];
        NSString *model = [self iphoneType];
        NSString *sign = [NSString stringWithFormat:@"bundle_id=%@&model=%@&network=%@&os_version=%@&uid=%@&version=%@%@",bundle_id,model,network,os_version,uid,version,bundle_id];
        NSString *urlstr = [NSString stringWithFormat:@"https://api.tools.superlabs.info/ad/v1.0/ios/gallery_ads?bundle_id=%@&model=%@&network=%@&os_version=%@&uid=%@&version=%@&sign=%@",bundle_id,model,network,os_version,uid,version,sign.md5String.uppercaseString];
        DbLog(@"sign = %@",sign);
        DbLog(@"url = %@",urlstr);
        
        [[AFHTTPSessionManager sharedManager] GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DbLog(@"%@",responseObject);
            if (![responseObject isKindOfClass:[NSArray class]]) {
                DbLog(@"返回数据有误 %@",responseObject);
                return ;
            }
            NSArray *result = (NSArray *)responseObject;
            if (result.count>0) {
                for (NSDictionary *dic in result) {
                    HomePageBarnerAdModel *model = [HomePageBarnerAdModel modelWithDictionary:dic];
                    [self.barnerAds addObject:model];
                }
                [self refreshHomeADs];
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DbLog(@"%@",error.localizedDescription);
        }];

    });
    
}

-(NSString *)newWorkString{
    AFNetworkReachabilityStatus networkState = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (networkState) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"4G";
            break;
        default:
            return @"unknown";
            break;
    }
    
}
- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

-(void)requestADViewNativeAds{
    self.InMobiNativeAd1 = [[IMNative alloc] initWithPlacementId:1497334504800];
    self.InMobiNativeAd1.delegate = self;
    [self.InMobiNativeAd1 load];
    
    self.InMobiNativeAd2 = [[IMNative alloc] initWithPlacementId:1500747543192];
    self.InMobiNativeAd2.delegate = self;
    [self.InMobiNativeAd2 load];
    
    
    self.InMobiNativeAdIcon1 = [[IMNative alloc] initWithPlacementId:1500790126619];
    self.InMobiNativeAdIcon1.delegate = self;
    [self.InMobiNativeAdIcon1 load];
    
}


-(NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc]init];
        [_itemsArray addObject:[HomePageItemModel modelWithImageName:@"homePageSucai" titleName:@"素材库" segueIdentifier:@"ShangChengViewController"]];
        [_itemsArray addObject:[HomePageItemModel modelWithImageName:@"homePageYibaocun" titleName:@"已保存" segueIdentifier:@"ImarkAlbumViewController"]];
//        [_itemsArray addObject:[HomePageItemModel modelWithImageName:@"homePageGuangguang" titleName:@"逛逛" segueIdentifier:@"GuangguangViewController"]];
        [_itemsArray addObject:[HomePageItemModel modelWithImageName:@"homePageSetting" titleName:@"设置" segueIdentifier:@"SettingViewController"]];
//        [_itemsArray addObject:[HomePageItemModel modelWithImageName:@"homePageSetting" titleName:@"设置" segueIdentifier:@""]];
    }
    return _itemsArray;
}

-(void)customCollectionView{
    //此处必须要有创见一个UICollectionViewFlowLayout的对象
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 0;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    CGSize collectionSize = _collectionView.bounds.size;
    layout.itemSize = CGSizeMake(collectionSize.width/3.0, collectionSize.width/3.0);
    //这个是横向滑动
//    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    //这种是xib建的cell 需要这么注册
    UINib *cellNib=[UINib nibWithNibName:@"HomePageItemCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"HomePageItemCollectionViewCell"];
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
//    _collectionView.pagingEnabled = YES;
    _collectionView.alwaysBounceVertical = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}
//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageItemModel *model = self.itemsArray[indexPath.item];
    HomePageItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageItemCollectionViewCell" forIndexPath:indexPath];
    if (model.native) {
        [cell.iconImageView removeAllSubviews];
        CGFloat width = cell.iconImageView.bounds.size.width*0.8;
        cell.iconImageView.image = nil;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.iconImageView.bounds.size.width*0.1, 0, width, width)];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = width/2;
        imageView.image = model.native.adIcon;
        
        UITapGestureRecognizer *singleTapAndOpenLandingPage = [[UITapGestureRecognizer alloc] initWithTarget:model.native action:@selector(reportAdClickAndOpenLandingPage)];
        cell.iconImageView.userInteractionEnabled = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTapAndOpenLandingPage];
        [cell.iconImageView addSubview:imageView];
        
        UIView* AdPrimaryViewOfCorrectWidth = [model.native primaryViewOfWidth:25];
        AdPrimaryViewOfCorrectWidth.frame = CGRectMake(0, 0, 1, 1);
        AdPrimaryViewOfCorrectWidth.clipsToBounds = YES;
        [AdPrimaryViewOfCorrectWidth setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:AdPrimaryViewOfCorrectWidth];
        
        cell.nameLabel.text = model.native.adTitle;
    }else{
        [cell.iconImageView removeAllSubviews];
        cell.iconImageView.userInteractionEnabled = NO;
        cell.iconImageView.image = [UIImage imageNamed:model.imageName];
        cell.nameLabel.text = model.titleName;
    }
    
    return cell;
}


//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePageItemModel *model = self.itemsArray[indexPath.item];
    if (model.native) {
        return;
    }
    if ([model.segueIdentifier isEqualToString:@"ImarkAlbumViewController"]) {
        [self tryToPushSegue:model.segueIdentifier];
    }else{
        [self performSegueWithIdentifier:model.segueIdentifier sender:nil];
    }
}
-(void)tryToPushSegue:(NSString *)segueIdentifier{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        {
            __weak typeof(self) wkSelf = self;
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        DbLog(@"segueIdentifier:%@",segueIdentifier);
                        [wkSelf performSegueWithIdentifier:segueIdentifier sender:nil];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wkSelf alertNoPassageToPhotos];
                    });
                }
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self alertNoPassageToPhotos];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            [self performSegueWithIdentifier:segueIdentifier sender:nil];
        }
            break;
        default:
            break;
    }
}
- (IBAction)onStartClick:(UIButton *)sender {
    [self tryToPushSegue:@"ChoosePhotosVC"];
}

-(void)alertNoPassageToPhotos{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无权限读取相册！" message:@"请在设置中检查权限设置" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
    alert.tag = 10011;
    alert.delegate = self;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10011) {
        if (buttonIndex ==1) {
            [self openSetPage];
        }
    }
}

/**
 打开设置页
 */
-(void)openSetPage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}
-(void)automaticScroll{
    if (self.barnerAds.count < 2 ) return;
    CGPoint p = self.TopScrolView.contentOffset;
    NSInteger idx = p.x/SCREEN_W;
    if (idx<self.barnerAds.count-1) {
        p.x+=SCREEN_W;
    }else{
        p.x=0;
    }
    [self.TopScrolView setContentOffset:p animated:YES];
}


#pragma mark - IMNative Delegate

/*The native ad notifies its delegate that it is ready. Fetching publisher-specific ad asset content from native.adContent. The publisher will specify the format. If the publisher does not provide a format, no ad will be loaded.*/
-(void)nativeDidFinishLoading:(IMNative*)native{
    if (native == self.InMobiNativeAdIcon1) {
        HomePageItemModel *exModel =self.itemsArray[2];
        if (exModel.native) {
            [self.itemsArray removeObject:exModel];
        }
        HomePageItemModel *itm = [[HomePageItemModel alloc]init];
        itm.native = native;
        [self.itemsArray insertObject:itm atIndex:2];
//        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]]];
        [self.collectionView reloadData];
    }else{
        HomePageBarnerAdModel *model = [[HomePageBarnerAdModel alloc]init];
        model.native = native;
        [self.barnerAds addObject:model];
        [self refreshHomeADs];
    }
}
/*The native ad notifies its delegate that an error has been encountered while trying to load the ad.Check IMRequestStatus.h for all possible errors.Try loading the ad again, later.*/
-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error{
    NSLog(@"Native Ad load Failed");
}
/* Indicates that the native ad is going to present a screen. */ -(void)nativeWillPresentScreen:(IMNative*)native{
    NSLog(@"Native Ad will present screen"); //Full Screen experience
}
/* Indicates that the native ad has presented a screen. */
-(void)nativeDidPresentScreen:(IMNative*)native{
    NSLog(@"Native Ad did present screen"); //Full Screen experience
}
/* Indicates that the native ad is going to dismiss the presented screen. */
-(void)nativeWillDismissScreen:(IMNative*)native{
    NSLog(@"Native Ad will dismiss screen"); //Full Screen experience
}
/* Indicates that the native ad has dismissed the presented screen. */
-(void)nativeDidDismissScreen:(IMNative*)native{
    NSLog(@"Native Ad did dismiss screen"); //Full Screen experience
}
/* Indicates that the user will leave the app. */
-(void)userWillLeaveApplicationFromNative:(IMNative*)native{
    NSLog(@"User leave"); //CTA External
}

-(void)native:(IMNative *)native didInteractWithParams:(NSDictionary *)params{
    NSLog(@"User clicked the ad"); // Click Counting
//    [self.barnerAds enumerateObjectsUsingBlock:^(HomePageBarnerAdModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.native == native) {
//            [self.barnerAds removeObject:obj];
//            [self refreshHomeADs];
//            *stop = YES;
//            if (self.barnerAds.count ==0) {
//                
//            }
//        }
//    }];
    [self loadAds];
}

-(void)nativeAdImpressed:(IMNative *)native{
    NSLog(@"Impression was counted"); // Impression Counting
}

-(void)native:(IMNative *)native rewardActionCompletedWithRewards:(NSDictionary *)rewards{
    NSLog(@"User can be rewarded"); //Rewarded
}
/**
 * Notifies the delegate that the native ad has finished playing media.
 */
-(void)nativeDidFinishPlayingMedia:(IMNative*)native{
    NSLog(@"The Video has finished playing");
    //PreRoll Use Case
}


@end
