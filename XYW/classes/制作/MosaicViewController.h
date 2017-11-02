//
//  MosaicViewController.h
//  XYW
//
//  Created by xueyognwei on 2017/6/7.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MosaicViewController : UIViewController
@property (nonatomic,strong) void (^editFinishedBlock)(UIImage *image) ;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)UIImage *editImage;
@end
