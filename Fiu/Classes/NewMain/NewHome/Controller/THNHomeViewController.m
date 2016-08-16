//
//  THNHomeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "SearchViewController.h"
#import "SceneSubscribeViewController.h"
#import "HomeThemeTableViewCell.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNSceneCommentTableViewCell.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "HomeSceneListRow.h"
#import "CommentRow.h"
#import "CommentNViewController.h"

static NSString *const URLBannerSlide = @"/gateway/slide";
static NSString *const URLSceneList = @"/scene_sight/";

static NSString *const themeCellId = @"ThemeCellId";
static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const commentsCellId = @"CommentsCellId";
static NSString *const twoCommentsCellId = @"TwoCommentsCellId";

@interface THNHomeViewController () {
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _commentHigh;
    NSString *_sceneId;
    NSString *_userId;
}

@end

@implementation THNHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
    [self thn_setHomeViewUI];
    [self thn_networkRollImageData];
    [self thn_networkSceneListData];
}

#pragma mark - 网络请求
#pragma mark 轮播图
- (void)thn_networkRollImageData {
    self.rollImgRequest = [FBAPI getWithUrlString:URLBannerSlide requestDictionary:@{@"name":@"app_fiu_product_index_slide", @"size":@"5"} delegate:self];
    [self.rollImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * rollArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * rollDic in rollArr) {
            RollImageRow * rollModel = [[RollImageRow alloc] initWithDictionary:rollDic];
            [self.rollList addObject:rollModel];
        }
        [self.homerollView setRollimageView:self.rollList];
        
    } failure:^(FBRequest *request, NSError *error) {

        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)thn_networkSceneListData {
    [SVProgressHUD show];
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@10, @"sort":@"0"} delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
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

- (void)loadNewData {
    self.currentpageNum = 0;
    [self.rollList removeAllObjects];
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self.commentsMarr removeAllObjects];
    [self thn_networkSceneListData];
    [self thn_networkRollImageData];
}

#pragma mark - 初始化数据
- (NSMutableArray *)rollList {
    if (!_rollList) {
        _rollList = [NSMutableArray array];
    }
    return _rollList;
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

#pragma mark - 设置视图UI
- (void)thn_setHomeViewUI {
    [self.view addSubview:self.homeTable];
}

- (FBRollImages *)homerollView {
    if (!_homerollView) {
        _homerollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT)];
        _homerollView.navVC = self.navigationController;
    }
    return _homerollView;
}

#pragma mark tableView
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
        return 6;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellId];
        cell = [[HomeThemeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:themeCellId];
        return cell;
        
    } else {
        if (indexPath.row == 0) {
            THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section - 1]];
            }
            return cell;
            
        } else if (indexPath.row == 1) {
            THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
            cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section - 1]];
            }
            return cell;
            
        } else if (indexPath.row == 2) {
            THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
            cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
            if (self.sceneListMarr.count) {
                [cell thn_setSceneData:self.sceneListMarr[indexPath.section - 1]];
            }
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
    } else if (section ==1) {
        [self.headerView addGroupHeaderViewIcon:@"shouye_jingxuan"
                                      withTitle:NSLocalizedString(@"Home_Scene", nil)
                                   withSubtitle:@""
                                  withRightMore:@""
                                   withMoreType:2];
    }
    return self.headerView;
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
    } else {
        return 15;
    }
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
    if (indexPath.section != 0) {
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
            commentVC.targetId = self.sceneIdMarr[indexPath.section - 1];
            commentVC.sceneUserId = self.userIdMarr[indexPath.section - 1];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.baseTable = self.homeTable;
    [self thn_addNavLogoImage];
    [self thn_addBarItemLeftBarButton:@"" image:@"shouye_search"];
    [self thn_addBarItemRightBarButton:@"" image:@"shouye_dingyue"];
}

- (void)thn_leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 0;
    searchVC.beginSearch = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    [SVProgressHUD showSuccessWithStatus:@"订阅列表"];
//    SceneSubscribeViewController * sceneSubVC = [[SceneSubscribeViewController alloc] init];
//    [self.navigationController pushViewController:sceneSubVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"homeLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"homeLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"guide_home",@"Guide_index",@"guide-fiu",@"guide-personal"]];
    }
}

@end
