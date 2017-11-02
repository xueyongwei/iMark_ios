//
//  DrawView.h
//  PictureViewer
//
//  Created by xueyongwei on 16/3/7.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DrawVieweDelegate <NSObject>
@optional
- (void)DrawViewChanged;
@end

@interface DrawView : UIView
//@property (nonatomic,strong)NSMutableArray *lines;
@property (nonatomic,strong)UIImage *bgImage;
@property (nonatomic,strong)UIColor *color;
@property (nonatomic,assign)BOOL erase;
@property (nonatomic,assign)CGFloat scale;
@property (nonatomic,assign)float lWidth;
@property (nonatomic,weak)id<DrawVieweDelegate> delegate;
//可通过sb或者xib方法添加本视图

//需要回退时调用这个方法
-(void)unDo;
//需要恢复时调用这个方法
-(void)reDo;
//取涂鸦内容为图片
- (UIImage *)getImage;
@end
