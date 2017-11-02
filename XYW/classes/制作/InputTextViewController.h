//
//  InputTextViewController.h
//  XYW
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^inputBlock) (NSString *inputStr);
@interface InputTextViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *TV;
@property (nonatomic,assign)NSInteger maxLenth;
-(void)orgStr:(NSString *)str returnIptStr:(inputBlock)block;
-(void)returnIptStr:(inputBlock)block;
@end
