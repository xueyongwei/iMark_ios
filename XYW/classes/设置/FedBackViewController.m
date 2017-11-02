//
//  FedBackViewController.m
//  XYW
//
//  Created by xueyongwei on 16/4/18.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "FedBackViewController.h"

@interface FedBackViewController ()
@property (nonatomic,strong)UIView *inputView;
@property (nonatomic,assign)BOOL isMsgType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFLeading;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FedBackViewController
-(void)setIsMsgType:(BOOL)isMsgType
{
    _isMsgType = isMsgType;
    if (isMsgType) {
        [self.okBtn setTitle:@"发送" forState:UIControlStateNormal];
        self.TFLeading.constant = 10.0f;
        self.TF.placeholder = @"意见反馈";
        self.TF.keyboardType = UIKeyboardTypeDefault;
    }else
    {
        [self.okBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.TFLeading.constant = 60.0f;
        self.TF.placeholder = @"联系方式";
        self.TF.keyboardType = UIKeyboardTypeNumberPad;
    }
    [self.TF resignFirstResponder];
}
-(UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[[NSBundle mainBundle]loadNibNamed:@"FedBackInputView" owner:self options:nil]lastObject];
    }
    return _inputView;
}

- (IBAction)onChangeConnectClick:(UIButton *)sender {
    self.isMsgType = NO;
    [self.TF becomeFirstResponder];
}
- (IBAction)onOkCLick:(UIButton *)sender {
    
    if (self.TF.text.length<1) {
        CoreSVPCenterMsg(@"还未输入内容！");
        return;
    }
    if (self.isMsgType) {
        CoreSVPCenterMsg(@"感谢您的反馈！");
        [self.TF resignFirstResponder];
        self.TF.text = @"";
    }else
    {
        self.contentLabel.text = self.TF.text;
        self.isMsgType = YES;
        self.TF.text = @"";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (self.isMsgType) {
        [self.view endEditing:YES];
    }else{
        self.isMsgType = YES;
         [self.TF becomeFirstResponder];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackNaviBarBtn];
    self.inputView.frame = CGRectMake(0, SCREEN_H-60, SCREEN_W, 60);
    [self.view addSubview:self.inputView];
    self.isMsgType = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
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
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 键盘的frame发生改变时调用（显示、隐藏等）
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DbLog(@"keyb %@ screen %f %f",NSStringFromCGRect(keyboardF),SCREEN_H,SCREEN_W);
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = self.inputView.frame;
        rect.origin.y = keyboardF.origin.y-rect.size.height;
        self.inputView.frame = rect;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
