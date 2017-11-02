//
//  ImageShowViewController.h
//  XYW
//
//  Created by xueyognwei on 2017/6/9.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShowViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy) NSString *imageUrl;
@end
