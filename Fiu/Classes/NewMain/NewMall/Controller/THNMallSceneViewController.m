//
//  THNBuySceneViewController.m
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNMallSceneViewController.h"
#import "HomeSceneListRow.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

static NSString *const URLSceneList         = @"/scene_sight/";
static NSString *const URLDeleteScene       = @"/scene_sight/delete";
static NSString *const URLLikeScene         = @"/favorite/ajax_love";
static NSString *const URLCancelLike        = @"/favorite/ajax_cancel_love";
static NSString *const URLFavorite          = @"/favorite/ajax_favorite";
static NSString *const URLCancelFavorite    = @"/favorite/ajax_cancel_favorite";

static NSString *const userInfoCellId       = @"UserInfoCellId";
static NSString *const sceneImgCellId       = @"SceneImgCellId";
static NSString *const dataInfoCellId       = @"DataInfoCellId";
static NSString *const sceneInfoCellId      = @"SceneInfoCellId";

@interface THNMallSceneViewController () {
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
}

@end

@implementation THNMallSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setViewUI];
}

#pragma mark - 情境列表
- (void)thn_networkSceneListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@(self.sceneCurrentpage + 1),
                                 @"size":@"10",
                                 @"sort":@"1",
                                 @"fine":@"0",
                                 @"use_cache":@"1",
                                 @"is_product":@"1"};
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        [self.sceneTable reloadData];
        self.sceneCurrentpage = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.sceneTotalPage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.sceneTable currentPage:self.sceneCurrentpage withTotalPage:self.sceneTotalPage];

        [SVProgressHUD dismiss];

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isLove"];
        }

    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isLove"];
        }

    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 收藏
- (void)thn_networkFavoriteData:(NSString *)idx {
    self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isFavorite"];
        }

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 取消收藏
- (void)thn_networkCancelFavoriteData:(NSString *)idx {
    self.cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isFavorite"];
        }

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 删除情境
- (void)thn_networkDeleteScene:(NSString *)idx {
    self.deleteRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":idx} delegate:self];
    [self.deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr removeObjectAtIndex:index];
            [self.sceneIdMarr removeObjectAtIndex:index];
            [self.userIdMarr removeObjectAtIndex:index];
            [self.sceneTable deleteSections:[NSIndexSet indexSetWithIndex:index + 1] withRowAnimation:(UITableViewRowAnimationFade)];
        }

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 是否分页加载
- (void)requestIsLastData:(UIScrollView *)scrollView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (scrollView.mj_footer.state == MJRefreshStateNoMoreData) {
            [scrollView.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    if ([scrollView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [scrollView.mj_footer endRefreshing];
        }
    }
}

#pragma mark 情境上拉加载
- (void)addMJRefreshTable:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.sceneCurrentpage < self.sceneTotalPage) {
            [self thn_networkSceneListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 视图
- (void)thn_setViewUI {
    [self.view addSubview:self.sceneTable];
    
    [self thn_networkSceneListData];
}

#pragma mark 情境列表
- (UITableView *)sceneTable {
    if (!_sceneTable) {
        _sceneTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157) style:(UITableViewStyleGrouped)];
        _sceneTable.delegate = self;
        _sceneTable.dataSource = self;
        _sceneTable.tableFooterView = [UIView new];
        _sceneTable.showsVerticalScrollIndicator = NO;
        _sceneTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _sceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addMJRefreshTable:_sceneTable];
    }
    return _sceneTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneListMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;

    if (indexPath.row == 0) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        if (!cell) {
            cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section]];
            [cell thn_touchUpOpenControllerType:(ClickOpenTypeSceneList)];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;

    } else if (indexPath.row == 1) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        if (!cell) {
            cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section] userId:[self getLoginUserID] isLogin:[self isUserLogin]];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;

    } else if (indexPath.row == 2) {
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        if (!cell) {
            cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section]];
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
        }
        cell.nav = self.navigationController;
        return cell;

    } else if (indexPath.row == 3) {
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        if (!cell) {
            cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setSceneData:self.sceneListMarr[indexPath.section]
                           isLogin:[self isUserLogin]
                        isUserSelf:[self isLoginUserSelf:self.userIdMarr[indexPath.section]]];

            cell.beginLikeTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkLikeSceneData:idx];
            };

            cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkCancelLikeData:idx];
            };

            cell.beginFavoriteTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkFavoriteData:idx];
            };

            cell.cancelFavoriteTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkCancelFavoriteData:idx];
            };

            cell.deleteTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkDeleteScene:idx];
            };
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SCREEN_WIDTH;

    } else if (indexPath.row == 1) {
        return 50;

    } else if (indexPath.row == 2) {
        if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
            return _contentHigh + 15;
        } else {
            return _defaultContentHigh + 15;
        }

    } else if (indexPath.row == 3) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (_contentHigh > 90.0f) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                _selectedIndexPath = nil;
            } else {
                _selectedIndexPath = indexPath;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


#pragma mark - NSMutableArray
- (NSMutableArray *)sceneListMarr {
    if (!_sceneListMarr) {
        _sceneListMarr = [NSMutableArray array];
    }
    return _sceneListMarr;
}

- (NSMutableArray *)sceneIdMarr {
    if (!_sceneIdMarr) {
        _sceneIdMarr = [NSMutableArray array];
    }
    return _sceneIdMarr;
}

- (NSMutableArray *)userIdMarr {
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}


@end
