//
//  GoodsCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCategoryViewController.h"
#import "GoodsCarViewController.h"

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
    
    [self.view addSubview:self.headerView];
    
    self.goodsCategoryView.nav = self.navigationController;
    [self.view addSubview:self.goodsCategoryView];
}

#pragma mark - 头部的分类标签
- (CategoryTagRollView *)headerView {
    if (!_headerView) {
        _headerView = [[CategoryTagRollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 40)];
        _headerView.delegate = self;
        [_headerView setTagRollMarr:self.tagTitleArr];
    }
    return _headerView;
}

#pragma mark - 商品列表视图
- (GoodsCategoryView *)goodsCategoryView {
    if (!_goodsCategoryView) {
        _goodsCategoryView = [[GoodsCategoryView alloc] initWithFrame:CGRectMake(0, 148, SCREEN_WIDTH, SCREEN_HEIGHT - 148)];
        _goodsCategoryView.delegate = self;
        [_goodsCategoryView addGoodsCategoryTableView:self.categoryTitleArr];
        _goodsCategoryView.categoryTable.tableHeaderView = [[UIView alloc] init];
    }
    return _goodsCategoryView;
}

#pragma mark - 滑动改变商品分类列表 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [_categoryMenuView updateMenuBtnState:index];
    
    [self showCategoryTag:index];
}

#pragma mark - 滑动导航栏
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.menuTitle = self.categoryTitleArr;
        [_categoryMenuView updateMenuButtonData];
    }
    return _categoryMenuView;
}

#pragma mark - 点击导航
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    [_goodsCategoryView changeContentOffSet:index];
    
    [self showCategoryTag:index];
    
}

#pragma mark - 点击分类的标签
- (void)tagBtnSelected:(NSInteger)index {
    NSLog(@"－＝＝＝ 分类标签：%@",self.categoryTagId[index]);
}

#pragma mark - 显示分类标签
- (void)showCategoryTag:(NSInteger)index {
    CGRect rect = self.goodsCategoryView.frame;
    CGRect tableRect = self.goodsCategoryView.categoryTable.frame;
    
    if (index == 0) {
        rect = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
        tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
        [UIView animateWithDuration:.3 animations:^{
            self.headerView.alpha = 0;
            self.goodsCategoryView.frame = rect;
            self.goodsCategoryView.categoryTable.frame = tableRect;
        }];
        
    } else {
        rect = CGRectMake(0, 148, SCREEN_WIDTH, SCREEN_HEIGHT - 148);
        [UIView animateWithDuration:.3 animations:^{
            self.headerView.alpha = 1;
            self.goodsCategoryView.frame = rect;
        }];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.navViewTitle.text = NSLocalizedString(@"GoodsCategoryVcTitle", nil);
    [self addBarItemRightBarButton:@"" image:@"Nav_Car" isTransparent:NO];
}

- (void)rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

@end
