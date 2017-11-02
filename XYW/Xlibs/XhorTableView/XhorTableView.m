//
//  VtableView.m
//  VtableView
//
//  Created by xueyongwei on 16/3/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XhorTableView.h"
#import "XtableCell.h"
@interface XhorTableView()
@property (nonatomic,strong)NSArray *dataSource;
@end
@implementation XhorTableView
{
    UITableView *XtableView;
    XhorTbaleViewBlock tmpBlock;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xLoadInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self xLoadInit];
    }
    return self;
}
-(void)XhorTbaleViewDidSelectedWIthBlock:(XhorTbaleViewBlock)block
{
    DbLog(@"保存block %@",block);
    tmpBlock = block;
    DbLog(@"完成保存block %@",tmpBlock);
}
-(void)xLoadInit
{
    self.dataSource = @[@"本地",@"购物",@"美食",@"文艺",@"旅游"];
    self.backgroundColor = [UIColor purpleColor];
    XtableView = [[UITableView alloc]init];
    XtableView.delegate = self;
    XtableView.dataSource = self;
    XtableView.showsHorizontalScrollIndicator = NO;
    XtableView.showsVerticalScrollIndicator = NO;
    [self addSubview:XtableView];
    self.tableViewCellHeight = 100;
    XtableView.sd_layout
    .topSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .widthRatioToView(self,1.0)
    .heightRatioToView(self,1.0);
    
    XtableView.transform = CGAffineTransformRotate(XtableView.transform, -M_PI_2);
    XtableView.sd_layout
    .topSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .widthRatioToView(self,1.0)
    .heightRatioToView(self,1.0);
    
    [XtableView reloadData];

    [XtableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DbLog(@"%ld  %@",self.dataSource.count,self.dataSource);
    return 5;
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XtableCell *cell = (XtableCell *)[tableView dequeueReusableCellWithIdentifier:@"XtableCellID"];
    if (!cell) {
        CGPoint center = cell.center;
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XtableCell" owner:self options:nil]lastObject];
        cell.transform = CGAffineTransformRotate(cell.transform, M_PI_2);
        cell.center = center;
    }
    DbLog(@"%@",self.dataSource[indexPath.row]);
    cell.typeName = self.dataSource[indexPath.row];
    return cell;
}
-(void)setTableViewCellHeight:(CGFloat)tableViewCellHeight
{
    _tableViewCellHeight = tableViewCellHeight;
    [XtableView reloadData];
}
-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [XtableView reloadData];
     DbLog(@"get dataSource");
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DbLog(@"%f",self.tableViewCellHeight);
    return self.tableViewCellHeight;
}
-(void)XtableViewReload
{
    [XtableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DbLog(@"点击了cell");
    if (tmpBlock) {
        DbLog(@"回传这个点击");
        tmpBlock(indexPath.row);
    }
    
}

@end
