//
//  Xwater.m
//  XYW
//
//  Created by xueyongwei on 16/3/30.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XwaterView.h"

@implementation XwaterView
{
    NSString *templtePath;
    UIImageView *currentIamgeView;
    NSInteger imgItemsIndex;
    NSArray *colors;
}

-(NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [[NSMutableArray alloc]init];
    }
    return _labels;
}

-(void)onColorBtnClick:(UIButton *)sender{
    int i=0;
    for (NSString *color in colors) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.origin.x+self.frame.size.width-20+i*40, self.frame.origin.y-40+40*i, 20, 20);
        btn.tag = i;
        [btn addTarget:self action:@selector(onColorItemCLick:) forControlEvents:UIControlEventTouchUpInside];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 10;
        btn.backgroundColor = [UIColor colorWithHexString:[color substringFromIndex:1]];
        i++;
        [self.superview addSubview:btn];
        [self.colorBtnsArray addObject:btn];
    }
    self.showColorBtn = YES;
}
-(void)onColorItemCLick:(UIButton *)sender{
    for (UIView *view in self.XbgView.subviews) {
        if ([view isKindOfClass:[XImageView class]]) {
            XImageView *xview = (XImageView *)view;
            [xview changeToIndex:sender.tag];
        }else if ([view isKindOfClass:[XLabel class]]){
            XLabel *xlabel = (XLabel *)view;
            xlabel.textColor = sender.backgroundColor;
        }
    }
}
-(Xview *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block
{
    self.backgroundColor = [UIColor redColor];
    self.tapBlock = block;
    DbLog(@"%@",str);
    templtePath = path;
    waterModel *model = [waterModel mj_objectWithKeyValues:str];
    [self customSitms:model.items onView:spView];
    
    [spView addSubview:self];
    //xview的一些操作
    return self;
}
-(Xview *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView
{
    DbLog(@"%@",str);
    templtePath = path;
    waterModel *model = [waterModel mj_objectWithKeyValues:str];
    [self customSitms:model.items onView:spView];
    
    [spView addSubview:self];
    //xview的一些操作
    return self;
}
-(void)customSitms:(NSArray *)items onView:(UIView *)Sview
{
    //获取父视图的宽高
    float w = Sview.bounds.size.width;
    float h = Sview.bounds.size.height;
//    float min = w<h?w:h;
    for (Sitem *si in items) {
        //得到模具的frame
        CGRect desRect = CGRectMake(w*si.left.floatValue, h*si.top.floatValue, w*(1-si.right.floatValue-si.left.floatValue), h*(1-si.bottom.floatValue-si.top.floatValue));
        self.frame = desRect;
        CGPoint center = self.center;
//        CGRect bounds = self.bounds;
        
        CGRect optRect = CGRectZero;
        float min = MIN(desRect.size.width,desRect.size.height);
//        min = min>100?min:100;
        if (si.aspectRatio.floatValue>1) {//宽大与高
            optRect.size.width = min;
            optRect.size.height = min/si.aspectRatio.floatValue;
        }else{
            optRect.size.height = min;
            optRect.size.width = min*si.aspectRatio.floatValue;
        }
        //此时水印的大小与比例均为描述文件里的一致，后面的子视图可直接按照描述进行绘制
        self.bounds = CGRectMake(0, 0, optRect.size.width+10, optRect.size.height+10);
        self.center = center;
        
//        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        //改变frame后刷新一下btn的frame
        self.xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
        self.delBtn.frame = CGRectMake(0, 0, 20, 20);
        self.XbgView.frame = optRect;
        if (si.colors&&si.colors.count>0) {
            colors = [[NSArray alloc]initWithArray:si.colors];
            self.colorBtn.frame = CGRectMake(self.bounds.size.width-20, 0, 20, 20);
            [self addSubview:self.colorBtn];
            [self.colorBtn addTarget:self action:@selector(onColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.XbgView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.XbgView.layer.borderColor = [UIColor redColor].CGColor;
        self.XbgView.layer.borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor clearColor];
        NSAssert([si.areaItem.items.firstObject isKindOfClass:[Item class]], @"不是item类型不能继续解析！");
        [self setNeedsDisplay];
        [self customItms:si.areaItem.items onView:self.XbgView];
        
    }
}
-(void)customItms:(NSArray *)itms onView:(UIView *)view
{
    for (Item *i in itms) {
        if (i.type.integerValue == 2) {
            XImageView *imgView = [[XImageView alloc]init];
            if (i.imgItems && i.imgItems.count>0) {
                [imgView setXImageViewItem:i path:templtePath index:imgItemsIndex];
            }else{
                [imgView setXImageViewItem:i path:templtePath];
            }
            
            [imgView showXImageViewInSuperView:view];
        }else if (i.type.integerValue == 1){
            XLabel *label = [[XLabel alloc]init];
            [label setXLabelItem:i];
            [label showLabelInSuperView:view];
            [self.labels addObject:label];
        }else if (i.type.integerValue == 0){
            NSAssert(0, @"注意！当前欠套模板，暂不支持解析！");
        }else if (i.type.integerValue == 7){//包含有地理位置坐标
            [self customItms:i.linearLyout.areaItem.items onView:view];
        }else if (i.type.integerValue == 4){//是个地理坐标
            XLabel *label = [[XLabel alloc]init];
            [label setXLabelItem:i];
            [label showLabelInSuperView:view];
            [self.labels addObject:label];
        }
    }
    [self bringSubviewToFront:self.delBtn];
    [self bringSubviewToFront:self.xzBtn];
}
-(NSTextAlignment)aligmentOfType:(NSNumber *)type{
    if (type.integerValue ==1) {
        return NSTextAlignmentLeft;
    }else if (type.integerValue == 2){
        return NSTextAlignmentRight;
    }
    return NSTextAlignmentCenter;
}

-(NSString *)stringWithLocation
{
    DbLog(@"没位置，爱咋咋地");
    return @"无法获取位置";
}

-(void)imageViewHandle:(UITapGestureRecognizer *)recoginizer
{
    // 判断当前的sourceType是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        currentIamgeView = (UIImageView *)recoginizer.view;
        // 实例化UIImagePickerController控制器
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源（相册、相机、图库之一）
//        imagePickerVC.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
        // 如果选择的是视屏，允许的视屏时长为20秒
        imagePickerVC.videoMaximumDuration = 20;
        // 允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
        imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
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
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    currentIamgeView.image = selectedImage;
}


// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // dismiss UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)ontapSelf
{
    if (self.showColorBtn) {
        for (UIButton *btn in self.colorBtnsArray) {
            [btn removeFromSuperview];
        }
        self.showColorBtn = NO;
        return;
    }
    
    DbLog(@"touch Xview");
    if (self.tapBlock) {
        self.tapBlock(self);
        DbLog(@"我被掉用了");
    }
}

-(void)setXselected:(BOOL)Xselected
{
    [super setXselected:Xselected];
    for (UIView *v  in self.XbgView.subviews) {
        if ([v isKindOfClass:[XLabel class]]) {
            XLabel *lb = (XLabel *)v;
            lb.userInteractionEnabled = Xselected;
            [lb setXuBorder:Xselected];
        }else if ([v isKindOfClass:[UIImageView class]] && v.tag ==100){
            UIImageView *imgV = (UIImageView *)v;
            imgV.userInteractionEnabled = Xselected;
        }
    }
}


@end
