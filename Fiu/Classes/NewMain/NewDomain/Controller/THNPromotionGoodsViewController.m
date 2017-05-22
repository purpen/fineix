//
//  THNPromotionGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 2017/5/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNPromotionGoodsViewController.h"
#import "GoodsRow.h"
#import "CategoryRow.h"
#import <MJRefresh/MJRefresh.h>
#import "THNDomainGoodsTableViewCell.h"

static NSString *const URLProductList = @"/product/getlist";
static NSString *const URLCategory = @"/category/getlist";

static NSString *const GoodsCellId = @"THNDomainGoodsTableViewCellId";

@interface THNPromotionGoodsViewController (){
    NSString *_categoryIdx;
}

@end

@implementation THNPromotionGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.menuView];
    [self thn_networkCategoryData];
    [self.view addSubview:self.goodsTable];
    [self thn_networkGoodsListData:@""];
}
    
#pragma mark -
#pragma mark - 网络获取分类列表
- (void)thn_networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"show_all":@"1", @"domain":@"1", @"page":@"1", @"size":@"100", @"use_cache":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.categoryMarr removeAllObjects];
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDict in dataArr) {
            CategoryRow *model = [[CategoryRow alloc] initWithDictionary:dataDict];
            [self.categoryMarr addObject:model.title];
            [self.categoryIdMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        }
        
        if (self.categoryMarr.count) {
            self.menuView.menuTitle = self.categoryMarr;
            [self.menuView updateMenuButtonData];
            [self.menuView updateMenuBtnState:0];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}
    
#pragma mark - 推广商品列表
/**
 切换分类获取分类下的商品
 
 @param categoryId 分类id
*/
- (void)thn_networkGoodsListData:(NSString *)categoryId {
    [SVProgressHUD show];
    self.goodsListRequest = [FBAPI getWithUrlString:URLProductList requestDictionary:@{@"page":@(self.goodsCurrentpageNum + 1),
                                                                                       @"size":@"10",
                                                                                       @"sort":@"0",
                                                                                @"category_id":categoryId,
                                                                               @"is_commision":@"1"} delegate:self];
    [self.goodsListRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.goodsListMarr removeAllObjects];
        [self.goodsIdMarr removeAllObjects];
        
//        NSLog(@"===== 推广商品 %@", result);
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.goodsTable reloadData];
        self.goodsCurrentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.goodsTotalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsTable currentPage:self.goodsCurrentpageNum withTotalPage:self.goodsTotalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}
    
#pragma mark - 是否分页加载
- (void)requestIsLastData:(UIScrollView *)scrollView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (scrollView.mj_footer.state == MJRefreshStateNoMoreData) {
            [scrollView.mj_footer resetNoMoreData];
        }
    }
    
    if (current == total == 1) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    if ([scrollView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [scrollView.mj_footer endRefreshing];
        }
    }
}
    
#pragma mark 分类导航栏
- (FBMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        _menuView.defaultColor = @"#666666";
    }
    return _menuView;
}
    
    /**
     切换分类
     
     @param index 点击的分类下标
     */
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    _categoryIdx = self.categoryIdMarr[index];
    
    self.goodsCurrentpageNum = 0;
    [self thn_networkGoodsListData:_categoryIdx];
}
    
#pragma mark 加载商品的列表
- (UITableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsTable.showsVerticalScrollIndicator = NO;
//        _goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTable.tableFooterView = [UIView new];
    }
    return _goodsTable;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsListMarr.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCellId];
    if (!cell) {
        cell = [[THNDomainGoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsCellId];
    }
    if (self.goodsListMarr.count) {
        [cell thn_setGoodsItemData:self.goodsListMarr[indexPath.row] chooseHidden:NO domainId:self.domainId];
    }
    return cell;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
    
#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"推广商品";
}
   
#pragma mark - NSMutableArray
- (NSMutableArray *)categoryMarr {
    if (!_categoryMarr) {
        _categoryMarr = [NSMutableArray array];
    }
    return _categoryMarr;
}
    
- (NSMutableArray *)categoryIdMarr {
    if (!_categoryIdMarr) {
        _categoryIdMarr = [NSMutableArray array];
    }
    return _categoryIdMarr;
}
    
- (NSMutableArray *)goodsListMarr {
    if (!_goodsListMarr) {
        _goodsListMarr = [NSMutableArray array];
    }
    return _goodsListMarr;
}
    
- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
}

@end
