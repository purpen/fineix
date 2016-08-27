//
//  THNSceneListViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneListViewController.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNSceneCommentTableViewCell.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "HomeSceneListRow.h"
#import "CommentRow.h"
#import "FBSubjectModelRow.h"
#import "CommentNViewController.h"

static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const URLFollowUser = @"/follow/ajax_follow";
static NSString *const URLCancelFollowUser = @"/follow/ajax_cancel_follow";
static NSString *const URLFavorite = @"/favorite/ajax_favorite";

static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const commentsCellId = @"CommentsCellId";
static NSString *const twoCommentsCellId = @"TwoCommentsCellId";

@interface THNSceneListViewController () {
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _commentHigh;
    NSString *_sceneId;
    NSString *_userId;
}

@end

@implementation THNSceneListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setSceneViewUI];
    
    if (self.sceneListId.length != 0) {
        FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/view" requestDictionary:@{
                                                                                               @"id" : self.sceneListId
                                                                                               } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if (result[@"success"]) {
                NSLog(@"情境详情 %@",result);
            }
        } failure:nil];
    }
}

#pragma mark - 网络请求
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
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 关注
- (void)thn_networkFollowSceneData:(NSString *)idx {
    self.followRequest = [FBAPI postWithUrlString:URLFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.followRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.userIdMarr indexOfObject:idx];
            [[self.sceneListMarr valueForKey:@"user"][index] setValue:@"1" forKey:@"isFollow"];
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
            [[self.sceneListMarr valueForKey:@"user"][index] setValue:@"0" forKey:@"isFollow"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 收藏情境
- (void)thn_networkFavoriteData:(NSString *)idx {
    self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//#pragma mark 情景列表
//- (void)thn_networkSceneListData {
//    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@10, @"sort":@"0"} delegate:self];
//    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
//        for (NSDictionary * sceneDic in sceneArr) {
//            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
//            [self.sceneListMarr addObject:homeSceneModel];
//            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
//            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
//        }
//        [self.commentsMarr addObjectsFromArray:[sceneArr valueForKey:@"comments"]];
//        
//        [self.sceneTable reloadData];
//        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
//        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
//        [self requestIsLastData:self.sceneTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
//        
//    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//    }];
//}
//
//- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
//    if (total == 0) {
//        table.mj_footer.state = MJRefreshStateNoMoreData;
//        table.mj_footer.hidden = true;
//    }
//    
//    BOOL isLastPage = (current == total);
//    
//    if (!isLastPage) {
//        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
//            [table.mj_footer resetNoMoreData];
//        }
//    }
//    if (current == total == 1) {
//        table.mj_footer.state = MJRefreshStateNoMoreData;
//        table.mj_footer.hidden = true;
//    }
//    if ([table.mj_header isRefreshing]) {
//        CGPoint tableY = table.contentOffset;
//        tableY.y = 0;
//        if (table.bounds.origin.y > 0) {
//            [UIView animateWithDuration:.3 animations:^{
//                table.contentOffset = tableY;
//            }];
//        }
//        [table.mj_header endRefreshing];
//    }
//    if ([table.mj_footer isRefreshing]) {
//        if (isLastPage) {
//            [table.mj_footer endRefreshingWithNoMoreData];
//        } else  {
//            [table.mj_footer endRefreshing];
//        }
//    }
//}
//
//#pragma mark - 上拉加载 & 下拉刷新
//- (void)addMJRefresh:(UITableView *)table {
//    FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
//        [self loadNewData];
//    }];
//    table.mj_header = header;
//    
//    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (self.currentpageNum < self.totalPageNum) {
//            [self thn_networkSceneListData];
//        } else {
//            [table.mj_footer endRefreshing];
//        }
//    }];
//}
//
//- (void)loadNewData {
//    self.currentpageNum = 0;
//    [self.sceneListMarr removeAllObjects];
//    [self.sceneIdMarr removeAllObjects];
//    [self.commentsMarr removeAllObjects];
//    [self thn_networkSceneListData];
//}

#pragma mark - 设置视图UI
- (void)thn_setSceneViewUI {
    [self.view addSubview:self.sceneTable];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.index];
    [self.sceneTable scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

#pragma mark tableView
- (UITableView *)sceneTable {
    if (!_sceneTable) {
        _sceneTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _sceneTable.delegate = self;
        _sceneTable.dataSource = self;
        _sceneTable.showsVerticalScrollIndicator = NO;
        _sceneTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self addMJRefresh:_sceneTable];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTheScene:) name:@"likeTheScene" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLikeTheScene:) name:@"cancelLikeTheScene" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followTheUser:) name:@"followTheUser" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFollowTheUser:) name:@"cancelFollowTheUser" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteTheScene:) name:@"favoriteTheScene" object:nil];
    }
    return _sceneTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneListMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section]];
        }
        return cell;
        
    } else if (indexPath.row == 1) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section]];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 2) {
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneData:self.sceneListMarr[indexPath.section]];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 3) {
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        if (self.sceneListMarr.count) {
            if (self.sceneListMarr.count) {
                [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section]];
            }
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 4) {
        if ([self.commentsMarr[indexPath.section] count] > 0) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            [cell thn_setScenecommentData:self.commentsMarr[indexPath.section][0]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            return cell;
        }
        
    } else if (indexPath.row == 5) {
        if ([self.commentsMarr[indexPath.section] count] > 1) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            [cell thn_setScenecommentData:self.commentsMarr[indexPath.section][1]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        if ([self.commentsMarr[indexPath.section] count] > 0) {
            return _commentHigh;
        } else {
            return 0.01f;
        }
    } else if (indexPath.row == 5) {
        if ([self.commentsMarr[indexPath.section] count] > 1) {
            return _commentHigh;
        } else {
            return 0.01f;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [UIView animateWithDuration:0.5 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if (_contentHigh > 70.0f) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                _selectedIndexPath = nil;
            } else {
                _selectedIndexPath = indexPath;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } else if (indexPath.row == 4 || indexPath.row == 5) {
        CommentNViewController * commentVC = [[CommentNViewController alloc] init];
//        commentVC.targetId = self.sceneIdMarr[indexPath.section];
//        commentVC.sceneUserId = self.userIdMarr[indexPath.section];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

#pragma mark - 点赞
- (void)likeTheScene:(NSNotification *)idx {
    [self thn_networkLikeSceneData:[idx object]];
}

- (void)cancelLikeTheScene:(NSNotification *)idx {
    [self thn_networkCancelLikeData:[idx object]];
}

#pragma mark - 关注
- (void)followTheUser:(NSNotification *)idx {
    [self thn_networkFollowSceneData:[idx object]];
}

- (void)cancelFollowTheUser:(NSNotification *)idx {
    [self thn_networkCancelFollowData:[idx object]];
}

#pragma mark - 收藏
- (void)favoriteTheScene:(NSNotification *)idx {
    [self thn_networkFavoriteData:[idx object]];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = NSLocalizedString(@"SceneListVC", nil);
    self.delegate = self;
}

#pragma mark - 初始化数据
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

@end
