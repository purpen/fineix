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
#import "GoodsCarViewController.h"
#import "GoodsTableViewCell.h"
#import "CategoryRow.h"
#import "GoodsRow.h"
#import "RollImageRow.h"

static NSString *const URLTagS = @"/scene_tags/getlist";
static NSString *const URLCategoryList = @"/category/getlist";
static NSString *const URLFiuGoods = @"/scene_product/getlist";
static NSString *const URLMallSlide = @"/gateway/slide";

@interface MallViewController()

@pro_strong NSMutableArray              *   tagsList;
@pro_strong NSMutableArray              *   categoryList;
@pro_strong NSMutableArray              *   goodsList;
@pro_strong NSMutableArray              *   goodsIdList;
@pro_strong NSMutableArray              *   rollList;

@end

@implementation MallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkRollImgData];
    [self networkTagsListData];
    [self networkCategoryListData];
    [self networkFiuGoodsData];
    
}

#pragma mark - 网络请求
#pragma mark 轮播图
- (void)networkRollImgData {
    self.rollImgRequest = [FBAPI getWithUrlString:URLMallSlide requestDictionary:@{@"name":@"app_fiu_product_index_slide"} delegate:self];
    [self.rollImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * rollArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * rollDic in rollArr) {
            RollImageRow * rollModel = [[RollImageRow alloc] initWithDictionary:rollDic];
            [self.rollList addObject:rollModel];
        }
        
        [self.rollView setRollimageView:self.rollList];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark 标签列表
- (void)networkTagsListData {
    self.tagsRequest = [FBAPI getWithUrlString:URLTagS requestDictionary:@{@"is_hot":@"1", @"sort":@"5", @"page":@"1", @"size":@"50"} delegate:self];
    [self.tagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * tagsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * tagsDic in tagsArr) {
            HotTagsRow * tagsModel = [[HotTagsRow alloc] initWithDictionary:tagsDic];
            [self.tagsList addObject:tagsModel];
        }
        [self.mallTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 分类列表
- (void)networkCategoryListData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategoryList requestDictionary:@{@"domain":@"10"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * categoryArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * categoryDic in categoryArr) {
            CategoryRow * categoryModel = [[CategoryRow alloc] initWithDictionary:categoryDic];
            [self.categoryList addObject:categoryModel];
        }
        [self.mallTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 最Fiu商品
- (void)networkFiuGoodsData {
    [SVProgressHUD show];
    self.fiuGoodsRequest = [FBAPI getWithUrlString:URLFiuGoods requestDictionary:@{@"size":@"8", @"page":@(self.currentpageNum + 1), @"fine":@"1"} delegate:self];
    [self.fiuGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self setMallViewUI];
        
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsList addObject:goodsModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
        
        [self.mallTableView reloadData];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        if (self.totalPageNum > 1) {
            [self addMJRefresh:self.mallTableView];
            [self requestIsLastData:self.mallTableView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
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
    } else {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
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

#pragma mark 上拉加载
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkFiuGoodsData];
            
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置视图的UI
- (void)setMallViewUI {
    [self.view addSubview:self.mallTableView];
}

#pragma mark - 顶部轮播图
- (FBRollImages *)rollView {
    if (!_rollView) {
        _rollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollView.navVC = self.navigationController;
    }
    return _rollView;
}

#pragma mark - tableView
- (UITableView *)mallTableView {
    if (!_mallTableView) {
        _mallTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStyleGrouped)];
        _mallTableView.delegate = self;
        _mallTableView.dataSource = self;
        _mallTableView.tableHeaderView = self.rollView;
        _mallTableView.showsVerticalScrollIndicator = NO;
        _mallTableView.backgroundColor = [UIColor whiteColor];
        _mallTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    } else if (section == 1) {
        return self.goodsList.count;
    }
    return 0;
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
            cell = [[FiuTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallGoodsTagCellId];
            [cell setMallHotTagsData:self.tagsList];
            cell.nav = self.navigationController;
            return cell;
            
        }  else if (indexPath.row == 2) {
            static NSString * mallMenuTableViewCellID = @"mallMenuTableViewCell";
            MallMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallMenuTableViewCellID];
            cell = [[MallMenuTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallMenuTableViewCellID];
            [cell setCategoryData:self.categoryList];
            cell.nav = self.navigationController;
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        static NSString * mallGoodsCellId = @"MallGoodsCellId";
        GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallGoodsCellId];
        if (!cell) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallGoodsCellId];
        }
        [cell setGoodsData:self.goodsList[indexPath.row]];
        return cell;
    }
    
    return nil;
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
        return 210;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImgisTransparent:NO];
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search" isTransparent:NO];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car" isTransparent:NO];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 2;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark -
- (NSMutableArray *)tagsList {
    if (!_tagsList) {
        _tagsList = [NSMutableArray array];
    }
    return _tagsList;
}

- (NSMutableArray *)categoryList {
    if (!_categoryList) {
        _categoryList = [NSMutableArray array];
    }
    return _categoryList;
}

- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

- (NSMutableArray *)goodsIdList {
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}

- (NSMutableArray *)rollList {
    if (!_rollList) {
        _rollList = [NSMutableArray array];
    }
    return _rollList;
}



@end