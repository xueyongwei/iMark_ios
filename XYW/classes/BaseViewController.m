//
//  BaseViewController.m
//  XYW
//
//  Created by xueyongwei on 16/4/22.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "BaseViewController.h"
#import "PathModel.h"
#import "waterModel.h"
#import "FontModel.h"
@interface BaseViewController ()
@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)reScanLocalWaterModel{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/template",[paths objectAtIndex:0]];
    
    NSUserDefaults *usf = [NSUserDefaults standardUserDefaults];
    //解析本地水印模版变为model
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSMutableArray *pathModels = [[NSMutableArray alloc]init];
    for (NSString *dir in fileList) {
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,dir] isDirectory:&isDir]) {
            if (isDir) {
                //根据tag判断类型
                PathModel *model = [[PathModel alloc]init];
                model.path = dir;
                //取tag值是多少
                NSString *filePath = [NSString stringWithFormat:@"%@/des",model.path];
                NSString *str =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                waterModel *wmodel = [waterModel mj_objectWithKeyValues:str];
                model.type = wmodel.tag.intValue;
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [pathModels addObject:data];
            }else
            {
            }
        }
    }
    //存储到本地
    [usf setObject:pathModels forKey:@"pathModels"];
    [usf synchronize];
    [self haveScanDir];
}
-(void)haveScanDir
{
    DbLog(@"已重新扫描本地水印模板！请在此作出刷新！");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
