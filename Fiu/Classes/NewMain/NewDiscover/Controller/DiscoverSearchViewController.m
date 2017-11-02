//
//  DiscoverSearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DiscoverSearchViewController.h"
#import "SearchSceneViewController.h"
#import "SearchUserViewController.h"

@interface DiscoverSearchViewController () {
    NSInteger _searchType;
    SearchSceneViewController *_sceneVC;
    SearchUserViewController *_userVC;
}

@end

@implementation DiscoverSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchVcUI];
}

#pragma mark - 设置视图UI
- (void)setSearchVcUI {
    [self.view addSubview:self.menuView];
    [self menuItemSelected:0];
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
    
    [self.resultsView addSubview:_sceneVC.view];
    [self.resultsView addSubview:_userVC.view];
    [self.view addSubview:self.resultsView];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"discoverSearch", nil);
        _searchView.delegate = self;
        _searchView.line.hidden = YES;
        [_searchView.searchInputBox becomeFirstResponder];
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
            [_sceneVC searchAgain:searchKeyword withType:@"content"];
            break;
            
        case 1:
            [_userVC searchAgain:searchKeyword];
            break;
            
        default:
            break;
    }
}

- (FBSegmentView *)menuView {
    if (!_menuView) {
        NSArray *titleArr = @[NSLocalizedString(@"searchScene", nil), NSLocalizedString(@"searchUser", nil)];
        if (Is_iPhoneX) {
            _menuView = [[FBSegmentView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
        } else {
            _menuView = [[FBSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        }
        _menuView.delegate = self;
        [_menuView set_menuItemTitle:titleArr];
        [_menuView set_showBottomLine:YES];
    }
    return _menuView;
}

- (void)menuItemSelected:(NSInteger)index {
    _searchType = index;
    NSString *searchKeyword = self.searchView.searchInputBox.text;
    if (searchKeyword.length) {
        switch (_searchType) {
            case 0:
                [_sceneVC searchAgain:searchKeyword withType:@"content"];
                break;
                
            case 1:
                [_userVC searchAgain:searchKeyword];
                break;
                
            default:
                break;
        }
    }
    
    CGPoint rollPoint = self.resultsView.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    [UIView animateWithDuration:.3 animations:^{
        self.resultsView.contentOffset = rollPoint;
    }];

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
        _resultsView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    }
    return _resultsView;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.navView addSubview:self.searchView];
    self.navLine.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}


@end
