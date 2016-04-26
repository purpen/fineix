//
//  PraisedViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PraisedViewController.h"
#import "SceneListTableViewCell.h"

@interface PraisedViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation PraisedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航
    self.navigationItem.title = @"赞过的";
    self.navigationController.navigationBarHidden = NO;
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    //
    [self.view addSubview:self.myTableView];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _myTableView.rowHeight = SCREEN_HEIGHT;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"cellId";
    SceneListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (cell == nil) {
        cell = [[SceneListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
    }
//    [cell setUI];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
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
