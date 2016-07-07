//
//  FiuPeopleListViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuPeopleListViewController.h"
#import "FiuPeopleListTableViewCell.h"
#import "FiuPeopleListRow.h"
#import "HomePageViewController.h"

static NSString *const FiuPeople = @"/user/activity_user";

@interface FiuPeopleListViewController ()

@pro_strong NSMutableArray       *   peopleList;
@pro_strong NSMutableArray       *   fiuPeopleIdMarr;

@end

@implementation FiuPeopleListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkFiuPeople];
    [self.view addSubview:self.userListTable];
    
}

#pragma mark - 网络请求
- (void)networkFiuPeople {
    [SVProgressHUD show];
    self.fiuPeopleRequest = [FBAPI getWithUrlString:FiuPeople requestDictionary:@{@"sort":@"1", @"page":@"1", @"size":@"100"} delegate:self];
    [self.fiuPeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * fiuPeopleArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * fiuPeopleDic in fiuPeopleArr) {
            FiuPeopleListRow * fiuSceneModel = [[FiuPeopleListRow alloc] initWithDictionary:fiuPeopleDic];
            [self.peopleList addObject:fiuSceneModel];
            [self.fiuPeopleIdMarr addObject:[NSString stringWithFormat:@"%zi", fiuSceneModel.idField]];
        }
        [self.userListTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma makr - 用户排行列表
- (UITableView *)userListTable {
    if (!_userListTable) {
        _userListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _userListTable.delegate = self;
        _userListTable.dataSource = self;
    }
    return _userListTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peopleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * peopleListCellId = @"peopleListCellId";
    FiuPeopleListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:peopleListCellId];
    if (!cell) {
        cell = [[FiuPeopleListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:peopleListCellId];
    }
    if (self.peopleList.count) {
        [cell setFiuPeopleListData:indexPath.row+1 withData:self.peopleList[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageViewController * peopleHomeVC = [[HomePageViewController alloc] init];
    peopleHomeVC.userId = self.fiuPeopleIdMarr[indexPath.row];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if ([entity.userId intValue] == [self.fiuPeopleIdMarr[indexPath.row] intValue]) {
        peopleHomeVC.isMySelf = YES;
    }else{
        peopleHomeVC.isMySelf = NO;
    }
    peopleHomeVC.type = @2;
    [self.navigationController pushViewController:peopleHomeVC animated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"FiuPeopleListVC", nil);
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (NSMutableArray *)peopleList {
    if (!_peopleList) {
        _peopleList = [NSMutableArray array];
    }
    return _peopleList;
}

- (NSMutableArray *)fiuPeopleIdMarr {
    if (!_fiuPeopleIdMarr) {
        _fiuPeopleIdMarr = [NSMutableArray array];
    }
    return _fiuPeopleIdMarr;
}

@end
