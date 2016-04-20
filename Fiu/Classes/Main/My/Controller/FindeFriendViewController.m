//
//  FindeFriendViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FindeFriendViewController.h"
#import "FindeFriendTableViewCell.h"
#import "FriendTableViewCell.h"

@interface FindeFriendViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation FindeFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.navigationItem.title = @"发现好友";
    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    [self addBarItemRightBarButton:nil image:@"scanning"];
    [self.view addSubview:self.myTbaleView];
}

-(UITableView *)myTbaleView{
    if (!_myTbaleView) {
        _myTbaleView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _myTbaleView.delegate = self;
        _myTbaleView.dataSource = self;
    }
    return _myTbaleView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *id = @"cellOne";
        FindeFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
        if (cell == nil) {
            cell = [[FindeFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
        }
        [cell setUI];
        return cell;
    }else{
        static NSString *cellId = @"cellTwo";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] init];
        }
        [cell setUI];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60/667.0*SCREEN_HEIGHT;
    }else{
        return 542*0/5/667.0*SCREEN_HEIGHT;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 1;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    NSLog(@"扫一扫");
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
