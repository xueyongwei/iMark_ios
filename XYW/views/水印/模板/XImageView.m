//
//  XImageView.m
//  XYW
//
//  Created by xueyognwei on 2017/5/25.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "XImageView.h"

@implementation XImageView 
{
    NSString *localPath;
    Item *_itm;
}
-(void)setXuBorder:(BOOL)xuBorder
{
    self.layer.borderWidth = xuBorder?1.0f/[UIScreen mainScreen].scale:0.0f;
    [self setNeedsDisplay];
}
-(void)changeToIndex:(NSInteger )index{
    ImgItem *i = _itm.imgItems[index];
    _xEditable = i.editable;
    _xPath = i.path;
    self.image = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",localPath,self.xPath]];
}
-(void)setXImageViewItem:(Item *)itm path:(NSString *)path index:(NSInteger)index{
    _xTop = itm.top.floatValue;
    _xBottom = itm.bottom.floatValue;
    _xLeft = itm.left.floatValue;
    _xRight = itm.right.floatValue;
    _xAspet = itm.aspectRatio.floatValue;
    if (itm.imgItems && itm.imgItems.count>0) {
        ImgItem *i = itm.imgItems[index];
        _xEditable = i.editable;
        _xPath = i.path;
    }else{
        _xEditable = itm.imgItem.editable;
        _xPath = itm.imgItem.path;
    }
    
    localPath = path;
    _itm = itm;
    if (self.xEditable) {
        self.userInteractionEnabled = YES;
        self.layer.borderColor = [UIColor redColor].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvHandle:)];
        [self addGestureRecognizer:tap];
    }
}
-(void)setXImageViewItem:(Item *)itm path:(NSString *)path{
    _xTop = itm.top.floatValue;
    _xBottom = itm.bottom.floatValue;
    _xLeft = itm.left.floatValue;
    _xRight = itm.right.floatValue;
    _xAspet = itm.aspectRatio.floatValue;
    
    _xEditable = itm.imgItem.editable;
    _xPath = itm.imgItem.path;
    localPath = path;
    if (self.xEditable) {
        self.userInteractionEnabled = YES;
        self.layer.borderColor = [UIColor redColor].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgvHandle:)];
        [self addGestureRecognizer:tap];
    }
}

-(void)showXImageViewInSuperView:(UIView *)spView
{
    CGRect spViewBounds = spView.bounds;
    self.contentMode = UIViewContentModeScaleAspectFit;
    CGRect selfFrame = CGRectMake(spViewBounds.size.width*self.xLeft, spViewBounds.size.height*self.xTop, spViewBounds.size.width*(1-self.xLeft-self.xRight),spViewBounds.size.height*(1-self.xTop-self.xBottom));
    self.frame = selfFrame;
    if (!self.image) {
        self.image = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",localPath,self.xPath]];
    }
    if (!self.superview) {
        [spView addSubview:self];
    }
}



-(void)imgvHandle:(UITapGestureRecognizer *)recoginizer
{
    DbLog(@"点击了xiamgeview %@",self);
    // 判断当前的sourceType是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 实例化UIImagePickerController控制器
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源（相册、相机、图库之一）
        //        imagePickerVC.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
        imagePickerVC.mediaTypes = @[ (NSString *)kUTTypeImage];
        // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
        imagePickerVC.delegate = self;
        // 是否允许编辑（YES：图片选择完成进入编辑模式）
        imagePickerVC.allowsEditing = YES;
        // model出控制器
        [[self getPresentedViewController] presentViewController:imagePickerVC animated:YES completion:nil];
    }
    
}

// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // dismiss UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典中
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.image = selectedImage;
}

@end
