//
//  ShangChengViewController.m
//  XYW
//
//  Created by xueyongwei on 16/3/25.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ShangChengViewController.h"
#import "SCDldCollectionViewCell.h"
#import "SCdlModel.h"
#import "HadDldTableViewCell.h"
#import "PathModel.h"
#import "waterModel.h"
#import <SSZipArchive.h>
#import "XYWAlert.h"
#import "UserDefaultsManager.h"
#import "SandBoxManager.h"
#import "XYWVersonManager.h"
#import "UIImage+Color.h"
@interface ShangChengViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,SCDldCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSouce;
@property (nonatomic,strong)NSMutableArray *allMubanArr;
@property (nonatomic,strong)NSMutableArray *hadDldArr;
@property (nonatomic,strong)NSArray *hadDldInLocalIDsArray;
@property (weak, nonatomic) IBOutlet UIButton *DetaultBtn;
@property (nonatomic,strong)UITableView *tableView ;
@property (nonatomic,assign)BOOL haveInstallZuoYou;
@end

@implementation ShangChengViewController
{
    UIButton *currentBtn;
}

-(NSMutableArray *)hadDldArr
{
    if (!_hadDldArr) {
        _hadDldArr = [[NSMutableArray alloc]init];
    }
    return _hadDldArr;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.collectionView.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choosePhotobg"]];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
-(NSMutableArray *)allMubanArr
{
    if (!_allMubanArr) {
        _allMubanArr = [[NSMutableArray alloc]init];
    }
    return _allMubanArr;
}
-(NSMutableArray *)dataSouce
{
    if (!_dataSouce) {
        _dataSouce = [[NSMutableArray alloc]init];
    }
    
    return _dataSouce;
}

-(void)becomeActive{
    self.haveInstallZuoYou = [self canOpenZuoYou];
    [self.collectionView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self updataLocalDownloadedModelIDs];
    [CoreSVP dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"shangcheng"];
    [self customBackNaviBarBtn];
    [self prepareHadDld];
    [self prepareData];
    
    currentBtn = self.DetaultBtn;
    self.haveInstallZuoYou = [self canOpenZuoYou];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCDldCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SCDldCollectionViewCell"];
    //    dispatch_async(dispatch_queue_create("pub_xyw_preparedata", DISPATCH_QUEUE_CONCURRENT), ^{
    
    //    });
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}
-(BOOL)canOpenZuoYou{
    return  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"zuoyoupk://"]];
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
#pragma mark -- collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSouce.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SCDldCollectionViewCell";
    SCDldCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    SCdlModel *model = self.dataSouce[indexPath.item];
    cell.model = model;
//    if ([self.hadDldIDs containsObject:model.Dlid]) {
//        [cell.dldBtn setTitle:@"卸载" forState:UIControlStateNormal];
//        [cell.dldBtn setBackgroundColor:[UIColor darkGrayColor]];
//    }else{
//        [cell.dldBtn setTitle:@"下载" forState:UIControlStateNormal];
//        [cell.dldBtn setBackgroundColor:[UIColor redColor]];
//    }
    cell.dldBtn.tag = indexPath.item+100;
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-30)/2-1, (SCREEN_W-30)/2+10);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10,10);
}


#pragma mark --请求所有的模版数据
-(void)prepareHadDld
{
    CGFloat lastVersion = [XYWVersonManager lastVersionInter];
    if (lastVersion>0 && lastVersion<200) {
        NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[usf objectForKey:@"dlwnloadArr"]];
        if (arr) {
            NSMutableArray *earlyIds = [[NSMutableArray alloc]init];
            for (NSData *data in arr) {
                SCdlModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [earlyIds addObject:model.Dlid];
            }
            self.hadDldInLocalIDsArray = [[NSArray alloc]initWithArray:earlyIds];
            [UserDefaultsManager setDowmloadTemplateModelIDs:earlyIds];
        }
    }else{
        NSArray *downloadIDs = [UserDefaultsManager dowmloadTemplateModelIDs];
        self.hadDldInLocalIDsArray = [[NSArray alloc]initWithArray:downloadIDs];
    }
}

-(void)prepareData
{
    CoreSVPLoading(@"加载中", YES);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 5.0;
    
    [manager POST:@"http://markapi.eoews.com/mark/index?start=0&cid=0" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [CoreSVP dismiss];
        DbLog(@"%@",responseObject);
        NSDictionary *rspDic = responseObject;
        NSArray *dataArray = rspDic[@"dataArray"];
        
        for (NSDictionary *dic in dataArray) {
            SCdlModel *model =[[SCdlModel alloc]init];
            model.category = [self strWith:dic[@"category"]];
            model.downloadUrl = [self strWith:dic[@"downloadUrl"]];
            model.iconUrl = [self strWith:dic[@"iconUrl"]];
            model.Dlid = [self strWith:dic[@"id"]];
            model.name = [self strWith:dic[@"name"]];
            model.Tp = [self strWith:dic[@"newTp"]];
            model.size = [self strWith:dic[@"size"]];
            if ([self.hadDldInLocalIDsArray containsObject:model.Dlid]) {
                model.haveDownloaded = YES;
                [self.hadDldArr addObject:model];
            }
            [self.allMubanArr addObject:model];
        }
        [self loadCatagory:1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CoreSVP dismiss];
        DbLog(@"%@",error.localizedDescription);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCatagoryClick:(UIButton *)sender {
    currentBtn.selected = NO;
    if (self.tableView.superview) {
        [self.tableView removeFromSuperview];
    }
    [self.dataSouce removeAllObjects];
    [self loadCatagory:sender.tag-100];
    sender.selected = YES;
    currentBtn = sender;
}
-(void)loadCatagory:(NSInteger)index
{
    [self.dataSouce removeAllObjects];
    for (SCdlModel *model in self.allMubanArr) {
        if (model.category.integerValue == index) {
            [self.dataSouce addObject:model];
        }
    }
    [self.collectionView setContentOffset:CGPointZero];
    [self.collectionView reloadData];
}

- (IBAction)onHaveDld:(UIButton *)sender {
    currentBtn.selected = NO;
    self.tableView.frame = self.collectionView.frame;
    [self.view addSubview:self.tableView];
//    [self prepareHadDld];
    sender.selected = YES;
    currentBtn = sender;
    [self.tableView reloadData];
}


#pragma mark -- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hadDldArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HadDldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HadDldTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HadDldTableViewCell" owner:self options:nil]lastObject];
    }
    SCdlModel *model = self.hadDldArr[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    cell.nameLabel.text = model.name;
    cell.catagoryNaleLabel.text = [self getNameOfCatagory:model.category.integerValue];
    cell.delBtn.tag = indexPath.row + 100;
    [cell.delBtn addTarget:self action:@selector(onDelCLick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 已下载tableView的删除按钮

 @param sender 删除按钮
 */
-(void)onDelCLick:(UIButton *)sender
{
    
    //删除目录文件。
    SCdlModel *model = self.hadDldArr[sender.tag-100];
    [self deleteDlSCDlModel:model sender:nil];
    [self.tableView reloadData];
}


/**
 下载这个模版

 @param model 模版
 @param sender 点击的按钮
 */
-(void)downloadSCDlModel:(SCdlModel *)model{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.downloadUrl]];

    __weak typeof(self) wkSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        DbLog(@"%@",downloadProgress);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[wkSelf findCellWithModel:model].dldBtn setTitle:[NSString stringWithFormat:@"%.1f%%",downloadProgress.fractionCompleted*100] forState:UIControlStateNormal];
        });
        
    } destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[wkSelf findCellWithModel:model].dldBtn setTitle:@"重试" forState:UIControlStateNormal];
                CoreSVPCenterMsg(@"下载失败，稍后重试");
            });
            return ;
        }
        DbLog(@"downloaded to: %@", filePath);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[wkSelf findCellWithModel:model].dldBtn setTitle:@"卸载" forState:UIControlStateNormal];
            [wkSelf findCellWithModel:model].dldBtn.backgroundColor = [UIColor darkGrayColor];
        });
        
        //解压水印模版
        NSString *tepDir = [SandBoxManager tepmlateDir];
        NSString *desDir =[tepDir stringByAppendingPathComponent:model.name];
        [SSZipArchive unzipFileAtPath:filePath.path toDestination:desDir];
        model.localDirPath = desDir;
        
        //删除压缩包
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath.path error:nil];
        
        PathModel *pthModel = [[PathModel alloc]init];
        pthModel.path = model.name;
        //                model.path = [NSString stringWithFormat:@"%@/%@",path,dir];
        //取tag值是多少
        NSString *desFilePath =  [desDir stringByAppendingPathComponent:@"des"];
        NSString *str =[NSString stringWithContentsOfFile:desFilePath encoding:NSUTF8StringEncoding error:nil];
        //存储水印信息
        waterModel *wmodel = [waterModel mj_objectWithKeyValues:str];
        pthModel.type = wmodel.tag.intValue;
        NSArray *templates = [UserDefaultsManager templateModelsInstalled];
        NSMutableArray *newTemplates = [NSMutableArray arrayWithArray:templates];
        NSData *pthData = [NSKeyedArchiver archivedDataWithRootObject:pthModel];
        [newTemplates addObject:pthData];
        [UserDefaultsManager setTemplateModels:newTemplates];
        
        //更新已下载信息
        [self.hadDldArr addObject:model];
        model.haveDownloaded = YES;
        [self updataLocalDownloadedModelIDs];
    }];
    
    [downloadTask resume];
}
-(SCDldCollectionViewCell *)findCellWithModel:(SCdlModel *)model
{
    for (SCDldCollectionViewCell *cell in self.collectionView.visibleCells) {
        if (cell.model == model) {
            return cell;
        }
    }
    return nil;
}
/**
 把已下载数组保存到本地
 */
-(void)updataLocalDownloadedModelIDs
{
    NSMutableArray *idsStrArr = [[NSMutableArray alloc]init];
    for (SCdlModel *model in self.hadDldArr) {
        [idsStrArr addObject:model.Dlid];
    }
    [UserDefaultsManager setDowmloadTemplateModelIDs:idsStrArr];
}



/**
 删除已下载的模版

 @param model 模版
 @param sender 删除按钮
 */
-(void)deleteDlSCDlModel:(SCdlModel *)model sender:(UIButton *)sender{
    //刷新本地已下载列表缓存
    model.haveDownloaded = NO;
    [self.hadDldArr removeObject:model];
    [self updataLocalDownloadedModelIDs];
    //刷新本地水印记录
    __block NSMutableArray *pathsModels = [NSMutableArray arrayWithArray:[UserDefaultsManager templateModelsInstalled]];
    [pathsModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PathModel *pathModel = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        if ([pathModel.path isEqualToString:model.name]) {
            *stop = YES;
            if (stop) {
                [pathsModels removeObject:obj];
                [UserDefaultsManager setTemplateModels:pathsModels];
            }
        }
    }];
    //删除沙河里下载的文件
    NSString *desDir =[[SandBoxManager tepmlateDir] stringByAppendingPathComponent:model.name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:desDir]) {
        [fileManager removeItemAtPath:desDir error:nil];
    }
}

/**
 点击cell的下载按钮

 @param sender 按钮
 */
-(void)onCellDldBtnClick:(UIButton *)sender
{
    SCdlModel *model = self.dataSouce[sender.tag -100];
    if ([sender.titleLabel.text isEqualToString:@"下载"]) {
        [MobClick event:@"download"];
        DbLog(@"从%@下载模板",model.downloadUrl);
        [sender setTitle:@"0%" forState:UIControlStateNormal];
        [self downloadSCDlModel:model];
    }else if ([sender.titleLabel.text isEqualToString:@"卸载"]) {
        [sender setTitle:@"下载" forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor redColor];
        [self deleteDlSCDlModel:model sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"解锁"]) {
        [XYWAlert XYWAlertTitle:@"下载左右APP可永久解锁该贴纸" message:nil first:@"解锁" firstHandle:^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/zuo-you-pai-xiao-shi-pin-1dui1huo/id1144064169"]];
        } second:nil Secondhandle:nil cancle:@"取消" handle:nil];
    }
}

-(NSString *)getNameOfCatagory:(NSInteger)idx
{
    switch (idx) {
        case 1:
            return @"购物" ;
            break;
        case 2:
            return @"美食" ;
            break;
        case 3:
            return @"文艺" ;
            break;
        case 4:
            return @"旅游" ;
            break;
            
        default:
            break;
    }
    return nil;
}
-(NSString *)strWith:(id)ojb
{
    return [NSString stringWithFormat:@"%@",ojb];
}
@end
