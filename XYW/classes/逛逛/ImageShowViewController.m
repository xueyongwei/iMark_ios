//
//  ImageShowViewController.m
//  XYW
//
//  Created by xueyognwei on 2017/6/9.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "ImageShowViewController.h"
#import <YYKit.h>
@interface ImageShowViewController ()


@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    if (self.imageUrl.length>1) {
        [self.imageView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholder:nil];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}
-(void)tapView:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
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
