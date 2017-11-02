//
//  XiewShowDescModel.h
//  XYW
//
//  Created by xueyognwei on 2017/5/24.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiewShowDescModel : NSObject
@property(nonatomic,assign) CGFloat    xScale;
@property(nonatomic,assign) CGFloat    yScale;
@property(nonatomic,assign) CGFloat    wScale;
@property(nonatomic,assign) CGFloat    hScale;
@property(nonatomic,assign) CGFloat    xtop;
@property(nonatomic,assign) CGFloat    xbottom;
@property(nonatomic,assign) CGFloat    xleft;
@property(nonatomic,assign) CGFloat    xright;
//@property(nonatomic,assign) CGFloat    xaspectRito;
@property(nonatomic,assign) CGFloat    minLenthScale;
@property(nonatomic) CGSize            optViewSize;
@property(nonatomic) BOOL              hidden;
@property(nonatomic) CGRect            frame;
@property(nonatomic) CGRect            bounds;      // default bounds is zero origin, frame size. animatable
@property(nonatomic) CGPoint           center;      // center is center of frame. animatable
@property(nonatomic) CGAffineTransform transform;
@end
