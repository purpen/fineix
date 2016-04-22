//
//  GoodsCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCategoryViewController.h"

@interface GoodsCategoryViewController ()

@end

@implementation GoodsCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setGoodsCategoryVcUI];
    
}

#pragma mark - 
- (void)setGoodsCategoryVcUI {
    [self.view addSubview:self.categoryMenuView];
    
    self.goodsCategoryView.nav = self.navigationController;
    [self.view addSubview:self.goodsCategoryView];
}

#pragma mark - 商品列表视图
- (GoodsCategoryView *)goodsCategoryView {
    if (!_goodsCategoryView) {
        _goodsCategoryView = [[GoodsCategoryView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _goodsCategoryView.delegate = self;
        [_goodsCategoryView addGoodsCategoryTableView:self.categoryTitleArr];
    }
    return _goodsCategoryView;
}

#pragma mark - 滑动改变商品分类列表 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [_categoryMenuView updateMenuBtnState:index];
}

#pragma mark - 滑动导航栏
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.menuTitle = self.categoryTitleArr;
        [_categoryMenuView updateMenuButtonData];
    }
    return _categoryMenuView;
}

#pragma mark - 点击导航
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    [_goodsCategoryView changeContentOffSet:index];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.title = NSLocalizedString(@"GoodsCategoryVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car"];
    self.delegate = self;
}

- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊购物车");
}

@end
