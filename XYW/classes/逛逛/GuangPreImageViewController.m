//
//  GuangPreImageViewController.m
//  XYW
//
//  Created by xueyognwei on 2017/6/12.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "GuangPreImageViewController.h"
#import "GuangPreCollectionViewCell.h"
#import "AppDelegate.h"
@interface GuangPreImageViewController ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation GuangPreImageViewController
{
    NSInteger _repeatCount;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat const kLineSpacing = 20;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, kLineSpacing);
        layout.minimumLineSpacing = kLineSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W + kLineSpacing, SCREEN_H) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).canShowADInWiondw = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).canShowADInWiondw = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCollectionView];

    // Do any additional setup after loading the view from its nib.
}
-(void)customCollectionView{
    self.view.backgroundColor = [UIColor blackColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GuangPreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GuangPreCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
    //    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.currentImageIndex * self.collectionView.width, 0) animated:NO];
}

#pragma makr -- collectionView
-(void)reloadData{
    if (self.collectionView && self.guangModelsArray.count>0) {
        [self.collectionView reloadData];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.guangModelsArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GuangPreCollectionViewCell";
    
    GuangPreCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    DbLog(@"%@",indexPath);
    GuangModel *model = self.guangModelsArray[indexPath.item];
    cell.model = model;
    [self tryToShowAds];
    return cell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(detailVCDismissWithIndex:)]) {
        [self.delegate detailVCDismissWithIndex:_currentImageIndex];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

#pragma makr -- scrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentImageIndex = round(scrollView.contentOffset.x / scrollView.width);
    if ([self.delegate respondsToSelector:@selector(showImageOfIndex:)]) {
        [self.delegate showImageOfIndex:_currentImageIndex];
    }
    
}
#pragma makr -- 广告时间到
-(void)tryToShowAds{
    _repeatCount ++;
    if (_repeatCount ==10) {
        _repeatCount = 0;
        DbLog(@"看了10张，开始加载广告");
        [self showAd];
    }
}
-(void)showAd{
    DbLog(@"加载广告..");
}
#pragma mark - instl deleage


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
