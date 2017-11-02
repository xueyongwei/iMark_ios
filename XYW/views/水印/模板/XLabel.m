//
//  XLabel.m
//  XYW
//
//  Created by xueyongwei on 16/3/29.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XLabel.h"
#import "InputTextViewController.h"

@implementation XLabel
{
    CAShapeLayer *border;
    CLLocationManager *_locationManager;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.layer containsPoint:point]) {
        if (self.layer.borderWidth > 0) {
            return self;
        }
    }
    return [super hitTest:point withEvent:event];
}
-(void)setXuBorder:(BOOL)xuBorder
{
    border.lineWidth = xuBorder?1.0f:0.0f;
    self.layer.borderWidth = xuBorder?1.0f/[UIScreen mainScreen].scale:0.0f;
    [self setNeedsLayout];
}
-(void)setXLabelItem:(Item *)itm{
    _xTop = itm.top.floatValue;
    _xBottom = itm.bottom.floatValue;
    _xLeft = itm.left.floatValue;
    _xRight = itm.right.floatValue;
    _xAspet = itm.aspectRatio.floatValue;
    if (itm.type.integerValue == 4) {//位置信息
        [self initializeLocationService];
        _xText = [self currentLocalString];
        _xTextFontHeight = itm.geoItem.fontHeight.floatValue;
        if (itm.geoItem.color) {
            _xTextColor = [itm.geoItem.color substringFromIndex:1];//模版里带#号，去掉
        }
        _xTextMaxLength = itm.geoItem.maxLength.floatValue;
        
    }else{
        _xText = itm.textItem.text;
        _xTextFontHeight = itm.textItem.fontheight.floatValue;
        if (itm.textItem.color) {
            _xTextColor = [itm.textItem.color substringFromIndex:1];//模版里带#号，去掉
        }
        _xTextMaxLength = itm.textItem.maxLength.floatValue;
        _xTextMinLength = itm.textItem.minLength.floatValue;
        _xTextEidtable= itm.textItem.eidtable;
        self.xverticalFormType = itm.textItem.textOrientation.integerValue;
        if (self.xverticalFormType == 2) {
//            self.verticalForm = YES;
        }
    }
    
    self.userInteractionEnabled = YES;
    _xTextAlignType = itm.extendAlignType.integerValue;
    
    
    self.maxlenth = self.xText.length;
    if (self.xTextEidtable) {
        [self addTapRecognizer];
    }
    if (self.xTextColor) {
        self.textColor = [UIColor colorWithHexColorString:self.xTextColor];
    }else{
        self.textColor = [UIColor blackColor];
    }
    
    self.text = [self.xText stringByReplacingOccurrencesOfString:@"\n" withString:@""];;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.adjustsFontSizeToFitWidth = YES;
    self.minimumScaleFactor = 0.1;
    if ([self.xText containsString:@"\n"]) {
        self.numberOfLines = 0;
    }
    if (itm.textItem.textOrientation.integerValue ==2) {//竖版
        self.numberOfLines = 0;
        self.adjustsFontSizeToFitWidth = NO;
    }
    self.textAlignment = [self aligmentOfType:self.xTextAlignType];
}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestWhenInUseAuthorization];//这句话ios8以上版本使用。
    [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSString *localName = [NSString stringWithFormat:@"%@|%@|%@|%@",placemark.country,city,placemark.subLocality,placemark.thoroughfare];
            self.text = localName;
        }
        else if (error == nil && [array count] == 0)
        {
            DbLog(@"No results were returned.");
            self.text = @"未知位置";
        }
        else if (error != nil)
        {
            self.text = @"未知位置";
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
-(NSString *)currentLocalString{
    return @"获取位置..";
}
-(void)addTapRecognizer{
    self.userInteractionEnabled = YES;
    self.layer.borderColor = [UIColor redColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelHandle:)];
    self.tapGestureRecognizer = tap;
    [self addGestureRecognizer:tap];
}
-(void)showLabelInSuperView:(UIView *)spView{
   
    CGRect spViewBounds = spView.bounds;
    DbLog(@"spViewBounds %@",NSStringFromCGRect(spViewBounds));
    CGRect selfFrame = CGRectMake(spViewBounds.size.width*self.xLeft, spViewBounds.size.height*self.xTop, spViewBounds.size.width*(1.0-self.xLeft-self.xRight),spViewBounds.size.height*(1.0-self.xTop-self.xBottom));
    if (spViewBounds.size.height>0 && _xTextFontHeight>0) {
        DbLog(@" %@ xTextFontHeight = %f,font size =  %f",self,_xTextFontHeight,self.xTextFontHeight*spViewBounds.size.height);
        self.font = [self.font fontWithSize:self.xTextFontHeight*spViewBounds.size.height*0.8];
    }
    
    self.frame = selfFrame;
    DbLog(@"selfFrame %@",NSStringFromCGRect(selfFrame));
  
    if (!self.superview) {
        [spView addSubview:self];
    }
    [self setNeedsDisplay];
}
-(void)labelHandle:(UITapGestureRecognizer *)recoginizer
{
    DbLog(@"点击了xlabel %@",self);
    if (_stopEdit) {
        DbLog(@"此时不能编辑，放弃响应");
        return;
    }
    InputTextViewController *ipvc = (InputTextViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([InputTextViewController class])];
    DbLog(@"%@",self.text);
    ipvc.maxLenth = self.maxlenth;
    __weak typeof(self) wkSelf = self;
    [ipvc orgStr:self.text returnIptStr:^(NSString *inputStr) {
        wkSelf.text = inputStr;
        if (wkSelf.textChangedBlock) {
            wkSelf.textChangedBlock(inputStr);
        }
    }];
    UIViewController *vc = [self getPresentedViewController];
    if (vc.navigationController) {
        [vc.navigationController pushViewController:ipvc animated:YES];
    }else{
        [vc presentViewController:ipvc animated:YES completion:nil];
    }
    
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        border = [CAShapeLayer layer];
        border.strokeColor = [UIColor redColor].CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        border.frame =self.bounds;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @2];
        [self.layer addSublayer:border];
    }
    return self;
}

/**
 获取模版里的对齐方式
 
 @param type 模版里用的是十六进制的
 @return 返回对应的对齐方式
 */
-(NSTextAlignment)aligmentOfType:(NSInteger )type{
    if (type ==1) {
        return NSTextAlignmentLeft;
    }else if (type == 2){
        return NSTextAlignmentRight;
    }
    return NSTextAlignmentCenter;
}


@end
