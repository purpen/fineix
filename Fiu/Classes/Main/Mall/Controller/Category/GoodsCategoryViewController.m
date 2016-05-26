//
//  GoodsCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCategoryViewController.h"
#import "GoodsCarViewController.h"
#import "ChildTagsTag.h"
#import "GoodsRow.h"
#import "GoodsTableViewCell.h"
#import "GoodsInfoViewController.h"

static NSString *const URLChildTags = @"/category/fetch_child_tags";
static NSString *const URLGoodsList = @"/scene_product/getlist";

@interface GoodsCategoryViewController ()

@pro_strong NSMutableArray              *   childTagsList;      //  子分类model
@pro_strong NSMutableArray              *   childTagsId;        //  子分类id
@pro_strong NSMutableArray              *   goodsList;          //  商品
@pro_strong NSMutableArray              *   goodsIdList;        //  商品id

@end

@implementation GoodsCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getGoodsCarNumData];
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGoodsCategoryVcUI];
    [self networkChildTagsData:self.categoryId];
    
    //  分类商品列表
    NSInteger index = [self.categoryIdMarr indexOfObject:self.categoryId];
    [self networkGoodsListData:self.idMarr[index] withTagIds:@""];

}

#pragma mark - 网络请求
#pragma mark 子分类
- (void)networkChildTagsData:(NSString *)tagId {
    [self.childTagsList removeAllObjects];
    [self.childTagsId removeAllObjects];
    
    self.childTagsRequest = [FBAPI getWithUrlString:URLChildTags requestDictionary:@{@"tag_id":tagId} delegate:self];
    [self.childTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * childTagsArr = [[result valueForKey:@"data"] valueForKey:@"tags"];
        for (NSDictionary * childTagsDic in childTagsArr) {
            ChildTagsTag * childTagsModel = [[ChildTagsTag alloc] initWithDictionary:childTagsDic];
            [self.childTagsList addObject:childTagsModel];
            [self.childTagsId addObject:[NSString stringWithFormat:@"%zi", childTagsModel.idField]];
        }
        //  子分类列表
        [self.headerView setTagRollMarr:self.childTagsList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品列表
- (void)networkGoodsListData:(NSString *)categoryId withTagIds:(NSString *)tagId {
    [SVProgressHUD show];
    //  防止加载过程中，点击其他进行操作
    self.view.userInteractionEnabled = NO;
    
    self.goodsListRequest = [FBAPI getWithUrlString:URLGoodsList requestDictionary:@{@"size":@"8", @"page":@(self.currentpageNum + 1), @"category_id":categoryId, @"category_tag_ids":tagId} delegate:self];
    [self.goodsListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsList addObject:goodsModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsListTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [self.goodsListTable reloadData];
        
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        
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
            //  优先获取子分类的商品
            if (self.tagId.length > 0) {
                [self networkGoodsListData:@"" withTagIds:self.tagId];
                
            } else {
                NSInteger idIndex = (self.categoryMenuView.selectedBtn.tag - menuBtnTag) - 1;
                if (idIndex > 0) {
                    [self networkGoodsListData:self.idMarr[idIndex] withTagIds:@""];
                } else {
                    [self networkGoodsListData:@"" withTagIds:@""];
                }
            }
            
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 
- (void)setGoodsCategoryVcUI {
    [self.view addSubview:self.categoryMenuView];
    
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.goodsListTable];
}

#pragma mark - 商品列表视图
- (UITableView *)goodsListTable {
    if (!_goodsListTable) {
        _goodsListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 158, SCREEN_WIDTH, SCREEN_HEIGHT - 158) style:(UITableViewStylePlain)];
        _goodsListTable.delegate = self;
        _goodsListTable.dataSource = self;
        _goodsListTable.showsVerticalScrollIndicator = NO;
        _goodsListTable.showsHorizontalScrollIndicator = NO;
        _goodsListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsListTable.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        _goodsListTable.tableFooterView = [UIView new];
        
        [self addMJRefresh:self.goodsListTable];
    }
    return _goodsListTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * goodsTableViewCellId = @"GoodsTableViewCellId";
    GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsTableViewCellId];
    if (!cell) {
        cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsTableViewCellId];
    }
    if (self.goodsList.count > 0) {
        [cell setGoodsData:self.goodsList[indexPath.row]];
    }
    cell.nav = self.navigationController;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark - 头部的分类标签
- (CategoryTagRollView *)headerView {
    if (!_headerView) {
        _headerView = [[CategoryTagRollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 40)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - 点击分类的标签
- (void)tagBtnSelected:(NSInteger)index {
    [self.goodsList removeAllObjects];
    [self.goodsIdList removeAllObjects];
    self.currentpageNum = 0;
    NSInteger idIndex = (self.categoryMenuView.selectedBtn.tag - menuBtnTag) - 1;
    [self networkGoodsListData:self.idMarr[idIndex] withTagIds:self.childTagsId[index]];
    self.tagId = self.childTagsId[index];
}

#pragma mark - 显示分类标签
- (void)showCategoryTag:(NSInteger)index {
    CGRect rect = self.goodsListTable.frame;
    if (index == 0) {
        rect = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
        [UIView animateWithDuration:.3 animations:^{
            self.headerView.alpha = 0;
            self.goodsListTable.frame = rect;
        }];
        
    } else {
        rect = CGRectMake(0, 148, SCREEN_WIDTH, SCREEN_HEIGHT - 148);
        [UIView animateWithDuration:.3 animations:^{
            self.headerView.alpha = 1;
            self.goodsListTable.frame = rect;
        }];
    }
}

#pragma mark - 滑动导航栏
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 54)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.menuTitle = self.categoryTitleArr;
        [_categoryMenuView updateMenuButtonData];
    }
    return _categoryMenuView;
}

#pragma mark - 点击导航
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    [self.goodsList removeAllObjects];
    [self.goodsIdList removeAllObjects];
    self.currentpageNum = 0;
    
    if (index > 0) {
        [self networkChildTagsData:self.categoryIdMarr[index - 1]];
        //  分类商品列表
        NSInteger idIndex = [self.categoryIdMarr indexOfObject:self.categoryIdMarr[index - 1]];
        [self networkGoodsListData:self.idMarr[idIndex] withTagIds:@""];
    
    }   else if (index == 0) {
        [self networkGoodsListData:@"" withTagIds:@""];
    }
    
    [self showCategoryTag:index];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.navViewTitle.text = NSLocalizedString(@"GoodsCategoryVcTitle", nil);
    [self addBarItemRightBarButton:@"" image:@"Nav_Car" isTransparent:NO];
    [self setNavGoodsCarNumLab];
}

//  打开购物车
- (void)rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark -
- (NSMutableArray *)childTagsList {
    if (!_childTagsList) {
        _childTagsList = [NSMutableArray array];
    }
    return _childTagsList;
}

- (NSMutableArray *)childTagsId {
    if (!_childTagsId) {
        _childTagsId = [NSMutableArray array];
    }
    return _childTagsId;
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



@end
