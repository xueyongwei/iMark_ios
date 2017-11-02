//
//  PicQualityViewController.m
//  XYW
//
//  Created by xueyongwei on 16/4/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "PicQualityViewController.h"
#import "UserDefaultsManager.h"
@interface PicQualityViewController ()
@end

@implementation PicQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackNaviBarBtn];
//    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
//    NSNumber *num = [usf objectForKey:@"picQuality"];
    PicQuality quality = [UserDefaultsManager CurrentPicQuality];
    UIImageView *imgv = [self.view viewWithTag:quality+101];
    imgv.hidden = NO;
//    if (num) {
//        UIImageView *imgv = [self.view viewWithTag:quality+100];
//        imgv.hidden = NO;
//    }else
//    {
//        UIImageView *imgv = [self.view viewWithTag:101];
//        imgv.hidden = NO;
//        [usf setObject:@(101) forKey:@"picQuality"];
//        [usf synchronize];
//    }
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
- (IBAction)onSelectCLick:(UIButton *)sender {
    [UserDefaultsManager setPicQuality:sender.tag-201];
//    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
//    NSNumber *num = [usf objectForKey:@"picQuality"];
//    if (num.integerValue != sender.tag) {
//        UIImageView *preImgV = [self.view viewWithTag:num.integerValue+1];
//        preImgV.hidden = YES;
//        UIImageView *imgv = [self.view viewWithTag:sender.tag+1];
//        imgv.hidden = NO;
//        [usf setObject:@(sender.tag) forKey:@"picQuality"];
//        [usf synchronize];
//    }
//    
    [self.navigationController popViewControllerAnimated:YES];

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
