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
#import "GoodsInfoData.h"

static NSString *const URLMarkGoods = @"/category/getlist";
static NSString *const URLGoodsList = @"/product/getlist";
static NSString *const URLSearchGoods = @"/search/getlist";
static NSString *const URLGetGoodsImg = @"/product/view";

@interface MarkGoodsViewController ()

@pro_strong NSMutableArray      *   categoryTitle;
@pro_strong NSMutableArray      *   categoryId;
@pro_strong NSMutableArray      *   goodsList;
@pro_strong NSMutableArray      *   searchGoodsList;
@pro_strong NSString            *   ids;
@pro_strong GoodsInfoData       *   goodsModel;

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
    [SVProgressHUD show];
    self.searchRequest = [FBAPI getWithUrlString:URLSearchGoods requestDictionary:@{@"t":@"3", @"q":keyword,@"evt":@"content", @"page":@(self.searchCurrentpageNum + 1), @"size":@"8"} delegate:self];
    [self.searchRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDict in goodsArr) {
            MarkGoodsRow * goodsModel = [[MarkGoodsRow alloc] initWithDictionary:goodsDict];
            [self.searchGoodsList addObject:goodsModel];
        }
        [self.searchListView reloadData];
        
        self.searchCurrentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.searchTotalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.searchListView currentPage:self.searchCurrentpageNum withTotalPage:self.searchTotalPageNum];
        
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
        
        [self.goodsListView reloadData];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsListView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 获取产品详情取出图片
- (void)networkGetGoodsImg:(NSString *)goodsId {
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeBlack)];
    self.getImgRequest = [FBAPI getWithUrlString:URLGetGoodsImg requestDictionary:@{@"id":goodsId} delegate:self];
    [self.getImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.goodsModel = [[GoodsInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        NSString *imgUrl;
        CGFloat height;
        CGFloat width;
        if (self.goodsModel.pngAsset.count) {
            imgUrl = [self.goodsModel.pngAsset valueForKey:@"url"][0];
            height = [[self.goodsModel.pngAsset valueForKey:@"height"][0] floatValue];
            width = [[self.goodsModel.pngAsset valueForKey:@"width"][0] floatValue];
        } else {
            imgUrl = @"";
            height = 0.0f;
            width = 0.0f;
        }
        self.getImgBlock(
                         imgUrl,
                         self.goodsModel.title,
                         [NSString stringWithFormat:@"%.2f",self.goodsModel.salePrice],
                         [NSString stringWithFormat:@"%zi",self.goodsModel.idField],
                         width,
                         height
                         );
        [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - 搜索列表
- (UICollectionView *)searchListView {
    if (!_searchListView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30)/2, ((SCREEN_WIDTH - 30)/2) * 1.33);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
        
        _searchListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) collectionViewLayout:flowLayout];
        _searchListView.delegate = self;
        _searchListView.dataSource = self;
        _searchListView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];

        _searchListView.showsVerticalScrollIndicator = NO;
        _searchListView.showsHorizontalScrollIndicator = NO;
        [_searchListView registerClass:[MarkGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"searchGoodsListViewCell"];
        _searchListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.searchCurrentpageNum < self.searchTotalPageNum) {
                [self networkSearchGoods:self.searchGoods.searchInputBox.text];
            } else {
                [_searchListView.mj_footer endRefreshing];
            }
        }];
        
    }
    return _searchListView;
}


#pragma mark - 商品列表
- (UICollectionView *)goodsListView {
    if (!_goodsListView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30)/2, ((SCREEN_WIDTH - 30)/2) * 1.33);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
        
        _goodsListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) collectionViewLayout:flowLayout];
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
    if (collectionView == self.goodsListView) {
        return self.goodsList.count;
    } else if (collectionView == self.searchListView) {
        return self.searchGoodsList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.goodsListView) {
        MarkGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListViewCell" forIndexPath:indexPath];
        if (self.goodsList.count > 0) {
            [cell setMarkGoodsData:self.goodsList[indexPath.row]];
        }
        return cell;
    } else if (collectionView == self.searchListView) {
        MarkGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchGoodsListViewCell" forIndexPath:indexPath];
        if (self.searchGoodsList.count > 0) {
            [cell setMarkGoodsData:self.searchGoodsList[indexPath.row]];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.goodsListView) {
        NSString * goodsId = [NSString stringWithFormat:@"%@",[self.goodsList valueForKey:@"idField"][indexPath.row]];
        [self networkGetGoodsImg:goodsId];
    } else if (collectionView == self.searchListView) {
        NSString * goodsId = [NSString stringWithFormat:@"%@",[self.searchGoodsList valueForKey:@"idField"][indexPath.row]];
        [self networkGetGoodsImg:goodsId];
    }
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"searchGoods", nil);
        _searchGoods.delegate = self;
    }
    return _searchGoods;
}

#pragma mark - 搜索产品
- (void)beginSearch:(NSString *)searchKeyword {
    [self.searchGoodsList removeAllObjects];
    self.searchCurrentpageNum = 0;
    [self.view addSubview:self.searchListView];
    [self networkSearchGoods:searchKeyword];
}

#pragma mark - 取消搜索
- (void)cancelSearch {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.searchListView removeFromSuperview];
    }];
}

#pragma mark - 导航菜单视图
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.defaultColor = titleColor;
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
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navView.hidden = YES;
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

- (NSMutableArray *)searchGoodsList {
    if (!_searchGoodsList) {
        _searchGoodsList = [NSMutableArray array];
    }
    return _searchGoodsList;
}

@end
