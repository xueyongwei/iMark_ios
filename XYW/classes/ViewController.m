//
//  ViewController.m
//  XYW
//
//  Created by xueyongwei on 16/3/3.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChoosePhotosVC.h"
#import "UIColor+Extend.h"
#import <UMengSocial/UMSocial.h>
#import "LLImageHandler.h"

@interface ViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//@property (nonatomic,strong)NSMutableArray *groups;
@end

@implementation ViewController
//-(NSMutableArray *)groups
//{
//    if (!_groups) {
//        _groups = [[NSMutableArray alloc]init];
//    }
//    return _groups;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    //导航条背景色
//    navBar.barTintColor = [UIColor colorWithHexColorString:@"e84f3c"];
//    //字体颜色
//    navBar.tintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.logoImageView.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.logoImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"PushChoosePhotosVC"] || [identifier isEqualToString:@"PushImarkAlbumViewController"]) {
        LLAuthorizationStatus status = [LLImageHandler requestAuthorization];
        switch (status) {
            case LLAuthorizationStatusNotDetermined:
            {
                DbLog(@"LLAuthorizationStatusNotDetermined");
                UIAlertView *alv = [[UIAlertView alloc]initWithTitle:@"请允许爱水印读取相册" message:@"爱水印需要获取相册，以继续下一步的编辑处理" delegate:self cancelButtonTitle:@"继续" otherButtonTitles: nil];
                alv.tag = 100;
                [alv show];
                return NO;
//                PHAssetCollectionChangeRequest *createCollectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"爱水印"];
//                [createCollectionRequest placeholderForCreatedAssetCollection];
            }
                break;
            case LLAuthorizationStatusRestricted:
            {
                DbLog(@"LLAuthorizationStatusRestricted");
                [self alertNoPassageToPhotos];
                return NO;
            }
            case LLAuthorizationStatusDenied:
            {
                DbLog(@"LLAuthorizationStatusDenied");
                [self alertNoPassageToPhotos];
                return NO;
            }
            case LLAuthorizationStatusAuthorized:
            {
                DbLog(@"LLAuthorizationStatusAuthorized");
                return YES;
            }
            default:
                break;
        }
    }
    return YES;
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
    }else if (alertView.tag ==100){
        [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    }
}

/**
 打开设置页
 */
-(void)openSetPage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@",[NSBundle mainBundle].bundleIdentifier]];
//    DbLog(@"%@",url);
//    if ([[UIApplication sharedApplication] canOpenURL:url])
//    {
//        [[UIApplication sharedApplication] openURL:url];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
