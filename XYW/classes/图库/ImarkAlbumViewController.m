//
//  ImarkAlbumViewController.m
//  XYW
//
//  Created by xueyongwei on 16/4/19.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ImarkAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PhotosCell.h"
#import "XassetModel.h"
#import "UIImage+Color.h"
@interface ImarkAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray <PHAsset *> *SelectedArr;
@property (nonatomic,strong) NSMutableArray <PHAsset *> *photos;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,strong) PHAssetCollection *imarkCollection;
@property (nonatomic,strong) UIActivityViewController *activityViewController;
@end

@implementation ImarkAlbumViewController

-(NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc]init];
    }
    return _photos;
}
-(NSMutableArray *)SelectedArr
{
    if (!_SelectedArr) {
        _SelectedArr = [[NSMutableArray alloc]init];
    }
    return _SelectedArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackNaviBarBtn];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotosCell" bundle:nil] forCellWithReuseIdentifier:@"PhotosCellID"];
    [self requestAllImarkPhotos];
}
-(PHAssetCollection *)imarkCollection{
    if (!_imarkCollection) {
        PHFetchResult <PHAssetCollection *>*userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        for (PHAssetCollection *collection in userAlbums) {
            if ([collection.localizedTitle isEqualToString:@"爱水印"]) {
                DbLog(@"爱水印相册找到啦！%@",collection.description);
                _imarkCollection = collection;
            }
        }
    }
    return _imarkCollection;
}
-(void)requestAllImarkPhotos{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.wantsIncrementalChangeDetails = YES;
    options.includeAllBurstAssets = YES;
    options.includeHiddenAssets = YES;
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult <PHAsset *>*assets = [PHAsset fetchAssetsInAssetCollection:self.imarkCollection options:options];
    __weak typeof(self) wkSelf = self;
    [self.photos removeAllObjects];
    if (assets.count==0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wkSelf.collectionView reloadData];
        });
    }else{
        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.mediaType == PHAssetMediaTypeImage) {
                [wkSelf.photos addObject:obj];
            }
            if (obj==assets.lastObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wkSelf.collectionView reloadData];
                });
            }
        }];

    }
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PhotosCellID";
    PhotosCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.corverButton.userInteractionEnabled = NO;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PhotosCell" owner:self options:nil] lastObject ];
    }
    PHAsset *asset = self.photos[indexPath.item];
    cell.asset = asset;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-40)/3-1, (SCREEN_W-40)/3-1);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10,10);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.photos[indexPath.item];
    [self.SelectedArr addObject:asset];

}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.photos[indexPath.item];
    [self.SelectedArr removeObject:asset];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (IBAction)onShareCLick:(UIButton *)sender {
    if (self.SelectedArr.count<1) {
        CoreSVPCenterMsg(@"请至少选择一张图片");
        return;
    }
    CoreSVPLoading(@"loading...", YES);
    __block NSMutableArray *shareImages = [[NSMutableArray alloc]init];
    __weak typeof(self)wkSelf = self;
    [self.SelectedArr enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj original:^(UIImage *result, NSDictionary *info) {
            [shareImages addObject:result];
            if (obj==wkSelf.SelectedArr.lastObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wkSelf.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:shareImages applicationActivities:nil];
                    [wkSelf presentViewController:wkSelf.activityViewController
                                         animated:YES
                                       completion:^{
                                           [CoreSVP dismiss];
                                       }];
                });
            }
        }];
        
    }];

}
- (IBAction)onDelCLick:(UIButton *)sender {
    if (self.SelectedArr.count<1) {
        CoreSVPCenterMsg(@"请至少选择一张图片");
        return;
    }
    [self ios8Delete];
}


-(void)ios8Delete
{
    __weak typeof(self) wkSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:self.SelectedArr];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [self.SelectedArr removeAllObjects];
            CoreSVPCenterMsg(@"删除成功！");
            [wkSelf requestAllImarkPhotos];
        }else{
//            [self.SelectedArr removeAllObjects];
//            CoreSVPCenterMsg(@"未删除！");
        }
        DbLog(@"Error: %@", error);
    }];

}


@end
