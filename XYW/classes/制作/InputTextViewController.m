//
//  InputTextViewController.m
//  XYW
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "InputTextViewController.h"

@interface InputTextViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tvH;
@property (weak, nonatomic) IBOutlet UIView *titView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation InputTextViewController
{
    inputBlock tmpBlock;
    NSString *tmpStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titView.backgroundColor = [UIColor colorWithHexColorString:@"e84f3c"];
    DbLog(@"%@",self.TV);
    self.TV.text = tmpStr;
    self.TV.delegate = self;
    [self customBackNaviBarBtn];
    if (self.navigationItem) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        self.navigationItem.title = @"编辑内容";
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onOkClick:)];
        self.navigationItem.rightBarButtonItem = save;
    }
    if (self.maxLenth>0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.TV.text.length,self.maxLenth];
    }else{
        self.numberLabel.text = @"";
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.TV becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.TV resignFirstResponder];
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
-(void)orgStr:(NSString *)str returnIptStr:(inputBlock)block
{
    DbLog(@"received %@ %@",str,self.TV);
    tmpStr = str;
    tmpBlock = block;
}
-(void)returnIptStr:(inputBlock)block
{
    tmpBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCancleClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onOkClick:(id)sender {
    [self.TV resignFirstResponder];
    if (!tmpBlock) {
        return;
    }
    tmpBlock(self.TV.text);
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark --textView代理相关
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (self.maxLenth<0) {
        return;
    }
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textView.text.length>self.maxLenth) {
                textView.text = [textView.text substringToIndex:self.maxLenth];
            }
            [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [textView.text stringByReplacingOccurrencesOfString:@"" withString:@""];
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,self.maxLenth];
        } // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (textView.text.length>self.maxLenth) {
            textView.text = [textView.text substringToIndex:self.maxLenth];
            
        }
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,self.maxLenth];
    }
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
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
