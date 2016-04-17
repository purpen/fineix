//
//  MyHomePageScenarioViewController.m
//  Fiu
//
//  Created by dys on 16/4/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyHomePageScenarioViewController.h"
#import "Fiu.h"

@interface MyHomePageScenarioViewController ()<UITableViewDelegate,UITableViewDataSource,FBNavigationBarItemsDelegate>

@end

@implementation MyHomePageScenarioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    [self setNavigationView];
    //设置tableview
    [self.view addSubview:self.myTableView];
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }else if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    // Do any additional setup after loading the view.
}
//设置导航条
-(void)setNavigationView{
    self.delegate = self;
    [self addBarItemLeftBarButton:nil image:@"Fill 1"];
    [self navBarTransparent:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

//导航栏左边按钮
-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

#pragma mark - tableViewDelegate & dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        
//    }
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }else if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)getNetData{
    
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
