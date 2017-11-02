//
//  VtableView.h
//  VtableView
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XhorTbaleViewBlock) (NSInteger index);
@interface XhorTableView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)CGFloat tableViewCellHeight;
//-(void)XtableViewReload;
-(void)XhorTbaleViewDidSelectedWIthBlock:(XhorTbaleViewBlock)block;
-(void)XtableViewReload;
@end
