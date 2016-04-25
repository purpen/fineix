//
//  MallViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallViewController.h"
#import "MallMenuTableViewCell.h"
#import "FiuTagTableViewCell.h"
#import "SearchViewController.h"
#import "GoodsInfoViewController.h"

@implementation MallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMallViewUI];
}


#pragma mark - 设置视图的UI
- (void)setMallViewUI {
    [self.view addSubview:self.mallTableView];
    if ([self.mallTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mallTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mallTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mallTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 顶部轮播图
- (FBRollImages *)rollView {
    if (!_rollView) {
        _rollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollView.navVC = self.navigationController;
        [_rollView setRollimageView];
    }
    return _rollView;
}

#pragma mark - tableView
- (UITableView *)mallTableView {
    if (!_mallTableView) {
        _mallTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _mallTableView.delegate = self;
        _mallTableView.dataSource = self;
        _mallTableView.tableHeaderView = self.rollView;
        _mallTableView.showsVerticalScrollIndicator = NO;
        _mallTableView.backgroundColor = [UIColor whiteColor];
    }
    return _mallTableView;
}

#pragma mark - tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * mallBrandCellId = @"mallBrandCellId";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallBrandCellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallBrandCellId];
            }
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * mallGoodsTagCellId = @"mallGoodsTagCellId";
            FiuTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallGoodsTagCellId];
            if (!cell) {
                cell = [[FiuTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallGoodsTagCellId];
            }
            [cell setMallUI];
            cell.nav = self.navigationController;
            return cell;
            
        }  else if (indexPath.row == 2) {
            static NSString * mallMenuTableViewCellID = @"mallMenuTableViewCell";
            MallMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallMenuTableViewCellID];
            if (!cell) {
                cell = [[MallMenuTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallMenuTableViewCellID];
            }
            cell.nav = self.navigationController;
            return cell;
        }
        
    }
    static NSString * CellId = @"mallTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 155;
        } else if (indexPath.row == 1) {
            return 80;
        } else if (indexPath.row == 2) {
            return 105;
        }
        
    } else if (indexPath.section == 1) {
        return 266.5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"Group_Brand" withTitle:@"最Fiu品牌" withSubtitle:@"[越喜欢头像越大]"];
    } else if (section ==1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"最Fiu商品" withSubtitle:@"[生活有你才够美]"];
    } 
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImg];
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car"];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 3;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊购物车");
}
@end
