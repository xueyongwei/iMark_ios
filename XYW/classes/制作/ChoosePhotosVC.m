//
//  ChoosePhotosVC.m
//  XYW
//
//  Created by xueyongwei on 16/3/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ChoosePhotosVC.h"
#import "XassetModel.h"
#import "PhotosCell.h"
#import "EditerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LLImageHandler.h"
#import "ReviewPhotosViewController.h"
#import "UIImage+Color.h"

#import "UserDefaultsManager.h"
#import <InMobiSDK/InMobiSDK.h>
#import "AppDelegate.h"

@interface ChoosePhotosVC()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ReviewPhotosViewControllerDelegate,PhotosCellDelegate,IMInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photosClView;
@property (nonatomic,strong)UILabel *noPicsSelectedLabel;
@property (nonatomic, strong) NSArray <PHAssetCollection *>*assetCollections;
@property (nonatomic, strong) NSMutableArray <PHAsset *>*selectePHAssets;
@property (nonatomic, strong) NSMutableArray <PHAsset *>*phAssetsArray;
@property (nonatomic,strong) LLImageHandler *imageHandler;
@property (nonatomic,strong) PHAssetCollection *currentAssetCollection;
@property (nonatomic,strong) PHAssetCollection *allPhotosCollection;
@property (nonatomic,strong) IMInterstitial *rewardAD;
@end

@implementation ChoosePhotosVC
-(UILabel *)noPicsSelectedLabel
{
    if (!_noPicsSelectedLabel) {
        _noPicsSelectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 21)];
        _noPicsSelectedLabel.textColor = [UIColor darkGrayColor];
        _noPicsSelectedLabel.text = @"客官，至少选一张嘛～";
    }
    return _noPicsSelectedLabel;
}

/**
 设置当前的相册

 @param currentAssetCollection 相册
 */
-(void)setCurrentAssetCollection:(PHAssetCollection *)currentAssetCollection
{
    if (_currentAssetCollection == currentAssetCollection) {
        return;
    }
    _currentAssetCollection = currentAssetCollection;
    __weak typeof(self)wkSelf = self;
    [self.imageHandler enumerateAssetsInAssetCollection:currentAssetCollection finishBlock:^(NSArray<PHAsset *> *result) {
        wkSelf.phAssetsArray = [NSMutableArray arrayWithArray:result];
        [wkSelf.photosClView reloadData];
    }];
}

#pragma mark ---🎬视图控制器
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexColorString:@"e84f3c"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initArray];
    self.rewardAD = [[IMInterstitial alloc]initWithPlacementId:1501406764036 delegate:self];
    
    [MobClick event:@"selectPhoto"];
    
    [self customBackNaviBarBtn];
    [self customPhotosClView];
    [self customTableView];
    
    __weak typeof(self)wkSelf = self;
    self.imageHandler = [[LLImageHandler alloc]init];
    [self.imageHandler enumeratePHAssetCollectionsWithSmartAlbumUserLibrary:^(PHAssetCollection *collection) {
        [CoreSVP dismiss];
        wkSelf.currentAssetCollection = collection;
         wkSelf.allPhotosCollection = collection;
    } finishResultHandler:^(NSArray<PHAssetCollection *> *result) {
        wkSelf.assetCollections = [NSArray arrayWithArray:result];
    }];

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    DbLog(@"dealoc");
}
-(void)initArray{
    self.selectePHAssets = [[NSMutableArray alloc]init];
    self.phAssetsArray = [[NSMutableArray alloc]init];
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

#pragma mark ---相册视图相关
-(void)customPhotosClView
{
    [self.photosClView registerNib:[UINib nibWithNibName:@"PhotosCell" bundle:nil] forCellWithReuseIdentifier:@"PhotosCellID"];
    self.photosClView.delegate = self;
    self.photosClView.dataSource = self;
    self.photosClView.allowsMultipleSelection = YES;
    self.photosClView.multipleTouchEnabled = YES;
    self.photosClView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
}
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
    static NSString * CellIdentifier = @"PhotosCellID";
    PhotosCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    PHAsset *asset = self.phAssetsArray[indexPath.item];
    cell.asset = asset;
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.phAssetsArray[indexPath.item];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.selectePHAssets containsObject:asset]) {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    });
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-20)/3-1, (SCREEN_W-20)/3-1);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5,5);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.phAssetsArray[indexPath.item];
    DbLog(@"选中了%@",asset);
        [self.selectePHAssets insertObject:asset atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.phAssetsArray[indexPath.item];
    DbLog(@"取消选中了%@",asset);
    NSUInteger index = [self.selectePHAssets indexOfObject:asset];
    [self.selectePHAssets removeObject:asset];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    
//    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self gotoReviewVCFromeIndexPath:indexPath];
    return NO;
    
//    if (self.selectePHAssets.count==5) {
//        CoreSVPCenterMsg(@"最多选5张！");
//        return NO;
//    }
//    return YES;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self gotoReviewVCFromeIndexPath:indexPath];
    return NO;
//    return YES;
}
-(void)gotoReviewVCFromeIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ReviewPhotosViewController" sender:indexPath];
}
#pragma mark --👍点击了切换
- (IBAction)changeAlbem:(UIButton *)sender {

    CGPoint point = CGPointMake(0.5, 0.0);
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (PHAssetCollection *collection in self.assetCollections) {
        [arr addObject:collection.localizedTitle];
    }
    __weak typeof(self) wkSelf = self;
    [PopViewLikeQQView configCustomPopViewWithFrame:CGRectMake(SCREEN_W/4, 54, SCREEN_W/2, SCREEN_H/2) imagesArr:nil dataSourceArr:arr anchorPoint:point seletedRowForIndex:^(NSInteger index) {
        DbLog(@"%@", arr[index]);
        PHAssetCollection *currentCollection = self.assetCollections[index];
        wkSelf.currentAssetCollection = currentCollection;
        [sender setTitle:[NSString stringWithFormat:@"%@▽",arr[index]] forState:UIControlStateNormal];
    } animation:YES timeForCome:0.3 timeForGo:0.3];
}
#pragma mark ---👍点击了摄像头
- (IBAction)onCamaraClick:(UIButton *)sender {
    if (![self checkCamara]) {
        return;
    }
    if (![self canGoonSelecteAsset]) {
        return;
    }
    UIImagePickerController * imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagepicker.allowsEditing = NO;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else
    {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        DbLog(@"保存成功，刷新");
        [self reloadAlbumAndSelectedNewst];
    }
}
-(void)reloadAlbumAndSelectedNewst{
    __weak typeof(self) wkSelf = self;
    if (self.currentAssetCollection.assetCollectionSubtype ==PHAssetCollectionSubtypeSmartAlbumUserLibrary || wkSelf.currentAssetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
        [self.imageHandler enumerateAssetsInAssetCollection:_currentAssetCollection finishBlock:^(NSArray<PHAsset *> *result) {
            PHAsset *newstAsset = result.firstObject;
            [wkSelf.selectePHAssets insertObject:newstAsset atIndex:0];
            
            
            [wkSelf.phAssetsArray insertObject:newstAsset atIndex:0];
//            [wkSelf.photosClView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0 ]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wkSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
//                [wkSelf.photosClView reloadData];
                [wkSelf.photosClView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
//                [wkSelf.photosClView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            });
            
            //
        }];
    }else{
        [self.imageHandler enumerateAssetsInAssetCollection:wkSelf.allPhotosCollection finishBlock:^(NSArray<PHAsset *> *result) {
            //把最新的插入到已选择
            PHAsset *newstAsset = result.firstObject;
            [wkSelf.selectePHAssets insertObject:newstAsset atIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wkSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            });
        }];
    }
}
//imagePickerController回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], self, @selector(image:didFinishSavingWithError:contextInfo:), @"卖个萌");
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --👮相机和相册的权限检查
//检查相机
-(BOOL)checkCamara
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //        CoreSVPError(@"请前往系统设置->爱水印->照片，允许权限。");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"访问相机失败！" message:@"可能您的设备不支持相机！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"访问相机失败！" message:@"爱水印没有权限使用相机！请前往系统设置开启相机权限。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往设置",nil];
        alertView.delegate =self;
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark -- alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 666) {//解锁批量
        if (buttonIndex == 1) {
            CoreSVPLoading(@"loading..", NO);
            [self.rewardAD load];
        }
    }
}

#pragma mark --底部已选图片tableView相关
-(void)customTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 85, SCREEN_W) style:UITableViewStylePlain];
    [self.tableView setRowHeight:75];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.transform = CGAffineTransformRotate(self.tableView.transform, -M_PI/2);
    self.tableView.center = CGPointMake(SCREEN_W/2, SCREEN_H-40);
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}  
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectePHAssets.count == 0) {
        self.noPicsSelectedLabel.center = CGPointMake(CGRectGetMidX(self.tableView.frame), CGRectGetMidY(self.tableView.frame));
        [self.view addSubview:self.noPicsSelectedLabel];
    }else{
        [self.noPicsSelectedLabel removeFromSuperview];
    }
    return self.selectePHAssets.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectedPhotoCellID"];
    if (!cell) {
        cell = (SelectedPhotoCell*)[[[NSBundle mainBundle]loadNibNamed:@"SelectedPhotoCell" owner:self options:nil] lastObject] ;
        cell.transform = CGAffineTransformRotate(cell.transform, M_PI/2);
    }
    PHAsset *asset = self.selectePHAssets[indexPath.row];
    cell.asset = asset;
//    [asset thumbnail:^(UIImage *result, NSDictionary *info) {
//        cell.img = result;
//    }];
//    cell.delBtn.tag = indexPath.row;
//    [cell.delBtn addTarget:self action:@selector(delSeleted:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/**
 删除选中的
 
 @param sender 按钮
 */
- (IBAction)onDeleteChosen:(UIButton *)sender {
    SelectedPhotoCell *cell = (SelectedPhotoCell *)sender.superview.superview;
    
    PHAsset *asset = cell.asset;
    DbLog(@"asset = %@",asset);
    NSUInteger index = [self.phAssetsArray indexOfObject:asset];
    if (index != NSNotFound) {//还在当前集合中
        [self.photosClView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES];
    }
    
    NSUInteger selectedIndex = [self.selectePHAssets indexOfObject:asset];
    [self.selectePHAssets removeObject:asset];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark -- 点击选中按钮
-(void)selectedCell:(UICollectionViewCell *)photosCell
{
    PhotosCell *cell = (PhotosCell *)photosCell;
    NSInteger index = [self.phAssetsArray indexOfObject:cell.asset];
    if ([self.selectePHAssets containsObject:cell.asset]) {
        [self deSelectedPhassetAtIndex:index];
    }else{
        if ([self canGoonSelecteAsset]) {
            [self selectedPhassetAtIndex:index];
        }
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
//- (IBAction)onSelectClick:(UIButton *)sender {
//    
//    PhotosCell *cell = (PhotosCell *)sender.superview.superview;
//    NSInteger index = [self.phAssetsArray indexOfObject:cell.asset];
//    if ([self.selectePHAssets containsObject:cell.asset]) {
//        [self deSelectedPhassetAtIndex:index];
////        NSInteger selectedIndex = [self.selectePHAssets indexOfObject:cell.asset];
////        [self.selectePHAssets removeObject:cell.asset];
////        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
////        [self.photosClView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES];
//    }else{
//        if (self.selectePHAssets.count==5) {
//            UIAlertView *alv = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"解锁更多批量", nil) message:NSLocalizedString(@"观看视频广告，即可获得9张批量权限", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:LocalStr(@"开始"), nil];
//            alv.tag = 666;
//            [alv show];
////            CoreSVPCenterMsg(@"最多选5张！");
//            return;
//        }
//        [self selectedPhassetAtIndex:index];
////        [self.selectePHAssets insertObject:cell.asset atIndex:0];
////        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
////        [self.photosClView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//    }
//    
//}

#pragma mark -ReviewPhotosViewControllerDelegate
-(void)selectedPhassetAtIndex:(NSInteger)index
{
    [self.selectePHAssets insertObject:self.phAssetsArray[index] atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self.photosClView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
}
-(void)deSelectedPhassetAtIndex:(NSInteger)index
{
    NSInteger selectedIndex = [self.selectePHAssets indexOfObject:self.phAssetsArray[index]];
    if (selectedIndex == NSNotFound) {
        return;
    }
    [self.selectePHAssets removeObjectAtIndex:selectedIndex];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self.photosClView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO ];
}
//-(void)delSeleted:(UIButton *)sender
//{
//    SelectedPhotoCell *cell = (SelectedPhotoCell *)sender.superview.superview;
//    
//    PHAsset *asset = cell.asset;
//    DbLog(@"asset = %@",asset);
//    
////    SelectedPhotoCell *cell = [self.tableView]
////    [self.selecteAssetCollections removeObjectAtIndex:sender.tag];
////    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
////    //取出这个model，
////    PHAsset *asset = self.selecteAssetCollections[sender.tag];
////    NSUInteger index = [self.phAssetsArray indexOfObject:asset];
////    [self.photosClView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//}

#pragma mark --segue相关
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditerViewController"]) {
        EditerViewController *edv = segue.destinationViewController;
        edv.assetArray = self.selectePHAssets;
    }else if ([segue.identifier isEqualToString:@"ReviewPhotosViewController"]){//预览
        ReviewPhotosViewController *reVC = segue.destinationViewController;
        reVC.selectePHAssets = self.selectePHAssets;
        reVC.phAssetsArray  = self.phAssetsArray;
        reVC.currentAssetIndex = ((NSIndexPath *)sender).item;
        reVC.delegate = self;
        DbLog(@"%ld",(long)reVC.currentAssetIndex);
    }
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (self.selectePHAssets.count<1) {
        CoreSVPCenterMsg(@"客官，至少选择一张嘛～");
        return NO;
    }
    return YES;
}

#pragma mark -- 别走开，广告更精彩

- (void)showVideo
{
    
    [self.rewardAD showFromViewController:self withAnimation:kIMInterstitialAnimationTypeCoverVertical];
    ((AppDelegate *) [UIApplication sharedApplication].delegate).canShowADInWiondw = NO;
//    if ([self.rewardAD isReady]) {
//        [self.rewardAD showFromViewController:self withAnimation:kIMInterstitialAnimationTypeCoverVertical];
//    }else{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self showVideo];
//        });
//    }
}

#pragma mark --imbobi delegate
- (void)interstitialDidFinishLoading:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Did Finish Loading");
    [CoreSVP dismiss];
    [self showVideo];
    //    [self.rewardAD showFromViewController:self withAnimation:kIMInterstitialAnimationTypeCoverVertical];
}
- (void)interstitial:(IMInterstitial *)rewardedAd didFailToLoadWithError:(IMRequestStatus *)error{
    DbLog(@"Rewarded Ad Failed to load with error: %@",error.description);
    [CoreSVP dismiss];
    CoreSVPCenterMsg(@"广告拉取失败，稍后再试");
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
    ((AppDelegate *) [UIApplication sharedApplication].delegate).canShowADInWiondw = YES;
}

- (void)interstitialDidPresent:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Did Present");
}
- (void)interstitialWillDismiss:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Will Dismiss");
}
- (void)interstitialWillPresent:(IMInterstitial *)rewardedAd {
    DbLog(@"Rewarded Ad Will Present");
}


@end
