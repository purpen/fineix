//
//  SearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsRow.h"
#import "HomeSceneListRow.h"
#import "FiuSceneInfoData.h"

static NSString *const URLSearchList = @"/search/getlist";

@interface SearchViewController ()

@pro_strong NSMutableArray      *   sceneList;      //  场景
@pro_strong NSMutableArray      *   fiuSceneList;   //  情景
@pro_strong NSMutableArray      *   goodsList;      //  商品

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchVcUI];
    
    if (self.keyword.length > 0) {
        self.searchView.searchInputBox.text = self.keyword;
    }
    [self searchRequest:self.searchType withKeyword:self.keyword];

}

#pragma mark - 网络请求
#pragma mark 搜索场景
- (void)networkSearchData:(NSString *)keyword withType:(NSString *)type {
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":@"tag", @"size":@"8", @"page":@(self.currentpageNum + 1), @"t":type , @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"搜索%@", result);
        if ([type isEqualToString:@"7"]) {
            NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * goodsDic in goodsArr) {
                GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
                [self.goodsList addObject:goodsModel];
            }
            NSLog(@"＝＝＝＝＝＝＝ 商品：%@", self.goodsList);
            [self.resultsView.goodsTable reloadData];
            self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
            self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
            if (self.totalPageNum > 1) {
                [self requestIsLastData:self.resultsView.goodsTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
            }

        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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
//    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.currentpageNum = 0;
//        [self networkRequestData];
//    }];
//    
//    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (self.currentpageNum < self.totalPageNum) {
//            [self networkRequestData];
//        } else {
//            [table.mj_footer endRefreshing];
//        }
//    }];
}

#pragma mark - 设置视图UI 
- (void)setSearchVcUI {
    self.titleArr = [NSArray arrayWithObjects:@"场景", @"情景", @"产品", nil];
    
    [self.view addSubview:self.menuView];
    
    [self.view addSubview:self.resultsView];
}

#pragma mark - 搜索情景
- (void)searchRequest:(NSInteger)type withKeyword:(NSString *)keyword {
    [self changeMenuBtnState:type];
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"开始搜索：%@", keyword]];
    
}

#pragma mark - 搜索结果视图
- (SearchResultsRollView *)resultsView {
    if (!_resultsView) {
        _resultsView = [[SearchResultsRollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        [_resultsView setSearchResultTable:self.titleArr];
        _resultsView.nav = self.navigationController;
    }
    return _resultsView;
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(35, 20, SCREEN_WIDTH - 35, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"search", nil);
        _searchView.delegate = self;
        _searchView.line.hidden = YES;
    }
    return _searchView;
}

#pragma mark - 搜索
- (void)beginSearch:(NSString *)searchKeyword {
    if (self.searchType == 0) {
        [self networkSearchData:searchKeyword withType:@"9"];
    } else if (self.searchType == 1) {
        [self networkSearchData:searchKeyword withType:@"8"];
    } else if (self.searchType == 2) {
        [self networkSearchData:searchKeyword withType:@"7"];
    }

    NSLog(@"搜索的关键字：%@  类型：%zi", searchKeyword, self.searchType);
}

#pragma mark - 导航菜单视图
- (SearchMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SearchMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        [_menuView setSearchMenuView:self.titleArr];
    }
    return _menuView;
}

#pragma mark - 改变菜单栏的状态
- (void)SearchMenuSeleted:(NSInteger)index {
    [self searchRequest:index withKeyword:self.searchView.searchInputBox.text];
    
}

//  改变搜索视图位置
- (void)changeMenuBtnState:(NSInteger)index {
    CGPoint rollPoint = self.resultsView.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    self.resultsView.contentOffset = rollPoint;
    
    self.menuView.selectedBtn.selected = NO;
    NSUInteger tag = index + menuBtnTag;
    UIButton * newbtn = (UIButton *)[self.view viewWithTag:tag];
    newbtn.selected = YES;
    self.menuView.selectedBtn = newbtn;
    self.menuView.selectBtnTag = tag;
    [self.menuView changeMenuBottomLinePosition:self.menuView.selectedBtn withIndex:index];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navView addSubview:self.searchView];
    self.navLine.hidden = YES;
}

#pragma mark -
- (NSMutableArray *)sceneList {
    if (!_sceneList) {
        _sceneList = [NSMutableArray array];
    }
    return _sceneList;
}

- (NSMutableArray *)fiuSceneList {
    if (!_fiuSceneList) {
        _fiuSceneList = [NSMutableArray array];
    }
    return _fiuSceneList;
}

- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

@end
