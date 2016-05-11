//
//  SystemInformsViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SystemInformsViewController.h"


@interface SystemInformsViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;

@end

@implementation SystemInformsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"系统通知";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    
    self.myTbaleView.rowHeight = 65;
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 3;
//}
//
////-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    static NSString *cellId = @"cellOne";
////    SystemMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
////    if (cell == nil) {
////        cell = [[SystemMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
////    }
////    //[cell setUI];
////    return cell;
////}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//}

-(void)rightBarItemSelected{
    NSLog(@"清空");
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
