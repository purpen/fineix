//
//  SearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchSceneViewController.h"
#import "SearchUserViewController.h"
#import "SearchGoodsViewController.h"
#import "SearchBrandViewController.h"
#import "SearchThemeViewController.h"

static NSString *const URLSearchList = @"/search/getlist";

@interface SearchViewController () {
    NSInteger _searchType;
    SearchSceneViewController *_sceneVC;
    SearchUserViewController *_userVC;
    SearchGoodsViewController *_goodsVC;
    SearchBrandViewController *_brandVC;
    SearchThemeViewController *_themeVC;
}

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchVcUI];
    [self changeMenuBtnState:0];
}

#pragma mark - 设置视图UI 
- (void)setSearchVcUI {
    self.titleArr = @[NSLocalizedString(@"searchScene", nil),
                      NSLocalizedString(@"searchUser", nil),
                      NSLocalizedString(@"searchProduct", nil),
                      NSLocalizedString(@"searchBrand", nil),
                      NSLocalizedString(@"searchTheme", nil)];
    
    [self.view addSubview:self.menuView];
    
    [self thn_setSearchResultsViewController];
}

#pragma mark - 初始化搜索视图
- (void)thn_setSearchResultsViewController {
    _sceneVC = [[SearchSceneViewController alloc] init];
    _sceneVC.index = 0;
    [self addChildViewController:_sceneVC];
    
    _userVC = [[SearchUserViewController alloc] init];
    _userVC.index = 1;
    [self addChildViewController:_userVC];
    
    _goodsVC = [[SearchGoodsViewController alloc] init];
    _goodsVC.index = 2;
    [self addChildViewController:_goodsVC];
    
    _brandVC = [[SearchBrandViewController alloc] init];
    _brandVC.index = 3;
    [self addChildViewController:_brandVC];
    
    _themeVC = [[SearchThemeViewController alloc] init];
    _themeVC.index = 4;
    [self addChildViewController:_themeVC];
    
    [self.resultsView addSubview:_sceneVC.view];
    [self.resultsView addSubview:_userVC.view];
    [self.resultsView addSubview:_goodsVC.view];
    [self.resultsView addSubview:_brandVC.view];
    [self.resultsView addSubview:_themeVC.view];
    [self.view addSubview:self.resultsView];
}

#pragma mark - 搜索结果视图
- (UIScrollView *)resultsView {
    if (!_resultsView) {
        _resultsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _resultsView.pagingEnabled = YES;
        _resultsView.showsHorizontalScrollIndicator = NO;
        _resultsView.showsVerticalScrollIndicator = NO;
        _resultsView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _resultsView.scrollEnabled = NO;
        _resultsView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleArr.count, 0);
    }
    return _resultsView;
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"search", nil);
        _searchView.delegate = self;
        _searchView.line.hidden = YES;
    }
    return _searchView;
}

- (void)cancelSearch {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)beginSearch:(NSString *)searchKeyword {
    switch (_searchType) {
        case 0:
            [_sceneVC searchAgain:searchKeyword];
            break;
            
        case 1:
            [_userVC searchAgain:searchKeyword];
            break;
            
        case 2:
            [_goodsVC searchAgain:searchKeyword];
            break;
            
        case 3:
            [_brandVC searchAgain:searchKeyword];
            break;
            
        case 4:
            [_themeVC searchAgain:searchKeyword];
            break;
            
        default:
            break;
    }
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
    [self changeMenuBtnState:index];
}

//  改变搜索视图位置
- (void)changeMenuBtnState:(NSInteger)index {
    _searchType = index;
    
    CGPoint rollPoint = self.resultsView.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    [UIView animateWithDuration:.3 animations:^{
        self.resultsView.contentOffset = rollPoint;
    }];
    
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.navView addSubview:self.searchView];
    self.navLine.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}


@end
