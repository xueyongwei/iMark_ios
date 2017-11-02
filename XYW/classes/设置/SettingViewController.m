//
//  SettingViewController.m
//  XYW
//
//  Created by xueyongwei on 16/4/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "SettingViewController.h"
#import "PicQualityViewController.h"
#import "FedBackViewController.h"
#import "UserDefaultsManager.h"
#import "SandBoxManager.h"
#import "HYFileManager.h"
#import "UIImage+Color.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *picQualityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoSaveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *remberLastModelSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *clearLocalActivityView;
@property (weak, nonatomic) IBOutlet UIImageView *clearLocalRight;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    PicQuality quality = [UserDefaultsManager CurrentPicQuality];
    if (quality == PicQualityHeight) {
        self.picQualityLabel.text = @"普通";
    }else if (quality == PicQualityOriginal){
        self.picQualityLabel.text = @"高清";
    }else{
        self.picQualityLabel.text = @"一般";
    }
    //自动保存到相册
    BOOL isAutoSave = [UserDefaultsManager isAutoSaveImage];
    self.autoSaveSwitch.on = isAutoSave;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackNaviBarBtn];
    // Do any additional setup after loading the view.
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePicAutoChanged:(UISwitch *)sender {
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    if (sender.isOn) {//
        [usf setObject:@1 forKey:@"autosave"];
    }else{
        [usf setObject:@0 forKey:@"autosave"];
    }
    [usf synchronize];
}
- (IBAction)remberLastModelChanged:(UISwitch *)sender {
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    if (sender.isOn) {//
        [usf setObject:@1 forKey:@"rember"];
    }else{
        [usf setObject:@0 forKey:@"rember"];
    }
    [usf synchronize];
}

- (IBAction)onClearLocalWater:(UIButton *)sender {
    self.clearLocalRight.hidden = YES;
    [self.clearLocalActivityView startAnimating];
    CoreSVPLoading(@"正在清理...", YES);
    
    [HYFileManager removeItemAtPath:[SandBoxManager localXviewDir] error:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CoreSVP dismiss];
        [self.clearLocalActivityView stopAnimating];
        self.clearLocalRight.hidden = NO;
        CoreSVPCenterMsg(@"清理成功！");
    });
    
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
