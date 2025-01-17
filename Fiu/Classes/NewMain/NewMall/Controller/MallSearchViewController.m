//
//  MallSearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallSearchViewController.h"
#import "SearchGoodsViewController.h"
#import "SearchBrandViewController.h"

@interface MallSearchViewController () {
    NSInteger _searchType;
    SearchGoodsViewController *_goodsVC;
    SearchBrandViewController *_brandVC;
}

@end

@implementation MallSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchVcUI];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    if (Is_iPhoneX) {
        self.searchView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
        self.menuView.frame = CGRectMake(0, 88, SCREEN_WIDTH, 44);
        self.resultsView.frame = CGRectMake(0, 132, SCREEN_WIDTH, SCREEN_HEIGHT - 132);
    }
}

#pragma mark - 设置视图UI
- (void)setSearchVcUI {
    [self.view addSubview:self.menuView];
    [self menuItemSelected:0];
    [self thn_setSearchResultsViewController];
}

#pragma mark - 初始化搜索视图
- (void)thn_setSearchResultsViewController {
    _goodsVC = [[SearchGoodsViewController alloc] init];
    _goodsVC.index = 0;
    [self addChildViewController:_goodsVC];
    
    _brandVC = [[SearchBrandViewController alloc] init];
    _brandVC.index = 1;
    [self addChildViewController:_brandVC];
    
    [self.resultsView addSubview:_goodsVC.view];
    [self.resultsView addSubview:_brandVC.view];
    [self.view addSubview:self.resultsView];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"mallSearch", nil);
        _searchView.delegate = self;
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
            [_goodsVC searchAgain:searchKeyword];
            break;
            
        case 1:
            [_brandVC searchAgain:searchKeyword];
            break;
            
        default:
            break;
    }
}

- (FBSegmentView *)menuView {
    if (!_menuView) {
        NSArray *titleArr = @[NSLocalizedString(@"searchProduct", nil), NSLocalizedString(@"searchBrand", nil)];
        if (Is_iPhoneX) {
            _menuView = [[FBSegmentView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
        }else {
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
                [_goodsVC searchAgain:searchKeyword];
                break;
                
            case 1:
                [_brandVC searchAgain:searchKeyword];
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
    self.navBackBtn.hidden = YES;
    [self.navView addSubview:self.searchView];
    self.navLine.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}


@end
