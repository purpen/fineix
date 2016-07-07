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

static NSString *const FiuPeople = @"/user/activity_user";

@interface FiuPeopleListViewController ()

@pro_strong NSMutableArray       *   peopleList;
@pro_strong NSMutableArray       *   fiuPeopleIdMarr;

@end

@implementation FiuPeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationViewUI];
//    [self.view addSubview:self.userListTable];
//    [self networkFiuPeople];
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
    static NSString * fiuPeopleListCellId = @"fiuPeopleListCellId";
    FiuPeopleListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuPeopleListCellId];
    if (!cell) {
        cell = [[FiuPeopleListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuPeopleListCellId];
    }
    if (self.peopleList.count) {
        [cell setFiuPeopleListData:indexPath.row+1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"－－－－－－－－－－－－－－－－－－－－ %@", self.fiuPeopleIdMarr[indexPath.row]);
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
