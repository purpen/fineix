//
//  DiscoverViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FiuSceneTableViewCell.h"
#import "SceneListTableViewCell.h"
#import "FiuTagTableViewCell.h"
#import "FiuPeopleTableViewCell.h"
#import "FBCityViewController.h"
#import "SearchViewController.h"
#import "SceneInfoViewController.h"
#import "FiuSceneRow.h"
#import "HotTagsData.h"
#import "FiuPeopleUser.h"
#import "FiuPeopleView.h"
#import "HomePageViewController.h"
#import "UIImageView+SDWedImage.h"

static NSString *const URLDiscoverSlide = @"/gateway/slide";
static NSString *const URLFiuScene = @"/scene_scene/";
static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLTagS = @"/scene_tags/getlist";
static NSString *const URLFiuPeople = @"/user/find_user";

@interface DiscoverViewController()

@pro_strong NSMutableArray              *   fiuSceneList;
@pro_strong NSMutableArray              *   fiuSceneIdList;
@pro_strong NSMutableArray              *   sceneList;
@pro_strong NSMutableArray              *   sceneIdList;
@pro_strong NSMutableArray              *   tagsList;
@pro_strong NSMutableArray              *   rollList;
@pro_strong NSMutableArray              *   fiuPeopleList;

@property(nonatomic,strong) FiuPeopleView *fiuView;

@end

@implementation DiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
    [self setFirstAppStart];
    //  frome #import "ReleaseViewController.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeTable) name:@"refreshHomeList" object:nil];
}

#pragma mark - 刷新列表
- (void)refreshHomeTable {
    [self.discoverTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkRollImgData];
    [self networkTagsListData];
    [self networkFiuSceneData];
    self.currentpageNum = 0;
    [self networkSceneListData];
    [self networkFiuPeopleData];
    
}

#pragma mark - 网络请求
#pragma mark 轮播图
- (void)networkRollImgData {
    self.rollImgRequest = [FBAPI getWithUrlString:URLDiscoverSlide requestDictionary:@{@"name":@"app_fiu_sight_index_slide"} delegate:self];
    [self.rollImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * rollArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * rollDic in rollArr) {
            RollImageRow * rollModel = [[RollImageRow alloc] initWithDictionary:rollDic];
            [self.rollList addObject:rollModel];
        }
        [self.rollView setRollimageView:self.rollList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 最Fiu伙伴
- (void)networkFiuPeopleData {
    self.fiuPeopleRequest = [FBAPI getWithUrlString:URLFiuPeople requestDictionary:@{@"page":@"1", @"size":@"50", @"sort":@"1"} delegate:self];
    [self.fiuPeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        self.fiuPeopleList = [NSMutableArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"users"]];
        for (int i = 0; i<_fiuView.subviews.count; i++) {
            UIButton *btn = _fiuView.subviews[i];
            btn.tag = i;
            if (self.fiuPeopleList.count != 0) {
                FiuPeopleUser * user = [[FiuPeopleUser alloc] initWithDictionary:self.fiuPeopleList[btn.tag]];
                UIImageView * headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.bounds.size.width, btn.bounds.size.width)];
                [headerImg downloadImage:user.mediumAvatarUrl place:[UIImage imageNamed:@""]];
                btn.layer.borderWidth = 1.0f;
                btn.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:.7].CGColor;
                [btn addSubview:headerImg];
                [btn addTarget:self action:@selector(clickUserHead:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self.discoverTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 标签列表
- (void)networkTagsListData {
    self.tagsRequest = [FBAPI getWithUrlString:URLTagS requestDictionary:@{@"is_hot":@"1", @"sort":@"2", @"page":@"1", @"size":@"50"} delegate:self];
    [self.tagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * tagsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * tagsDic in tagsArr) {
            HotTagsRow * tagsModel = [[HotTagsRow alloc] initWithDictionary:tagsDic];
            [self.tagsList addObject:tagsModel];
        }
        [self.discoverTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 情景列表
- (void)networkFiuSceneData {
    [SVProgressHUD show];
    self.fiuSceneRequest = [FBAPI getWithUrlString:URLFiuScene requestDictionary:@{@"sort":@"2",@"page":@"1",@"size":@"10"} delegate:self];
    [self.fiuSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * fiuSceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * fiuSceneDic in fiuSceneArr) {
            FiuSceneRow * fiuSceneModel = [[FiuSceneRow alloc] initWithDictionary:fiuSceneDic];
            [self.fiuSceneList addObject:fiuSceneModel];
            [self.fiuSceneIdList addObject:[NSString stringWithFormat:@"%zi", fiuSceneModel.idField]];
        }
        [self.discoverTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 场景列表
- (void)networkSceneListData {
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"sort":@"0", @"size":@"10", @"page":@(self.currentpageNum + 1)} delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self setDiscoverViewUI];
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneList addObject:homeSceneModel];
            [self.sceneIdList addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        [self.discoverTableView reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        if (self.totalPageNum > 1) {
            [self addMJRefresh:self.discoverTableView];
            [self requestIsLastData:self.discoverTableView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
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

#pragma mark 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkSceneListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置视图的UI
- (void)setDiscoverViewUI {
    [self.view addSubview:self.discoverTableView];
}

#pragma mark - 顶部轮播图
- (FBRollImages *)rollView {
    if (!_rollView) {
        _rollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollView.navVC = self.navigationController;
    }
    return _rollView;
}

#pragma mark - tableView
- (UITableView *)discoverTableView {
    if (!_discoverTableView) {
        _discoverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStyleGrouped)];
        _discoverTableView.delegate = self;
        _discoverTableView.dataSource = self;
        _discoverTableView.showsVerticalScrollIndicator = NO;
        _discoverTableView.tableHeaderView = self.rollView;
        _discoverTableView.backgroundColor = [UIColor whiteColor];
        _discoverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _discoverTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self clearMarrData];
            [self networkRollImgData];
            [self networkTagsListData];
            [self networkFiuSceneData];
            self.currentpageNum = 0;
            [self networkSceneListData];
            [self networkFiuPeopleData];
        }];
    }
    return _discoverTableView;
}

#pragma mark - tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.sceneList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            static NSString * fiuPeopleCellId = @"FiuPeopleCellId";
//            FiuPeopleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuPeopleCellId];
//            if (!cell) {
//                cell = [[FiuPeopleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuPeopleCellId];
//            }
//            [cell setFiuPeopleData:self.fiuPeopleList withType:0];
//            cell.nav = self.navigationController;
//            return cell;
            
            static NSString *fiuPeopleCellId = @"FiuPeople";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fiuPeopleCellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fiuPeopleCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.contentView addSubview:self.fiuView];
            [_fiuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 155/667.0*SCREEN_HEIGHT));
                make.left.mas_equalTo(cell.mas_left);
                make.top.mas_equalTo(cell.mas_top);
            }];
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * fiuSceneTagCellId = @"fiuSceneTagCellId";
            FiuTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneTagCellId];
            cell = [[FiuTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneTagCellId];
            [cell setHotTagsData:self.tagsList];
            cell.nav = self.navigationController;
            return cell;
        }
    
    } else if (indexPath.section == 1) {
        static NSString * fiuSceneCellId = @"fiuSceneCellId";
        FiuSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneCellId];
        if (!cell) {
            cell = [[FiuSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneCellId];
        }
        [cell setFiuSceneList:self.fiuSceneList idMarr:self.fiuSceneIdList];
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString * sceneListCellId = @"sceneListCellId";
        SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sceneListCellId];
        if (!cell) {
            cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneListCellId];
        }
        [cell setHomeSceneListData:self.sceneList[indexPath.row]];
        return cell;
    }
    
    return nil;
}

-(FiuPeopleView *)fiuView{
    if (!_fiuView) {
        _fiuView = [FiuPeopleView getFiuPeopleView];
    }
    return _fiuView;
}

-(void)clickUserHead:(UIButton*)sender{
    HomePageViewController * peopleHomeVC = [[HomePageViewController alloc] init];
    peopleHomeVC.isMySelf = NO;
    peopleHomeVC.type = @2;
    FiuPeopleUser * user = [[FiuPeopleUser alloc] initWithDictionary:self.fiuPeopleList[sender.tag]];
    peopleHomeVC.userId = [NSString stringWithFormat:@"%zi",user.idField];
    [self.navigationController pushViewController:peopleHomeVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 155/667.0*SCREEN_HEIGHT;
        } else if (indexPath.row == 1) {
            return 80;
        }
        
    } else if (indexPath.section == 1) {
        return 266.5;
        
    } else if (indexPath.section == 2) {
        return SCREEN_HEIGHT + 5;
        
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.nav = self.navigationController;
    
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"Group_friend" withTitle:@"最Fiu伙伴" withSubtitle:@"[越喜欢头像越大]"];
    } else if (section ==1) {
        [self.headerView addLookMoreBtn];
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"最Fiu情景" withSubtitle:@"[我的地盘我收益]"];
    } else if (section == 2) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"最Fiu场景" withSubtitle:@"[发现不一样]"];
    }
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 跳转场景页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        SceneInfoViewController * sceneVC = [[SceneInfoViewController alloc] init];
        sceneVC.sceneId = self.sceneIdList[indexPath.row];
        [self.navigationController pushViewController:sceneVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImgisTransparent:NO];
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search" isTransparent:NO];
    [self addBarItemRightBarButton:@"" image:@"Nav_Location" isTransparent:NO];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    FBCityViewController * cityVC = [[FBCityViewController alloc] init];
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"discoverLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"discoverLaunch"];
        [self setGuideImgForVC:@"guide-scene"];
    }
}

- (NSMutableArray *)fiuSceneList {
    if (!_fiuSceneList) {
        _fiuSceneList = [NSMutableArray array];
    }
    return _fiuSceneList;
}

- (NSMutableArray *)fiuPeopleList {
    if (!_fiuPeopleList) {
        _fiuPeopleList = [NSMutableArray array];
    }
    return _fiuPeopleList;
}

- (NSMutableArray *)fiuSceneIdList {
    if (!_fiuSceneIdList) {
        _fiuSceneIdList = [NSMutableArray array];
    }
    return _fiuSceneIdList;
}

- (NSMutableArray *)sceneList {
    if (!_sceneList) {
        _sceneList = [NSMutableArray array];
    }
    return _sceneList;
}

- (NSMutableArray *)sceneIdList {
    if (!_sceneIdList) {
        _sceneIdList = [NSMutableArray array];
    }
    return _sceneIdList;
}

- (NSMutableArray *)tagsList {
    if (!_tagsList) {
        _tagsList = [NSMutableArray array];
    }
    return _tagsList;
}

- (NSMutableArray *)rollList {
    if (!_rollList) {
        _rollList = [NSMutableArray array];
    }
    return _rollList;
}

//
- (void)clearMarrData {
    [self.fiuPeopleList removeAllObjects];
    [self.fiuSceneList removeAllObjects];
    [self.fiuSceneIdList removeAllObjects];
    [self.sceneList removeAllObjects];
    [self.sceneIdList removeAllObjects];
    [self.tagsList removeAllObjects];
    [self.rollList removeAllObjects];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshHomeTable" object:nil];
}

@end
