//
//  MarkGoodsViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MarkGoodsViewController.h"
#import "Fiu.h"
#import "SVProgressHUD.h"
#import "MarkGoodsRow.h"
#import "MarkGoodsCollectionViewCell.h"

static NSString *const URLMarkGoods = @"/category/getlist";
static NSString *const URLGoodsList = @"/scene_product/getlist";
static NSString *const URLSearchGoods = @"/search/getlist";

@interface MarkGoodsViewController ()

@pro_strong NSMutableArray      *   categoryTitle;
@pro_strong NSMutableArray      *   categoryId;
@pro_strong NSMutableArray      *   goodsList;
@pro_strong NSString            *   ids;

@end

@implementation MarkGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavViewUI];
    [self networkRequest];
    
}


#pragma mark - 网络请求
#pragma mark 分类列表
- (void)networkRequest {
    self.markGoodsRequest = [FBAPI getWithUrlString:URLMarkGoods requestDictionary:@{@"domain":@"10"} delegate:self];
    [self.markGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.categoryTitle = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title"]];
        self.categoryId = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"]];
        [self.categoryTitle insertObject:@"全部" atIndex:0];
        self.currentpageNum = 0;
        self.ids = @"";
        [self networkMarkGoodsData];
        [self setUI];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 搜索商品
- (void)networkSearchGoods:(NSString *)keyword {
    [self.goodsList removeAllObjects];
    [SVProgressHUD show];
    self.searchRequest = [FBAPI getWithUrlString:URLSearchGoods requestDictionary:@{@"t":@"10", @"q":keyword} delegate:self];
    [self.searchRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDict in goodsArr) {
            MarkGoodsRow * goodsModel = [[MarkGoodsRow alloc] initWithDictionary:goodsDict];
            [self.goodsList addObject:goodsModel];
        }
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsListView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [self.goodsListView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 分类商品
- (void)networkMarkGoodsData {
    [SVProgressHUD show];
    self.goodsDataRequest = [FBAPI getWithUrlString:URLGoodsList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@"8", @"category_id":self.ids} delegate:self];
    [self.goodsDataRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDict in goodsArr) {
            MarkGoodsRow * goodsModel = [[MarkGoodsRow alloc] initWithDictionary:goodsDict];
            [self.goodsList addObject:goodsModel];
        }
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsListView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [self.goodsListView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  判断是否为最后一条数据
- (void)requestIsLastData:(UICollectionView *)collectionView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (collectionView.mj_footer.state == MJRefreshStateNoMoreData) {
            [collectionView.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        collectionView.mj_footer.hidden = true;
    }
    if ([collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header endRefreshing];
    }
    if ([collectionView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [collectionView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 设置视图UI
- (void)setUI {
    
    [self.view addSubview:self.searchGoods];
    
    [self.categoryMenuView updateMenuBtnState:0];
    [self.view addSubview:self.categoryMenuView];
    
    [self.view addSubview:self.goodsListView];

}

#pragma mark - 商品列表
- (UICollectionView *)goodsListView {
    if (!_goodsListView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30)/2, ((SCREEN_WIDTH - 30)/2) * 1.33);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
        
        _goodsListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 138, SCREEN_WIDTH, SCREEN_HEIGHT - 138) collectionViewLayout:flowLayout];
        _goodsListView.delegate = self;
        _goodsListView.dataSource = self;
        _goodsListView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        _goodsListView.showsVerticalScrollIndicator = NO;
        _goodsListView.showsHorizontalScrollIndicator = NO;
        [_goodsListView registerClass:[MarkGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"GoodsListViewCell"];
        
        _goodsListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.currentpageNum < self.totalPageNum) {
                [self networkMarkGoodsData];
            } else {
                [_goodsListView.mj_footer endRefreshing];
            }
        }];

    }
         return _goodsListView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MarkGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListViewCell" forIndexPath:indexPath];
    [cell setMarkGoodsData:self.goodsList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat salePrice = [[self.goodsList valueForKey:@"salePrice"][indexPath.row] floatValue];
    self.getImgBlock([self.goodsList valueForKey:@"coverUrl"][indexPath.row], [self.goodsList valueForKey:@"title"][indexPath.row], [NSString stringWithFormat:@"%.2f",salePrice], [NSString stringWithFormat:@"%@",[self.goodsList valueForKey:@"idField"][indexPath.row]]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"searchGoods", nil);
        _searchGoods.delegate = self;
    }
    return _searchGoods;
}

#pragma mark - 搜索产品
- (void)beginSearch:(NSString *)searchKeyword {
    [self networkSearchGoods:searchKeyword];
}

#pragma mark - 导航菜单视图
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.menuTitle = self.categoryTitle;
        [_categoryMenuView updateMenuButtonData];
    }
    return _categoryMenuView;
}

#pragma mark - 点击导航
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    if (index > 0) {
        [self.goodsList removeAllObjects];
        self.ids = self.categoryId[index - 1];
        self.currentpageNum = 0;
        [self networkMarkGoodsData];
        
    } else if (index == 0) {
        [self.goodsList removeAllObjects];
        [self networkRequest];
    }
}

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"marker", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton:@"icon_cancel_black"];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addLine];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark - 
- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

//- (NSMutableArray *)categoryId {
//    if (!_categoryId) {
//        _categoryId = [NSMutableArray array];
//    }
//    return _categoryId;
//}

@end
