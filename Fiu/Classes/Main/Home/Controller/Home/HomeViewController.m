//
//  HomeViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeViewController.h"
#import "SceneListTableViewCell.h"
#import "SceneInfoViewController.h"
#import "SearchViewController.h"
#import "SceneSubscribeViewController.h"
#import "HomeSceneListRow.h"
#import "CommentRow.h"
#import "FBRefresh.h"

static NSString *const URLSceneList = @"/scene_sight/";

@interface HomeViewController ()

@pro_strong NSMutableArray      *   sceneListMarr;
@pro_strong NSMutableArray      *   sceneIdMarr;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setFirstAppStart];
    [self setNavigationViewUI];
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteScene) name:@"deleteScene" object:nil];
}

- (void)deleteScene {
    [self.homeTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentpageNum = 0;
    [self networkRequestData];
    [self.view addSubview:self.homeTableView];
}

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@10, @"sort":@"2",@"fine":@"1"} delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        [self.homeTableView reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.homeTableView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  判断是否为最后一条数据
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
            [self networkRequestData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

- (void)loadNewData {
    self.currentpageNum = 0;
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self networkRequestData];
}

#pragma mark - 加载首页表格
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.pagingEnabled = YES;
        [self addMJRefresh:_homeTableView];
    }
    return _homeTableView;
}

#pragma mark - tableView Delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * homeTableViewCellID = @"homeTableViewCellID";
    SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:homeTableViewCellID];
    cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:homeTableViewCellID];
    if (self.sceneListMarr.count) {
        [cell setHomeSceneListData:self.sceneListMarr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT;
}

#pragma mark - 跳转到场景的详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sceneListMarr.count)  {
        SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
        sceneInfoVC.sceneId = self.sceneIdMarr[indexPath.row];
        [self.navigationController pushViewController:sceneInfoVC animated:YES];
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.homeTableView) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.homeTableView) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            self.rollDown = YES;
        }else{
            self.rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.homeTableView) {
        CGRect tabBarRect = self.tabBarController.tabBar.frame;
        if (self.rollDown == YES) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 20, SCREEN_WIDTH, 49);
            [UIView animateWithDuration:.4 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                self.leftBtn.alpha = 0;
                self.rightBtn.alpha = 0;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
            }];
            
        } else if (self.rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            [UIView animateWithDuration:.4 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                self.leftBtn.alpha = 1;
                self.rightBtn.alpha = 1;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
            }];
        }
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImgisTransparent:YES];
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search" isTransparent:YES];
    [self addBarItemRightBarButton:@"" image:@"Nav_Concern" isTransparent:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 0;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    SceneSubscribeViewController * sceneSubVC = [[SceneSubscribeViewController alloc] init];
    [self.navigationController pushViewController:sceneSubVC animated:YES];
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"homeLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"homeLaunch"];
        [self setMoreGuideImgForVC:@[@"guide_home",@"Guide_index"]];
    }
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteScene" object:nil];
}

@end

