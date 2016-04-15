//
//  SearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArr = [NSArray arrayWithObjects:@"场景", @"情景", @"用户", @"产品", nil];

    [self.view addSubview:self.menuView];
    
    [self.view addSubview:self.resultsView];
    
    if (self.keyword.length > 0) {
        self.searchView.searchInputBox.text = self.keyword;
    }
    [self searchRequest:self.searchType withKeyword:self.keyword];

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
    }
    return _resultsView;
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(35, 0, SCREEN_WIDTH - 35, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"search", nil);
        _searchView.delegate = self;
        _searchView.line.hidden = YES;
    }
    return _searchView;
}

#pragma mark - 搜索
- (void)beginSearch:(NSString *)searchKeyword {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"搜索的关键字：%@", searchKeyword]];
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
    CGPoint rollPoint = _resultsView.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    _resultsView.contentOffset = rollPoint;
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBarTransparent:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    
    [self.navigationController.navigationBar addSubview:self.searchView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchView) {
        [self.searchView removeFromSuperview];
    }
}

@end
