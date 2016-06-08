//
//  FiuSceneViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuSceneViewController.h"
#import "FiuUserInfoTableViewCell.h"
#import "ContentAndTagTableViewCell.h"
#import "LikePeopleTableViewCell.h"
#import "SceneListTableViewCell.h"
#import "SceneInfoViewController.h"
#import "PictureToolViewController.h"
#import "FiuSceneInfoData.h"
#import "NoHaveSceneTableViewCell.h"
#import "NearChangViewController.h"

static NSString *const URLFiuSceneInfo = @"/scene_scene/view";
static NSString *const URLFiuSceneList = @"/scene_sight/";
static NSString *const URLSuFiuScene = @"/favorite/ajax_subscription";
static NSString *const URLCancelSu = @"/favorite/ajax_cancel_subscription";
static NSString *const URLLikeScenePeople = @"/favorite";

@interface FiuSceneViewController () {
    BOOL    _isHave;     //  是否有场景
}

@pro_strong FiuSceneInfoData            *   fiuSceneData;
@pro_strong NSMutableArray              *   sceneListMarr;
@pro_strong NSMutableArray              *   sceneIdMarr;
@pro_strong NSMutableArray              *   suPeopleMarr;     //  点赞的人
/**城市图标加手势 */
@property(nonatomic,strong) UITapGestureRecognizer *cityTap;

@end

@implementation FiuSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSceneInfoViewUI];
    [self networkRequestData];
    [self networkLikePeopleData];
    self.currentpageNum = 0;
    [self networkFiuSceneListData];
}


#pragma mark - 网络请求
#pragma mark 情景详情
- (void)networkRequestData {
    [SVProgressHUD show];
    self.fiuSceneRequest = [FBAPI getWithUrlString:URLFiuSceneInfo requestDictionary:@{@"id":self.fiuSceneId} delegate:self];
    [self.fiuSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝ 情景 %@", result);
        self.fiuSceneData = [[FiuSceneInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self.fiuSceneTable reloadData];
        [self requestIsLastData:self.fiuSceneTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 情景中的场景列表
- (void)networkFiuSceneListData {
    [SVProgressHUD show];
    self.fiuSceneListRequest = [FBAPI getWithUrlString:URLFiuSceneList requestDictionary:@{@"scene_id":self.fiuSceneId, @"stick":@"0", @"size":@"10",@"page":@(self.currentpageNum + 1)} delegate:self];
    [self.fiuSceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        
        if (self.sceneListMarr.count > 0) {
            _isHave = YES;
        }
        
        [self.fiuSceneTable reloadData];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.fiuSceneTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 订阅此情景的用户
- (void)networkLikePeopleData {
    [self.suPeopleMarr removeAllObjects];
    self.suPeopleRequest = [FBAPI postWithUrlString:URLLikeScenePeople requestDictionary:@{@"type":@"scene", @"event":@"subscription", @"page":@"1" , @"size":@"10000", @"id":self.fiuSceneId} delegate:self];
    [self.suPeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * likePeopleArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * likePeopleDic in likePeopleArr) {
            LikeOrSuPeopleRow * likePeopleModel = [[LikeOrSuPeopleRow alloc] initWithDictionary:likePeopleDic];
            [self.suPeopleMarr addObject:likePeopleModel];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark 订阅情景
- (void)networkSuFiuSceneData:(UIButton *)button {
    if (button.selected == NO) {
        self.suFiuSceneRequest = [FBAPI postWithUrlString:URLSuFiuScene requestDictionary:@{@"id":self.fiuSceneId} delegate:self];
        [self.suFiuSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            button.selected = YES;
            [self networkRequestData];
            [self networkLikePeopleData];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
        
    } else if (button.selected == YES) {
        self.cancelSuRequest = [FBAPI postWithUrlString:URLCancelSu requestDictionary:@{@"id":self.fiuSceneId} delegate:self];
        [self.cancelSuRequest startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            button.selected = NO;
            [self networkRequestData];
            [self networkLikePeopleData];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
    
}

#pragma mark 判断是否为最后一条数据
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
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkFiuSceneListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -
- (void)setSceneInfoViewUI {
    [self.view addSubview:self.fiuSceneTable];
    [self.view sendSubviewToBack:self.fiuSceneTable];
}

#pragma mark - 设置情景详情的视图
- (UITableView *)fiuSceneTable {
    if (!_fiuSceneTable) {
        _fiuSceneTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _fiuSceneTable.delegate = self;
        _fiuSceneTable.dataSource = self;
        _fiuSceneTable.showsVerticalScrollIndicator = NO;
        _fiuSceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fiuSceneTable.backgroundColor = [UIColor whiteColor];
        
        [self addMJRefresh:_fiuSceneTable];
    }
    return _fiuSceneTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        if (_isHave == NO) {
            return 1;
        } else {
            return self.sceneListMarr.count;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * userInfoCellId = @"userInfoCellId";
            FiuUserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            if (cell == nil) {
                cell = [[FiuUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            }
            [cell setFiuSceneInfoData:self.fiuSceneData];
            cell.city.userInteractionEnabled = YES;
            [cell.city addGestureRecognizer:self.cityTap];
            [cell.goodBtn addTarget:self action:@selector(networkSuFiuSceneData:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * contentCellId = @"contentCellId";
            ContentAndTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
            if (cell == nil) {
                cell = [[ContentAndTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentCellId];
            }
            cell.nav = self.navigationController;
            [cell setFiuSceneDescription:self.fiuSceneData];
            return cell;
            
        } else if (indexPath.row == 2) {
            static NSString * likePeopleCellId = @"likePeopleCellId";
            LikePeopleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:likePeopleCellId];
            if (cell == nil) {
                cell = [[LikePeopleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:likePeopleCellId];
            }
            cell.nav = self.navigationController;
            [cell setLikeOrSuPeopleData:self.suPeopleMarr];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (_isHave == YES) {
            static NSString * fiuSceneTableViewCellID = @"fiuSceneTableViewCellID";
            SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneTableViewCellID];
            if (!cell) {
                cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneTableViewCellID];
            }
            [cell setHomeSceneListData:self.sceneListMarr[indexPath.row]];
            return cell;
        
        } else {
            static NSString * noHaveSceneTableViewCell = @"NoHaveSceneTableViewCell";
            NoHaveSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:noHaveSceneTableViewCell];
            if (!cell) {
                cell = [[NoHaveSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:noHaveSceneTableViewCell];
            }
            return cell;
        }
        return nil;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return SCREEN_HEIGHT;
            
        } else if (indexPath.row == 1) {
            ContentAndTagTableViewCell * cell = [[ContentAndTagTableViewCell alloc] init];
            [cell getContentCellHeight:self.fiuSceneData.des];
            return cell.cellHeight;
        }  else if (indexPath.row == 2) {
            LikePeopleTableViewCell * cell = [[LikePeopleTableViewCell alloc] init];
            [cell getCellHeight:self.suPeopleMarr];
            return cell.cellHeight;
        }
        
    } else if (indexPath.section == 1) {
        if (_isHave == YES) {
            return SCREEN_HEIGHT + 5;
        } else {
            return 250;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    
    if (section == 1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"此情景下的场景" withSubtitle:@""];
    }
    
    return self.headerView;
}

#pragma mark - 跳转到场景的详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (_isHave == YES) {
            SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
            sceneInfoVC.sceneId = self.sceneIdMarr[indexPath.row];
            [self.navigationController pushViewController:sceneInfoVC animated:YES];
       
        } else {
            PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
            pictureToolVC.createType = @"scene";
            if (self.fiuSceneId.length > 0) {
                pictureToolVC.fSceneId = self.fiuSceneId;
                pictureToolVC.fSceneTitle = [self.fiuSceneData valueForKey:@"title"];
            }
            [self presentViewController:pictureToolVC animated:YES completion:nil];
        }
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.fiuSceneTable) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.fiuSceneTable) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            self.rollDown = YES;
        }else{
            self.rollDown = NO;
        }
    }
}

-(UITapGestureRecognizer *)cityTap{
    if (!_cityTap) {
        _cityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCityTap:)];
        _cityTap.numberOfTapsRequired = 1;
        _cityTap.numberOfTouchesRequired = 1;
    }
    return _cityTap;
}

-(void)clickCityTap:(UITapGestureRecognizer*)gesture{
    NearChangViewController *vc = [[NearChangViewController alloc] init];
    vc.baseInfo = self.fiuSceneData;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImgisTransparent:YES];
    [self addBarItemRightBarButton:@"" image:@"icon_newScene" isTransparent:YES];
    [self addBarItemLeftBarButton:@"" image:@"icon_back" isTransparent:YES];
}

- (void)leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarItemSelected {
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    pictureToolVC.createType = @"fScene";
    [self presentViewController:pictureToolVC animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark -
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

- (NSMutableArray *)suPeopleMarr {
    if (!_suPeopleMarr) {
        _suPeopleMarr = [NSMutableArray array];
    }
    return _suPeopleMarr;
}



@end
