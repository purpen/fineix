//
//  MyPageFocusOnViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyPageFocusOnViewController.h"
#import "FocusOnTableViewCell.h"
#import "HomePageViewController.h"

@interface MyPageFocusOnViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyPageFocusOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航条
    self.navigationItem.title = @"关注";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    
    
    
    [self.view addSubview:self.mytableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        self.mytableView.delegate = self;
        self.mytableView.dataSource = self;
    }
    return _mytableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FocusOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FocusOnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell setUI];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageViewController *v = [[HomePageViewController alloc] init];
    v.isMySelf = NO;
    v.type = @1;
    [self.navigationController pushViewController:v animated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55/667.0*SCREEN_HEIGHT;
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
