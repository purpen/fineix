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
    
    self.titleArr = [NSArray arrayWithObjects:@"情景", @"场景", @"用户", @"产品", nil];

    [self.view addSubview:self.menuView];
    
    [self.view addSubview:self.resultsView];
    
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

#pragma mark - 点击菜单栏的方法
- (void)SearchMenuSeleted:(NSInteger)index {
    CGPoint rollPoint = _resultsView.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    [UIView animateWithDuration:.3 animations:^{
        _resultsView.contentOffset = rollPoint;
    }];
    
    
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝  点击了 %@", self.titleArr[index]);
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
