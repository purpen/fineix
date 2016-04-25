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

#import "HomeSceneListRow.h"

static NSString *const URLSceneList = @"/scene_sight/";

@interface HomeViewController ()

@pro_strong NSMutableArray      *   sceneListMarr;
@pro_strong NSMutableArray      *   sceneIdMarr;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentpageNum = 0;
    
    [self networkRequestData];
    
    [self.view addSubview:self.homeTableView];

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

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    NSDictionary *  requestParams = @{@"page":@(self.currentpageNum + 1), @"size":@10, @"stick":@1};
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestParams delegate:self];
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
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  判断是否为最后一条数据
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

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentpageNum = 0;
        [self networkRequestData];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkRequestData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 加载首页表格
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
    if (!cell) {
        cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:homeTableViewCellID];
    }
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
    SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
    sceneInfoVC.sceneId = self.sceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:sceneInfoVC animated:YES];
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
        UIView * leftBarItem = self.navigationItem.leftBarButtonItem.customView;
        UIView * rightBarItem = self.navigationItem.rightBarButtonItem.customView;
        
        if (self.rollDown == YES) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 20, SCREEN_WIDTH, 49);
            [UIView animateWithDuration:.4 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                leftBarItem.alpha = 0;
                rightBarItem.alpha = 0;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
                self.navigationController.navigationBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
            }];
            
        } else if (self.rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            [UIView animateWithDuration:.4 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                leftBarItem.alpha = 1;
                rightBarItem.alpha = 1;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
            }];
        }
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImg];
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Concern"];
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
    NSLog(@"＊＊＊＊＊＊＊＊＊关注");
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
    }else{
        NSLog(@"已经不是第一次启动了");
    }
}

@end

