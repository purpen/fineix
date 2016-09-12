//
//  SearchUserViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchUserViewController.h"
#import "UserModelRow.h"
#import "UserHeaderTableViewCell.h"
#import "HomePageViewController.h"

static NSString *const URLSearchList = @"/search/getlist";
static NSString *const URLFollowUser = @"/follow/ajax_follow";
static NSString *const URLCancelFollowUser = @"/follow/ajax_cancel_follow";

static NSString *const userCellId = @"UserCellId";

@interface SearchUserViewController () {
    NSString *_keyword;
}

@end

@implementation SearchUserViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navView.hidden = YES;
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
}

#pragma mark - 网络请求
#pragma mark 关注
- (void)thn_networkFollowSceneData:(NSString *)idx {
    self.followRequest = [FBAPI postWithUrlString:URLFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.followRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.userIdMarr indexOfObject:idx];
            [self.userListMarr[index] setValue:@"1" forKey:@"isFollow"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 取消关注
- (void)thn_networkCancelFollowData:(NSString *)idx {
    self.cancelFollowRequest = [FBAPI postWithUrlString:URLCancelFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.cancelFollowRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.userIdMarr indexOfObject:idx];
            [self.userListMarr[index] setValue:@"0" forKey:@"isFollow"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


- (void)searchAgain:(NSString *)keyword {
    [self.userListMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    self.currentpageNum = 0;
    [self networkSearchData:keyword];
}

- (void)networkSearchData:(NSString *)keyword {
    _keyword = keyword;
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":@"content", @"size":@"8", @"page":@(self.currentpageNum + 1), @"t":@"14" , @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *userArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * userDic in userArr) {
            UserModelRow *userModel = [[UserModelRow alloc] initWithDictionary:userDic];
            [self.userListMarr addObject:userModel];
            [self.userIdMarr addObject:userModel.userId];
        }
        
        if (self.userListMarr.count) {
            self.noneLab.hidden = YES;
            self.userTable.hidden = NO;
        } else {
            self.noneLab.hidden = NO;
            self.userTable.hidden = YES;
        }
        
        [self.userTable reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.userTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)requestIsLastData:(UITableView *)tableView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        tableView.mj_footer.state = MJRefreshStateNoMoreData;
        tableView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            [tableView.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        tableView.mj_footer.state = MJRefreshStateNoMoreData;
        tableView.mj_footer.hidden = true;
    }
    if ([tableView.mj_header isRefreshing]) {
        CGPoint tableY = tableView.contentOffset;
        tableY.y = 0;
        if (tableView.bounds.origin.y > 0) {
            [UIView animateWithDuration:.3 animations:^{
                tableView.contentOffset = tableY;
            }];
        }
        [tableView.mj_header endRefreshing];
    }
    if ([tableView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [tableView.mj_footer endRefreshing];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setUserListViewUI];
}

#pragma mark - 设置视图UI
- (void)thn_setUserListViewUI {
    [self.view addSubview:self.userTable];
    [self.view addSubview:self.noneLab];
}

#pragma mark - init
#pragma mark - 没有搜索结果
- (UILabel *)noneLab {
    if (!_noneLab) {
        _noneLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _noneLab.textAlignment = NSTextAlignmentCenter;
        _noneLab.textColor = [UIColor colorWithHexString:titleColor];
        _noneLab.font = [UIFont systemFontOfSize:12];
        _noneLab.text = NSLocalizedString(@"noneSearch", nil);
    }
    return _noneLab;
}

- (UITableView *)userTable {
    if (!_userTable) {
        _userTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        _userTable.delegate = self;
        _userTable.dataSource = self;
        _userTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTable.tableFooterView = [UIView new];
        _userTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _userTable.showsVerticalScrollIndicator = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFollowUser:) name:@"searchFollowUser" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchCancelFollowUser:) name:@"searchCancelFollowUser" object:nil];
    }
    return _userTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    cell = [[UserHeaderTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userCellId];
    if (self.userListMarr.count) {
        [cell setUserListData:self.userListMarr[indexPath.row] nowUserId:[self getLoginUserID]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
    userHomeVC.userId = self.userIdMarr[indexPath.row];
    userHomeVC.type = @2;
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

#pragma mark - 关注
- (void)searchFollowUser:(NSNotification *)idx {
    [self thn_networkFollowSceneData:[idx object]];
}

- (void)searchCancelFollowUser:(NSNotification *)idx {
    [self thn_networkCancelFollowData:[idx object]];
}

#pragma mark - 
- (NSMutableArray *)userListMarr {
    if (!_userListMarr) {
        _userListMarr = [NSMutableArray array];
    }
    return _userListMarr;
}

- (NSMutableArray *)userIdMarr {
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchFollowUser" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchCancelFollowUser" object:nil];
}

@end
