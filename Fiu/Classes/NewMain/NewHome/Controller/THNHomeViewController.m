//
//  THNHomeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "CommentNViewController.h"
#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"
#import "SearchViewController.h"
#import "THNSubscribeViewController.h"

#import "HomeThemeTableViewCell.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNSceneCommentTableViewCell.h"
#import "THNLookAllCommentTableViewCell.h"

#import "HomeSceneListRow.h"
#import "CommentRow.h"
#import "RollImageRow.h"
#import "FBSubjectModelRow.h"
#import "HotUserListUser.h"
#import "THNArticleModel.h"

#import "MJRefresh.h"
#import "FBRefresh.h"
#import "THNHotUserFlowLayout.h"

static NSString *const URLBannerSlide = @"/gateway/slide";
static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLSubject = @"/scene_subject/getlist";
static NSString *const URLSubjectView = @"/scene_subject/view";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const URLFollowUser = @"/follow/ajax_follow";
static NSString *const URLCancelFollowUser = @"/follow/ajax_cancel_follow";
static NSString *const URLFavorite = @"/favorite/ajax_favorite";
static NSString *const URLCancelFavorite = @"/favorite/ajax_cancel_favorite";
static NSString *const URLHotUserList = @"/user/find_user";
static NSString *const URLDeleteScene = @"/scene_sight/delete";

static NSString *const themeCellId = @"ThemeCellId";
static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const commentsCellId = @"CommentsCellId";
static NSString *const twoCommentsCellId = @"TwoCommentsCellId";
static NSString *const allCommentsCellId = @"AllCommentsCellId";

@interface THNHomeViewController () {
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _commentHigh;
    NSString *_sceneId;
    NSString *_userId;
    NSInteger _hotUserListIndex;
    CGFloat _hotUserCellHeight;
    NSInteger _subjectType;
    BOOL _rollDown;                  //  是否下拉
    CGFloat _lastContentOffset;      //  滚动的偏移量
}

@end

@implementation THNHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHotUserListData];
    [self thn_registerNSNotification];
    [self thn_netWorkGroup];
}

#pragma mark - 设置"发现用户"的位置和高度
- (void)setHotUserListData {
    _hotUserListIndex = 5;
    _hotUserCellHeight = 245.0f;
}

#pragma mark - 网络请求
- (void)thn_netWorkGroup {
    [self thn_networkRollImageData];
    [self thn_networkSubjectData];
    [self thn_networkHotUserListData];
    [self thn_networkSceneListData];
}

//  轮播图
- (void)thn_networkRollImageData {
    NSDictionary *requestDic = @{@"name":@"app_fiu_sight_index_slide",
                                 @"size":@"5"};
    self.rollImgRequest = [FBAPI getWithUrlString:URLBannerSlide requestDictionary:requestDic delegate:self];
    [self.rollImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rollArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * rollDic in rollArr) {
            RollImageRow * rollModel = [[RollImageRow alloc] initWithDictionary:rollDic];
            [self.rollList addObject:rollModel];
        }
        [self.homerollView setRollimageView:self.rollList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  点赞
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

//  取消点赞
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

//  关注
- (void)thn_networkBeginFollowUserData:(NSString *)idx {
    self.followRequest = [FBAPI postWithUrlString:URLFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.followRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            
        }

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  取消关注
- (void)thn_networkCancelFollowUserData:(NSString *)idx {
    self.cancelFollowRequest = [FBAPI postWithUrlString:URLCancelFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.cancelFollowRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  收藏
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

//  取消收藏
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

//  精选主题列表
- (void)thn_networkSubjectData {
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"4",
                                 @"fine":@"1",
                                 @"sort":@"2"};
    self.subjectRequest = [FBAPI getWithUrlString:URLSubject requestDictionary:requestDic delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *subArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *subDic in subArr) {
            FBSubjectModelRow *subModel = [[FBSubjectModelRow alloc] initWithDictionary:subDic];
            [self.subjectMarr addObject:subModel];
        }
    
        if (self.sceneListMarr.count) {
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.homeTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  专题详情
- (void)thn_networkSubjectInfoData:(NSString *)idx {
    self.subjectInfoRequest = [FBAPI getWithUrlString:URLSubjectView requestDictionary:@{@"id":idx} delegate:self];
    [self.subjectInfoRequest startRequestSuccess:^(FBRequest *request, id result) {

        if (![[[result valueForKey:@"data"] valueForKey:@"type"] isKindOfClass:[NSNull class]]) {
            _subjectType = [[[result valueForKey:@"data"] valueForKey:@"type"] integerValue];
            if (_subjectType == 1) {
                THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
                articleVC.articleDetalid = idx;
                [self.navigationController pushViewController:articleVC animated:YES];
                
            } else if (_subjectType == 2) {
                THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
                activity.activeDetalId = idx;
                [self.navigationController pushViewController:activity animated:YES];
                
            } else if (_subjectType == 3) {
                THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
                cuXiao.cuXiaoDetalId = idx;
                cuXiao.vcType = 1;
                [self.navigationController pushViewController:cuXiao animated:YES];
                
            } else if (_subjectType == 4) {
                THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
                xinPin.xinPinDetalId = idx;
                [self.navigationController pushViewController:xinPin animated:YES];
                
            } else if (_subjectType == 5) {
                THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
                cuXiao.cuXiaoDetalId = idx;
                cuXiao.vcType = 2;
                [self.navigationController pushViewController:cuXiao animated:YES];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//  热门用户推荐
- (void)thn_networkHotUserListData {
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"edit_stick":@"1",
                                 @"sort":@"1",
                                 @"type":@"1"};
    self.hotUserRequest = [FBAPI getWithUrlString:URLHotUserList requestDictionary:requestDic delegate:self];
    [self.hotUserRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *userArr = [[result valueForKey:@"data"] valueForKey:@"users"];
        for (NSDictionary *userDic in userArr) {
            HotUserListUser *userModel = [[HotUserListUser alloc] initWithDictionary:userDic];
            [self.hotUserMarr addObject:userModel];
        }
        
        if (self.hotUserMarr.count && self.sceneListMarr.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_hotUserListIndex];
            [self.homeTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationBottom)];
        }

    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//  删除情境
- (void)thn_networkDeleteScene:(NSString *)idx {
    self.deleteRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":idx} delegate:self];
    [self.deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr removeObjectAtIndex:index];
            [self.sceneIdMarr removeObjectAtIndex:index];
            [self.userIdMarr removeObjectAtIndex:index];
            [self.commentsCountMarr removeObjectAtIndex:index];
            [                                       self.commentsMarr removeObjectAtIndex:index];
            [self.homeTable deleteSections:[NSIndexSet indexSetWithIndex:index + 1] withRowAnimation:(UITableViewRowAnimationFade)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  情景列表
- (void)thn_networkSceneListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@(self.currentpageNum + 1),
                                 @"size":@"10",
                                 @"sort":@"2",
                                 @"fine":@"1"};
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        if (![self.view.subviews containsObject:self.homeTable]) {
            [self thn_setHomeViewUI];
        }
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
            [self.commentsCountMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.commentCount]];
        }
        [self.commentsMarr addObjectsFromArray:[sceneArr valueForKey:@"comments"]];
        [self.homeTable reloadData];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.homeTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        CGPoint tableY = table.contentOffset;
        tableY.y = 0;
        if (table.bounds.origin.y > 0) {
            [UIView animateWithDuration:.3 animations:^{
                table.contentOffset = tableY;
            }];
        }
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    table.mj_header = header;
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self thn_networkSceneListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark 刷新移除旧数据
- (void)loadNewData {
    self.currentpageNum = 0;
    [self.rollList removeAllObjects];
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    [self.commentsMarr removeAllObjects];
    [self.subjectMarr removeAllObjects];
    [self.commentsCountMarr removeAllObjects];
    [self.hotUserMarr removeAllObjects];
    [self thn_networkSceneListData];
    [self thn_networkRollImageData];
    [self thn_networkSubjectData];
    [self thn_networkHotUserListData];
}

#pragma mark - 设置视图UI
- (void)thn_setHomeViewUI {
    [self.view addSubview:self.homeTable];
}

#pragma mark - 初始化轮播图&点击跳转事件
- (FBRollImages *)homerollView {
    if (!_homerollView) {
        _homerollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.56)];
        _homerollView.navVC = self.navigationController;
        
        __weak __typeof(self)weakSelf = self;
        _homerollView.getProjectType = ^ (NSString *idx) {
            [weakSelf thn_networkSubjectInfoData:idx];
        };
    }
    return _homerollView;
}

#pragma mark - 首页推荐的热门用户列表
- (UIView *)hotUserView {
    if (!_hotUserView) {
        _hotUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _hotUserCellHeight)];
        _hotUserView.backgroundColor = [UIColor whiteColor];
        [_hotUserView addSubview:self.hotUserList];
    }
    return _hotUserView;
}

- (THNHotUserView *)hotUserList {
    if (!_hotUserList) {
        THNHotUserFlowLayout *flowLayout = [[THNHotUserFlowLayout alloc] init];
        _hotUserList = [[THNHotUserView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, _hotUserCellHeight - 15) collectionViewLayout:flowLayout];
        _hotUserList.nav = self.navigationController;
    }
    return _hotUserList;
}

#pragma mark - tableView
- (UITableView *)homeTable {
    if (!_homeTable) {
        _homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStyleGrouped)];
        _homeTable.delegate = self;
        _homeTable.dataSource = self;
        _homeTable.tableHeaderView = self.homerollView;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.backgroundColor = [UIColor colorWithHexString:WHITE_COLOR];
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addMJRefresh:_homeTable];
    }
    return _homeTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneListMarr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 7;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(self)weakSelf = self;
    
    if (indexPath.section == 0) {
        HomeThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellId];
        cell = [[HomeThemeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:themeCellId];
        if (self.subjectMarr.count) {
            [cell setThemeModelArr:self.subjectMarr];
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else {
        if (indexPath.row == 0) {
            THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section - 1] userId:[self getLoginUserID] isLogin:[self isUserLogin]];
                
                cell.beginFollowTheUserBlock = ^(NSString *userId) {
                    [weakSelf beginFollowUser:userId];
                };
                
                cell.cancelFollowTheUserBlock = ^(NSString *userId) {
                    [weakSelf cancelFollowUser:userId];
                };
            }
            cell.vc = self;
            cell.nav = self.navigationController;
            return cell;

        } else if (indexPath.row == 1) {
            THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
            cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section - 1]];
            }
            cell.vc = self;
            cell.nav = self.navigationController;
            return cell;
            
        } else if (indexPath.row == 2) {
            THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
            cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setSceneData:self.sceneListMarr[indexPath.section - 1]
                               isLogin:[self isUserLogin]
                            isUserSelf:[self isLoginUserSelf:self.userIdMarr[indexPath.section - 1]]];
                
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
                
//                cell.refreshData = ^ () {
//                    [weakSelf.homeTable.mj_header beginRefreshing];
//                };
            }
            cell.vc = self;
            cell.nav = self.navigationController;
            return cell;
            
        } else if (indexPath.row == 3) {
            THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
            cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section - 1]];
                _contentHigh = cell.cellHigh;
                _defaultContentHigh = cell.defaultCellHigh;
            }
            cell.nav = self.navigationController;
            return cell;
            
        } else if (indexPath.row == 4) {
            if ([self.commentsMarr[indexPath.section - 1] count] > 0) {
                THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
                cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
                [cell thn_setScenecommentData:self.commentsMarr[indexPath.section - 1][0]];
                _commentHigh = cell.cellHigh;
                return cell;
            
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
                return cell;
            }
            
        } else if (indexPath.row == 5) {
            if ([self.commentsMarr[indexPath.section - 1] count] > 1) {
                THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
                cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
                [cell thn_setScenecommentData:self.commentsMarr[indexPath.section - 1][1]];
                _commentHigh = cell.cellHigh;
                return cell;
                
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
                return cell;
            }
            
        } else if (indexPath.row == 6) {
            if ([self.commentsMarr[indexPath.section - 1] count] > 1) {
                THNLookAllCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allCommentsCellId];
                cell = [[THNLookAllCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:allCommentsCellId];
                [cell thn_setAllCommentCountData:[self.commentsCountMarr[indexPath.section - 1] integerValue]];
                return cell;
                
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
                return cell;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
        
    } else {
        if (indexPath.row == 0) {
                return 50;
        } else if (indexPath.row == 1) {
            return SCREEN_WIDTH;
        } else if (indexPath.row == 2) {
            return 40;
        } else if (indexPath.row == 3) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                return _contentHigh;
            } else {
                return _defaultContentHigh;
            }
        } else if (indexPath.row == 4) {
            if ([self.commentsMarr[indexPath.section -1] count] > 0) {
                return _commentHigh;
            } else {
                return 0.01f;
            }
        } else if (indexPath.row == 5) {
            if ([self.commentsMarr[indexPath.section -1] count] > 1) {
                return _commentHigh;
            } else {
                return 0.01f;
            }
            
        } else if (indexPath.row == 6) {
            if ([self.commentsMarr[indexPath.section -1] count] > 1) {
                return 35.0f;
            } else {
                return 0.01f;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.nav = self.navigationController;
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"shouye_zhuti"
                                      withTitle:NSLocalizedString(@"Home_Theme", nil)
                                   withSubtitle:@""
                                  withRightMore:@""
                                   withMoreType:1];
    } else if (section == 1) {
        [self.headerView addGroupHeaderViewIcon:@"shouye_jingxuan"
                                      withTitle:NSLocalizedString(@"Home_Scene", nil)
                                   withSubtitle:@""
                                  withRightMore:@""
                                   withMoreType:0];
    }
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _hotUserListIndex) {
        if (self.hotUserMarr.count) {
            [self.hotUserList thn_setHotUserListData:self.hotUserMarr];
            return self.hotUserView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 44.0f;
    } else {
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == _hotUserListIndex) {
        if (self.hotUserMarr.count) {
            return _hotUserCellHeight;
        } else {
            return 15.0f;
        }
    } else {
        return 15;
    }
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section != 0) {
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        [UIView animateWithDuration:0.5 animations:^{
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        }];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        if (indexPath.row == 3) {
            if (_contentHigh > 65.0f) {
                if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                    _selectedIndexPath = nil;
                } else {
                    _selectedIndexPath = indexPath;
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } else if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) {
            CommentNViewController * commentVC = [[CommentNViewController alloc] init];
            commentVC.targetId = self.sceneIdMarr[indexPath.section - 1];
            commentVC.sceneUserId = self.userIdMarr[indexPath.section - 1];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.homeTable) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.homeTable) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            _rollDown = YES;
        }else{
            _rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.homeTable) {
        CGRect tabBarRect = self.tabBarController.tabBar.frame;
        CGRect tableRect = self.homeTable.frame;
        if (_rollDown == YES) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 20, SCREEN_WIDTH, 49);
            tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [UIView animateWithDuration:.3 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                self.homeTable.frame = tableRect;
                self.navView.alpha = 0;
                self.leftBtn.alpha = 0;
                self.rightBtn.alpha = 0;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
            }];
            
        } else if (_rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            tableRect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
            [UIView animateWithDuration:.3 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                self.homeTable.frame = tableRect;
                self.navView.alpha = 1;
                self.leftBtn.alpha = 1;
                self.rightBtn.alpha = 1;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
            }];
        }
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.delegate = self;
    self.baseTable = self.homeTable;
    self.navViewTitle.hidden = YES;
    [self thn_addNavLogoImage];
    [self thn_addBarItemLeftBarButton:@"" image:@"shouye_search"];
    [self thn_addBarItemRightBarButton:@"" image:@"icon_shouye_dingyue"];
}

- (void)thn_leftBarItemSelected {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.index = 0;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    if ([self isUserLogin]) {
        THNSubscribeViewController * sceneSubVC = [[THNSubscribeViewController alloc] init];
        [self.navigationController pushViewController:sceneSubVC animated:YES];
    } else {
        [self openUserLoginVC];
    }
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"HomeLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"HomeLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"shouye_sousuo",@"shouye_dingyue"]];
    }
}

#pragma mark - 注册观察者接收消息通知
- (void)thn_registerNSNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHotUserListData:) name:@"reloadHotUserListData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followHotUserAction:) name:@"followHotUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFollowHotUserAction:) name:@"cancelFollowHotUser" object:nil];
}

//  删除全部热门用户
- (void)reloadHotUserListData:(NSNotification *)reload {
    _hotUserCellHeight = 15.0f;
    NSIndexSet *hotUserIndexSet = [NSIndexSet indexSetWithIndex:_hotUserListIndex];
    [self.homeTable reloadSections:hotUserIndexSet withRowAnimation:(UITableViewRowAnimationFade)];
}

//  关注热门用户
- (void)followHotUserAction:(NSNotification *)userId {
    [self thn_networkBeginFollowUserData:[userId object]];
}

//  取消关注热门用户
- (void)cancelFollowHotUserAction:(NSNotification *)userId {
    [self thn_networkCancelFollowUserData:[userId object]];
}

//  关注用户
- (void)beginFollowUser:(NSString *)userId {
    NSInteger index = [self.userIdMarr indexOfObject:userId];
    [[self.sceneListMarr valueForKey:@"user"][index] setValue:@"1" forKey:@"isFollow"];
    [self thn_networkBeginFollowUserData:userId];
}

//  取消关注用户
- (void)cancelFollowUser:(NSString *)userId {
    NSInteger index = [self.userIdMarr indexOfObject:userId];
    [[self.sceneListMarr valueForKey:@"user"][index] setValue:@"0" forKey:@"isFollow"];
    [self thn_networkCancelFollowUserData:userId];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadHotUserListData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"followHotUser" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelFollowHotUser" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 初始化数组
- (NSMutableArray *)rollList {
    if (!_rollList) {
        _rollList = [NSMutableArray array];
    }
    return _rollList;
}

- (NSMutableArray *)subjectMarr {
    if (!_subjectMarr) {
        _subjectMarr = [NSMutableArray array];
    }
    return _subjectMarr;
}

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

- (NSMutableArray *)commentsMarr {
    if (!_commentsMarr) {
        _commentsMarr = [NSMutableArray array];
    }
    return _commentsMarr;
}

- (NSMutableArray *)commentsCountMarr {
    if (!_commentsCountMarr) {
        _commentsCountMarr = [NSMutableArray array];
    }
    return _commentsCountMarr;
}

- (NSMutableArray *)hotUserMarr {
    if (!_hotUserMarr) {
        _hotUserMarr = [NSMutableArray array];
    }
    return _hotUserMarr;
}

@end
