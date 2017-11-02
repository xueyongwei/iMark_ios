//
//  WaterView.m
//  PictureViewer
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "WaterView.h"
#import "UIView+Extend.h"
#import "XLabel.h"

@implementation WaterView
{
    NSString *templtePath;
    UIView *bgView;
    tapWaterViewBlock tmpBlock;
}
-(UIButton *)xzBtn
{
    if (!_xzBtn) {
        _xzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _xzBtn.userInteractionEnabled = YES;
        _xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
        [_xzBtn setBackgroundImage:[UIImage imageNamed:@"xz"] forState:UIControlStateNormal];
        [_xzBtn addTarget:self action:@selector(onXzTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _xzBtn;
}

-(NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [[NSMutableArray alloc]init];
    }
    return _labels;
}

-(UIButton *)delBtn
{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.userInteractionEnabled = YES;
        _delBtn.frame = CGRectMake(0, 0, 20, 20);
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(onDelclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}
-(void)onDelclick:(UIButton *)sender
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    tmpBlock(self);
    self.Xselected = YES;
}
-(void)onXzTouchDown:(UIButton *)sender
{
    self.tag = XSTAGXuanzhuan;
}
-(UIView *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView
{
    DbLog(@"%@",str);
    templtePath = path;
    waterModel *model = [waterModel mj_objectWithKeyValues:str];
    [self customSitms:model.items onView:spView];
    
    [spView addSubview:self];
    //xview的一些操作
    [self XviewOpear];
    return self;
}
-(UIView *)returnWaterView:(NSString *)str path:(NSString *)path onSuperView:(UIView *)spView tapBlock:(tapWaterViewBlock)block
{
    tmpBlock = block;
    DbLog(@"%@",str);
    templtePath = path;
    waterModel *model = [waterModel mj_objectWithKeyValues:str];
    [self customSitms:model.items onView:spView];
    
    [spView addSubview:self];
    //xview的一些操作
    [self XviewOpear];
    return self;

}
-(void)XviewOpear
{
    [self addSubview:self.xzBtn];
    [self addSubview:self.delBtn];
    XsingleRotationRecoginzer *xs = [[XsingleRotationRecoginzer alloc]initWithTarget:self action:@selector(onXsHandle:)];
    [self addGestureRecognizer:xs];
    self.Xselected = YES;
//    self.clipsToBounds = YES;
}
-(void)onXsHandle:(XsingleRotationRecoginzer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    [self resetBtnScale:recognizer.scale];
}
//两个按钮随着父视图的拉伸变形，要还原回来
-(void)resetBtnScale:(CGFloat)scale
{
    self.xzBtn.transform = CGAffineTransformScale(self.xzBtn.transform, 1.0f/scale, 1.0f/scale);
    self.delBtn.transform = CGAffineTransformScale(self.delBtn.transform, 1.0f/scale, 1.0f/scale);
    //    self.xzBtn.frame = CGRectMake(self.bounds.size.width-20, self.bounds.size.height-20, 20, 20);
    //    self.delBtn.frame = CGRectMake(0, 0, 20, 20);
}
-(void)customSitms:(NSArray *)items onView:(UIView *)Sview
{
    //获取父视图的宽高
    float w = Sview.bounds.size.width;
    float h = Sview.bounds.size.height;
    float min = w>h?w:h;
    for (Sitem *si in items) {
        //得到模具的frame
        CGRect rect = CGRectMake(w*si.left.floatValue, h*si.top.floatValue, min*(1-si.right.floatValue-si.left.floatValue), min*(1-si.bottom.floatValue-si.top.floatValue));
        self.frame = rect;
        
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, rect.size.width-20, rect.size.height-20)];
        bgView.layer.borderColor = [UIColor redColor].CGColor;
        bgView.layer.borderWidth = 1.0f;
        
        
        self.backgroundColor = [UIColor clearColor];
        NSAssert([si.areaItem.items.firstObject isKindOfClass:[Item class]], @"不是item类型不能继续解析！");
        [self customItms:si.areaItem.items onView:bgView];
    }
}
-(void)customItms:(NSArray *)itms onView:(UIView *)view
{
    
    float w = view.bounds.size.width;
    float h = view.bounds.size.height;
    for (Item *i in itms) {
        if (i.type.integerValue == 2) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(w*i.left.floatValue, h*i.top.floatValue, w*(1-i.right.floatValue-i.left.floatValue), h*(1-i.bottom.floatValue-i.top.floatValue))];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            NSLog(@"%@",[i.imgItem.path substringFromIndex:5]);
            imgView.image = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",templtePath,i.imgItem.path]];
            imgView.userInteractionEnabled = NO;
            [view addSubview:imgView];
        }else if (i.type.integerValue == 1){
            XLabel *label = [[XLabel alloc]initWithFrame:CGRectMake(w*i.left.floatValue, h*i.top.floatValue, w*(1-i.right.floatValue-i.left.floatValue)>i.textItem.maxLength.floatValue*w?i.textItem.maxLength.floatValue*w:w*(1-i.right.floatValue-i.left.floatValue), h*(1-i.bottom.floatValue-i.top.floatValue))];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = i.textItem.text;
            if (i.textItem.eidtable) {
                label.xuBorder = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelHandle:)];
                [label addGestureRecognizer:tap];
                label.userInteractionEnabled = YES;
                
            }
            
            label.font = [UIFont systemFontOfSize:i.textItem.fontheight.floatValue*view.bounds.size.height*0.75];
            
            label.textColor = [UIColor colorWithHexColorString:i.textItem.color];
            [view addSubview:label];
            [self.labels addObject:label];
        }else if (i.type.integerValue == 0){
            NSAssert(0, @"注意！当前欠套模板，暂不支持解析！");
        }else if (i.type.integerValue == 7){//包含有地理位置坐标
            [self customItms:i.linearLyout.areaItem.items onView:view];
        }else if (i.type.integerValue == 4){//是个地理坐标
            XLabel *label = [[XLabel alloc]initWithFrame:CGRectMake(w*i.left.floatValue, h*i.top.floatValue, w*(1-i.right.floatValue-i.left.floatValue), h*(1-i.bottom.floatValue-i.top.floatValue))];
            label.text = [self stringWithLocation];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelHandle:)];
            [label addGestureRecognizer:tap];
            label.userInteractionEnabled = YES;
            label.xuBorder = YES;
            DbLog(@"%f %f  %f",i.geoItem.fontHeight.floatValue*view.bounds.size.height,view.bounds.size.height,i.geoItem.fontHeight.floatValue);
            label.font = [UIFont systemFontOfSize:i.geoItem.fontHeight.floatValue*view.bounds.size.height*0.75];
            DbLog(@"%@",[UIColor colorWithHexColorString:i.geoItem.color]);
            label.textColor = [UIColor colorWithHexColorString:i.geoItem.color];
            [view addSubview:label];
            [self.labels addObject:label];
        }
    }
}
-(void)setXselected:(BOOL)Xselected
{
    DbLog(@"Xselectef = %d",Xselected);
    self.xzBtn.hidden = Xselected?NO:YES;
    self.delBtn.hidden = Xselected?NO:YES;
    bgView.layer.borderWidth = Xselected?1.0f:0.0f;
    [self labelShouBorder:Xselected];
    _Xselected = Xselected;
}
-(void)labelShouBorder:(BOOL)should
{
    for (XLabel *label in self.labels) {
        label.xuBorder = should?YES:NO;
    }
}
-(NSString *)stringWithLocation
{
    DbLog(@"没位置，爱咋咋地");
    return @"没位置，爱咋咋地";
}
-(void)labelHandle:(UITapGestureRecognizer *)recoginizer
{
    //当前没有被选中的时候不能响应
    if (!self.Xselected) {
        return;
    }
    DbLog(@"点击了label %@",recoginizer.view);
    UILabel * lb = (UILabel *)recoginizer.view;
    InputTextViewController *ipvc = (InputTextViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputTextViewController class])];
    NSLog(@"%@",lb.text);
    [ipvc orgStr:lb.text returnIptStr:^(NSString *inputStr) {
        lb.text = inputStr;
    }];
    [[UIApplication sharedApplication].windows.lastObject.rootViewController   presentViewController:ipvc animated:YES completion:nil];
}
-(CGFloat)getRealSizeFrom:(float)height
{
    DbLog(@"%f %f",height,height/72*96);
    return height/72*96;
}


@end
