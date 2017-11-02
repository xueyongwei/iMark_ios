//
//  ChoosePhotosVC.h
//  XYW
//
//  Created by xueyongwei on 16/3/14.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectedPhotoCell.h"
#import "PopViewLikeQQView.h"

@interface ChoosePhotosVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic)UITableView *tableView;

//@property (nonatomic,strong) NSMutableArray *assetModels;
//@property (nonatomic,strong) NSMutableArray *groups;
//@property (nonatomic,strong) NSMutableArray *SelectedArr;
//@property (nonatomic,strong)ALAssetsGroup *photoGroup;
//@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@end
