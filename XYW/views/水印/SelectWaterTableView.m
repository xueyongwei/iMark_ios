//
//  SelectWaterTableView.m
//  XYW
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SelectWaterTableView.h"
#import "XwaterView.h"
#import "SandBoxManager.h"
#import "XlocalView.h"
#import "HYFileManager.h"
#import "UIImage+FixOrientation.h"
////////////////////////
@implementation localWaterModel
@end
////////////////////////
@interface SelectWaterTableView()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *PathModels;
@property (nonatomic,strong)NSMutableArray *localXviews;
@end
@implementation SelectWaterTableView
{
    NSInteger currentItem;
}
-(NSMutableArray *)localXviews
{
    if (!_localXviews) {
        _localXviews = [NSMutableArray new];
    }
    return _localXviews;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)PathModels
{
    if (!_PathModels) {
        _PathModels = [[NSMutableArray alloc]init];
        NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
        NSArray *arr = [usf objectForKey:@"pathModels"];
        if (!arr) {
            return nil;
        }
        for (NSData *data in arr) {
            PathModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_PathModels addObject:model];
        }
    }
    return _PathModels;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initOpera];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initOpera];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initOpera];
    }
    return self;
}
-(void)initOpera
{
    //在并发子线程里获取pathmodel数组
//    dispatch_async(dispatch_queue_create("xyw.queue.concurrent", DISPATCH_QUEUE_CONCURRENT), ^{
       [self reloadDataSourceType:1];
//    });
    [self loadLocalXviews];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[WaterCollectionViewCell class] forCellWithReuseIdentifier:@"WaterCollectionViewCell"];
    [self.collection registerClass:[ShangChengCollectionViewCell class] forCellWithReuseIdentifier:@"ShangChengCollectionViewCell"];
    [self customWaterItemVIew];
    currentItem = 1;
}

#pragma mark ---🔌本地数据有更新则刷新本界面
-(void)refreshData
{
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [usf objectForKey:@"pathModels"];
    if (!arr) {
        return;
    }
    [self.PathModels removeAllObjects];
    for (NSData *data in arr) {
        PathModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        DbLog(@"%@",model.path);
        [self.PathModels addObject:model];
    }
    [self reloadDataSourceType:currentItem];
}
-(void)reloadDataSourceType:(NSInteger)type
{
    currentItem = type;
    //在这里根据tag选出该种类的模板，然后让DS指向这个新的数组
    [self.dataSource removeAllObjects];
    if (type==0) {//加载本地的图片模版
        
    }else{
        for (PathModel *model in self.PathModels) {
            DbLog(@"%d",model.type);
            if (model.type == type) {
                [self.dataSource addObject:model];
            }
        }
    }
    
    [self.collection reloadData];
}
-(void)onGotoShangcheng:(UIButton *)sender
{
    ShangChengViewController *shangVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShangChengViewController"];
    DbLog(@"%@",shangVC);
    [self.vc.navigationController pushViewController:shangVC animated:YES];
}
#pragma mark -- collectionView代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DbLog(@"dataSource = %lu",(unsigned long)self.dataSource.count);
    if (currentItem == 0) {
        return self.localXviews.count+1;
    }else{
        return self.dataSource.count+1;
    }
    //    if (self.dataSource.count>0) {
    
    //    }
    //    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        ShangChengCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShangChengCollectionViewCell" forIndexPath:indexPath];
        if (currentItem == 0) {
            cell.imageView.image = [UIImage imageNamed:@"添加更多"];
        }else{//不是本地存储的分类下的第一个是跳转到商城的btn
            cell.imageView.image = [UIImage imageNamed:@"商店添加"];
        }
        return cell;
    }
    
    WaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaterCollectionViewCell" forIndexPath:indexPath];
    if (currentItem==0) {
        localWaterModel *lwModel = self.localXviews[indexPath.item-1];
        cell.bgImgView.image = lwModel.thumbImage;
        cell.imgView.image = nil;
//        NSString *imageName = self.localXviews[indexPath.item-1];
//        NSString *thmImgPath = [[SandBoxManager localXviewDir] stringByAppendingPathComponent:imageName];
//        cell.imgView.image = [UIImage imageWithContentsOfFile:thmImgPath];
//        cell.bgImgView.image = self.thumbnail;
    }else{
        PathModel *model = self.dataSource[indexPath.item-1];
        NSString *thmImgPath = [NSString stringWithFormat:@"%@/%@/thumb/small.png",[SandBoxManager tepmlateDir],model.path];
        cell.imgView.image = [UIImage imageWithContentsOfFile:thmImgPath];
        cell.bgImgView.image = self.thumbnail;
    }
    
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DbLog(@"点击了第%ld行",(long)indexPath.item);
    DbLog(@"currentItem = %ld index[ath.item = %ld",(long)currentItem,(long)indexPath.item);
    if (indexPath.item== 0) {
        if (currentItem==0) {
            // 1.判断相册是否可以打开
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
            // 2. 创建图片选择控制器
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            /**
             typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
             UIImagePickerControllerSourceTypePhotoLibrary, // 相册
             UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
             UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
             }
             */
            // 3. 设置打开照片相册类型(显示所有相簿)
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            // 照相机
            // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 4.设置代理
            ipc.delegate = self;
            // 5.modal出这个控制器
            [[self getCurrentVC]presentViewController:ipc animated:YES completion:nil];
        }else{
            [self onGotoShangcheng:nil];
        }
        return;
    }
    if (currentItem ==0) {
        //插入到操作台
        localWaterModel *lwModel = self.localXviews[indexPath.item-1];
        NSString *imageName = lwModel.imgName;
        __weak typeof(self) wkSelf = self;
        Xview *aXview = [[[XlocalView alloc]init] returnWordView:imageName onSuperView:self.ev.bgView tapBlock:^(Xview *Xview) {
            DbLog(@"点击了 %@",Xview);
            wkSelf.ev.currentWaterView = Xview;
        }];
        self.ev.currentWaterView = aXview;
    }else{
        PathModel *model = self.dataSource[indexPath.item-1];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@/des",[SandBoxManager tepmlateDir],model.path];
        DbLog(@"%@",filePath);
        
        NSString *str =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self Resover:str path:[[SandBoxManager tepmlateDir] stringByAppendingPathComponent:model.path]];
    }
    
}
#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    CoreSVPLoading(@"loading..", YES);
    [picker dismissViewControllerAnimated:YES completion:^{
        //将image写入沙盒文件夹
        
        UIImage *selectedImage = [info[UIImagePickerControllerOriginalImage] fixOrientation];
        NSString *localDir = [SandBoxManager localXviewDir];
        if (![[NSFileManager defaultManager] fileExistsAtPath:localDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localDir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        NSString *imageName = [NSString stringWithFormat:@"%ld.png",self.localXviews.count+1];
        
        NSString *imgPath = [localDir stringByAppendingPathComponent:imageName];
        if([UIImagePNGRepresentation(selectedImage) writeToFile:imgPath atomically:YES]){
            DbLog(@"图片存储成功");
        }
        //插入到操作台
        __weak typeof(self) wkSelf = self;
        Xview *aXview = [[[XlocalView alloc]init] returnWordView:imageName onSuperView:self.ev.bgView tapBlock:^(Xview *Xview) {
            DbLog(@"点击了 %@",Xview);
            wkSelf.ev.currentWaterView = Xview;
            
        }];
        self.ev.currentWaterView = aXview;
        
        //刷新本地水印列表
        [self loadLocalXviews];
        [CoreSVP dismiss];
    }];
    
}

/**
 加载本地导入的图片水印
 */
-(void)loadLocalXviews{
    NSArray *imageNames = [HYFileManager listFilesInDirectoryAtPath:[SandBoxManager localXviewDir] deep:NO];
    [self.localXviews removeAllObjects];
    for (NSInteger i=imageNames.count-1; i>=0; i--) {
        NSString *imgName = imageNames[i];
        
        localWaterModel *model = [[localWaterModel alloc]init];
        model.imgName = imgName;
        [self.localXviews addObject:model];
        NSString *thmImgPath = [[SandBoxManager localXviewDir] stringByAppendingPathComponent:imgName];
        UIImage *localThumb = [[UIImage imageWithContentsOfFile:thmImgPath] imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
        model.thumbImage = localThumb;
    }
    [self.collection reloadData];
}
//解析
-(void)Resover:(NSString *)str path:(NSString *)path
{
    Xview *wv = [[[XwaterView alloc]init]returnWaterView:str path:path onSuperView:self.ev.bgView tapBlock:^(Xview *Xview) {
        DbLog(@"点击了 %@",Xview);
        self.ev.currentWaterView = Xview;
    }];
    self.ev.currentWaterView = wv;
    
}

-(void)customWaterItemVIew
{
    DbLog(@"加载下方的view %@ %@",self.XtableView,self.collection);
    [self.XtableView XhorTbaleViewDidSelectedWIthBlock:^(NSInteger index) {
        DbLog(@"点击了第%ld个cell",(long)index);
        [MobClick event:@"selectWater"];
        [self reloadDataSourceType:index];
    }];
}
-(void)reloadCollection
{
    [self.collection reloadData];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
