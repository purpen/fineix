//
//  THNMallViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallViewController.h"
#import "THNMallNewGoodsCollectionViewCell.h"
#import "THNMallListCollectionViewCell.h"
#import "GoodsCarViewController.h"
#import "QRCodeScanViewController.h"
#import "THNMallGoodsModelItem.h"
#import "THNMallSubjectModelRow.h"
#import "GoodsRow.h"
#import "MallListGoodsCollectionViewCell.h"
#import "FBGoodsInfoViewController.h"

#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"

#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"

static NSString *const URLSceneList         = @"/scene_sight/";
static NSString *const URLDeleteScene       = @"/scene_sight/delete";
static NSString *const URLLikeScene         = @"/favorite/ajax_love";
static NSString *const URLCancelLike        = @"/favorite/ajax_cancel_love";
static NSString *const URLFavorite          = @"/favorite/ajax_favorite";
static NSString *const URLCancelFavorite    = @"/favorite/ajax_cancel_favorite";
static NSString *const URLMallList          = @"/product/getlist";
static NSString *const URLNewGoodsList      = @"/product/index_new";
static NSString *const URLHotGoodsList      = @"/product/index_hot";
static NSString *const URLCategory          = @"/category/getlist";
static NSString *const URLMallSubject       = @"/scene_subject/getlist";
static NSString *const DiscoverCellId       = @"discoverCellId";
static NSString *const MallListCellId       = @"mallListCellId";
static NSString *const goodsListCellId      = @"GoodsListCellId";
static NSString *const userInfoCellId       = @"UserInfoCellId";
static NSString *const sceneImgCellId       = @"SceneImgCellId";
static NSString *const dataInfoCellId       = @"DataInfoCellId";
static NSString *const sceneInfoCellId      = @"SceneInfoCellId";
static NSString *const CategoryGoodsListCellId  = @"CategoryGoodsListCellId";
static NSString *const NewGoodsListCellId       = @"newGoodsListCellId";

@interface THNMallViewController () {
    NSInteger   _type;
    BOOL        _rollDown;              //  是否下拉
    CGFloat     _lastContentOffset;     //  滚动的偏移量
    BOOL        _goTop;
    NSString   *_idx;
    NSIndexPath *_selectedIndexPath;
    CGFloat      _contentHigh;
    CGFloat      _defaultContentHigh;
}

@end

@implementation THNMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self thn_setMallViewUI];
    [self networkCategoryData];
    [self thn_networkNewGoodsListData];
    [self thn_networkHotGoodsListData];
    [self thn_networkSubjectListData];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"1", @"page":@"1", @"size":@"100", @"use_cache":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.categoryMarr addObject:@"推荐"];
        [self.categoryMarr addObject:@"情境"];
        [self.categoryMarr addObject:@"合集"];
        NSMutableArray *idxMarr = [NSMutableArray array];
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDict in dataArr) {
            CategoryRow *model = [[CategoryRow alloc] initWithDictionary:dataDict];
            [self.categoryMarr addObject:model.title];
            [idxMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        }
        
        [self.categoryIdMarr addObject:@"0"];
        [self.categoryIdMarr addObject:@"0"];
        NSString *allId = [idxMarr componentsJoinedByString:@","];
        [self.categoryIdMarr addObject:allId];
        [self.categoryIdMarr addObjectsFromArray:idxMarr];
        
        if (self.categoryMarr.count) {
            self.menuView.menuTitle = self.categoryMarr;
            [self.menuView updateMenuButtonData];
            [self.menuView updateMenuBtnState:0];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 最新商品列表
- (void)thn_networkNewGoodsListData {
    self.mallListRequest = [FBAPI getWithUrlString:URLNewGoodsList requestDictionary:@{@"type":@"1", @"use_cache":@"1"} delegate:self];
    [self.mallListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.goodsDataMarr addObject:goodsModel];
        }
        
        [self.mallList reloadData];
        [self requestIsLastData:self.mallList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 最热商品列表
- (void)thn_networkHotGoodsListData {
    self.hotGoodsRequest = [FBAPI getWithUrlString:URLHotGoodsList requestDictionary:@{@"type":@"1"} delegate:self];
    [self.hotGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.hotGoodsMarr addObject:goodsModel];
        }
        
        [self.mallList reloadData];
        [self requestIsLastData:self.mallList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 推荐商品专题列表
- (void)thn_networkSubjectListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"5",
                                 @"sort":@"0",
                                 @"type":@"5",
//                                 @"stick":@"1",
                                 @"use_cache":@"1"};
    self.subjectRequest = [FBAPI getWithUrlString:URLMallSubject requestDictionary:requestDic delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallSubjectModelRow *goodsModel = [[THNMallSubjectModelRow alloc] initWithDictionary:goodsDic];
            [self.subjectMarr addObject:goodsModel];
            [self.subjectTypeMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.type]];
            [self.subjectIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.mallList reloadData];
        [self requestIsLastData:self.mallList];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestIsLastData:(UICollectionView *)collectionView {
    if ([collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header endRefreshing];
    }
}

#pragma mark 商品列表
/**
 切换分类获取分类下的商品

 @param categoryId 分类id
 */
- (void)thn_networkGoodsListData:(NSString *)categoryId {
    [SVProgressHUD show];
    
    self.goodsListRequest = [FBAPI getWithUrlString:URLMallList requestDictionary:@{@"page":@(self.goodsCurrentpageNum + 1),
                                                                                    @"size":@"10",
                                                                                    @"sort":@"0",
                                                                                    @"category_id":categoryId} delegate:self];
    [self.goodsListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.goodsList reloadData];
        self.goodsCurrentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.goodsTotalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsList currentPage:self.goodsCurrentpageNum withTotalPage:self.goodsTotalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 分类商品专题列表
- (void)thn_networkCagetorySubjectListData:(NSString *)categoryId size:(NSString *)size {
    NSDictionary *requestDic = @{@"category_id":categoryId,
                                 @"page":@"1",
                                 @"size":size,
                                 @"sort":@"2",
                                 @"type":@"5",
                                 @"use_cache":@"1"};
    
    self.subjectRequest = [FBAPI getWithUrlString:URLMallSubject requestDictionary:requestDic delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallSubjectModelRow *goodsModel = [[THNMallSubjectModelRow alloc] initWithDictionary:goodsDic];
            [self.cageSubjectMarr addObject:goodsModel];
            [self.cageSubjectTypeMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.type]];
            [self.cageSubjectIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        [self.goodsList reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)removeCategorySubjectMarrData {
    [self.cageSubjectMarr removeAllObjects];
    [self.cageSubjectIdMarr removeAllObjects];
    [self.cageSubjectTypeMarr removeAllObjects];
}

- (void)removeGoodsListMarrData {
    [self.goodsIdMarr removeAllObjects];
    [self.goodsListMarr removeAllObjects];
}

#pragma mark - 情境列表
- (void)thn_networkSceneListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@(self.sceneCurrentpage + 1),
                                 @"size":@"10",
                                 @"sort":@"2",
                                 @"fine":@"1",
                                 @"use_cache":@"1",
                                 @"is_product":@"1"};
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        [self.sceneTable reloadData];
        self.sceneCurrentpage = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.sceneTotalPage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.sceneTable currentPage:self.sceneCurrentpage withTotalPage:self.sceneTotalPage];

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

#pragma mark - 情境上拉加载
- (void)addMJRefreshTable:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.sceneCurrentpage < self.sceneTotalPage) {
            [self thn_networkSceneListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark 点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 收藏
- (void)thn_networkFavoriteData:(NSString *)idx {
    self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isFavorite"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 取消收藏
- (void)thn_networkCancelFavoriteData:(NSString *)idx {
    self.cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isFavorite"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 删除情境
- (void)thn_networkDeleteScene:(NSString *)idx {
    self.deleteRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":idx} delegate:self];
    [self.deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr removeObjectAtIndex:index];
            [self.sceneIdMarr removeObjectAtIndex:index];
            [self.userIdMarr removeObjectAtIndex:index];
            [self.sceneTable deleteSections:[NSIndexSet indexSetWithIndex:index + 1] withRowAnimation:(UITableViewRowAnimationFade)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图UI
- (void)thn_setMallViewUI {
    _goTop = NO;
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.mallList];
    [self.view addSubview:self.goodsList];
    [self.view addSubview:self.sceneTable];
}

#pragma mark - 上拉加载 & 下拉刷新
- (void)addHeaderMJRefresh:(UICollectionView *)collectionView {
    FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    collectionView.mj_header = header;
}

- (void)loadNewData {
    self.currentpageNum = 0;
    [self.goodsDataMarr removeAllObjects];
    [self.subjectMarr removeAllObjects];
    [self.subjectIdMarr removeAllObjects];
    [self.subjectTypeMarr removeAllObjects];
    [self.categoryMarr removeAllObjects];
    
    [self thn_networkNewGoodsListData];
    [self thn_networkSubjectListData];
}

- (void)addFooterMJRefresh:(UICollectionView *)collectionView {
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.goodsCurrentpageNum < self.goodsTotalPageNum) {
            [self thn_networkGoodsListData:_idx];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 分类
- (FBMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        _menuView.defaultColor = @"#666666";
    }
    return _menuView;
}

#pragma mark 切换分类
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    [self changeCollectionViewFrame:index];
    _idx = self.categoryIdMarr[index];
    
    if (index == 1) {
        self.sceneCurrentpage = 0;
        [self.sceneListMarr removeAllObjects];
        [self.sceneIdMarr removeAllObjects];
        [self.userIdMarr removeAllObjects];
        [self thn_networkSceneListData];
        
    } else if (index == 2) {
        [SVProgressHUD show];
        [self removeCategorySubjectMarrData];
        [self thn_networkCagetorySubjectListData:@"0" size:@"1000"];
        [self.goodsList.mj_footer endRefreshingWithNoMoreData];
        
    } else if (index > 2) {
        [self removeCategorySubjectMarrData];
        [self thn_networkCagetorySubjectListData:_idx size:@"1"];
        
        [self removeGoodsListMarrData];
        self.goodsCurrentpageNum = 0;
        [self thn_networkGoodsListData:_idx];
    }
}

- (void)changeCollectionViewFrame:(NSInteger)index {
    if (index > 2) {
        index = 2;
    }
    
    CGRect goodsRect = self.goodsList.frame;
    goodsRect = CGRectMake((SCREEN_WIDTH * 2) - (SCREEN_WIDTH * index), 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
    
    CGRect sceneRect = self.sceneTable.frame;
    sceneRect = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH * index, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
    
    CGRect mallRect = self.mallList.frame;
    mallRect = CGRectMake(-SCREEN_WIDTH * index, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.goodsList.frame = goodsRect;
        self.sceneTable.frame = sceneRect;
        self.mallList.frame = mallRect;
    }];
}

#pragma mark - 情境列表
- (UITableView *)sceneTable {
    if (!_sceneTable) {
        _sceneTable = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157) style:(UITableViewStyleGrouped)];
        _sceneTable.delegate = self;
        _sceneTable.dataSource = self;
        _sceneTable.tableFooterView = [UIView new];
        _sceneTable.showsVerticalScrollIndicator = NO;
        _sceneTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _sceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addMJRefreshTable:_sceneTable];
    }
    return _sceneTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneListMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    
    if (indexPath.row == 0) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        if (!cell) {
            cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section]];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 1) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        if (!cell) {
            cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section] userId:[self getLoginUserID] isLogin:[self isUserLogin]];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 2) {
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        if (!cell) {
            cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section]];
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 3) {
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        if (!cell) {
            cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        }
        if (self.sceneListMarr.count) {
            [cell thn_setSceneData:self.sceneListMarr[indexPath.section]
                           isLogin:[self isUserLogin]
                        isUserSelf:[self isLoginUserSelf:self.userIdMarr[indexPath.section]]];
            
            cell.beginLikeTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkLikeSceneData:idx];
            };
            
            cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkCancelLikeData:idx];
            };
            
            cell.beginFavoriteTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkFavoriteData:idx];
            };
            
            cell.cancelFavoriteTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkCancelFavoriteData:idx];
            };
            
            cell.deleteTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkDeleteScene:idx];
            };
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SCREEN_WIDTH;
        
    } else if (indexPath.row == 1) {
        return 50;
        
    } else if (indexPath.row == 2) {
        if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
            return _contentHigh + 15;
        } else {
            return _defaultContentHigh + 15;
        }
        
    } else if (indexPath.row == 3) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        if (_contentHigh > 90.0f) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                _selectedIndexPath = nil;
            } else {
                _selectedIndexPath = indexPath;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - 好货列表
- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH *2, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157) collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
        [_goodsList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:CategoryGoodsListCellId];
        [self addFooterMJRefresh:_goodsList];
    }
    return _goodsList;
}

- (UICollectionView *)mallList {
    if (!_mallList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _mallList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157)
                                        collectionViewLayout:flowLayou];
        _mallList.showsVerticalScrollIndicator = NO;
        _mallList.delegate = self;
        _mallList.dataSource = self;
        _mallList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_mallList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [_mallList registerClass:[THNMallNewGoodsCollectionViewCell class] forCellWithReuseIdentifier:NewGoodsListCellId];
        [self addHeaderMJRefresh:_mallList];
    }
    return _mallList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.goodsList) {
        return self.cageSubjectMarr.count + 1;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.goodsList) {
        if (section == self.cageSubjectMarr.count) {
            return self.goodsListMarr.count;
        } else {
            return 1;
        }
    }
    return self.subjectMarr.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.goodsList) {
        if (indexPath.section == self.cageSubjectMarr.count) {
            MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId forIndexPath:indexPath];
            if (self.goodsListMarr.count) {
                [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
            }
            return cell;
        }
        
        THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryGoodsListCellId forIndexPath:indexPath];
        if (self.cageSubjectMarr.count > 0) {
            [cell setMallSubjectData:self.cageSubjectMarr[indexPath.section]];
            cell.nav = self.navigationController;
        } else {
            [cell thn_hiddenCellView];
        }
        return cell;
        
    } else if (collectionView == self.mallList) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            THNMallNewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewGoodsListCellId
                                                                                                forIndexPath:indexPath];
            if (self.goodsDataMarr.count) {
                if (indexPath.row == 0) {
                    [cell setNewGoodsData:self.goodsDataMarr];
                } else if (indexPath.row == 1) {
                    [cell setHotGoodsData:self.hotGoodsMarr];
                }
            }
            cell.nav = self.navigationController;
            return cell;
            
        } else {
            THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                            forIndexPath:indexPath];
            if (self.subjectMarr.count) {
                [cell setMallSubjectData:self.subjectMarr[indexPath.row - 2]];
            }
            cell.nav = self.navigationController;
            return cell;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.goodsList) {
        if (indexPath.section == self.cageSubjectMarr.count) {
            return CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
            
        } else {
            if (self.cageSubjectMarr.count > 0) {
                return CGSizeMake(SCREEN_WIDTH, 366);
            } else {
                return CGSizeMake(SCREEN_WIDTH, 0.01);
            }
        }
 
    } else if (collectionView == self.mallList) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return CGSizeMake(SCREEN_WIDTH, 230);
        } else
            return CGSizeMake(SCREEN_WIDTH, 366);
    }
    
    return CGSizeMake(SCREEN_WIDTH, 0.01);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.goodsList) {
        if (section == self.cageSubjectMarr.count) {
            return UIEdgeInsetsMake(15, 15, 15, 15);
        } else {
            if (self.cageSubjectMarr.count > 0) {
                return UIEdgeInsetsMake(15, 15, 0, 15);
            } else {
                return UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.goodsList) {
        if (indexPath.section == self.cageSubjectMarr.count) {
            FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
            goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
            [self.navigationController pushViewController:goodsVC animated:YES];
            
        } else {
            NSInteger type = [self.cageSubjectTypeMarr[indexPath.section] integerValue];
            NSString *subjectId = self.cageSubjectIdMarr[indexPath.section];
            [self openSubjectInfoController:type subjectId:subjectId];
        }
        
    } else if (collectionView == self.mallList) {
        if (indexPath.row != 0 || indexPath.row != 1) {
            NSInteger type = [self.subjectTypeMarr[indexPath.row - 2] integerValue];
            NSString *subjectId = self.subjectIdMarr[indexPath.row - 2];
            [self openSubjectInfoController:type subjectId:subjectId];
        }
    }
}

#pragma mark - 好货专题详情跳转
- (void)openSubjectInfoController:(NSInteger)type subjectId:(NSString *)subjectId {
    if (type == 3) {
        THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
        cuXiao.cuXiaoDetalId = subjectId;
        cuXiao.vcType = 1;
        [self.navigationController pushViewController:cuXiao animated:YES];
        
    } else if (type == 4) {
        THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
        xinPin.xinPinDetalId = subjectId;
        [self.navigationController pushViewController:xinPin animated:YES];
        
    } else if (type == 5) {
        THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
        cuXiao.cuXiaoDetalId = subjectId;
        cuXiao.vcType = 2;
        [self.navigationController pushViewController:cuXiao animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addSearchBtnText:NSLocalizedString(@"mallSearch", nil) type:2];
    self.searchBtn.frame = CGRectMake(50, 29, SCREEN_WIDTH - 65, 26);
    [self thn_addBarItemLeftBarButton:@"" image:@"mall_saoma"];
}

- (void)thn_leftBarItemSelected {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"MallGoodsLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"MallGoodsLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"haohuo_saoyisao",@"haohuo_gouwuche"]];
    }
}

#pragma mark - NSMutableArray
- (NSMutableArray *)goodsDataMarr {
    if (!_goodsDataMarr) {
        _goodsDataMarr = [NSMutableArray array];
    }
    return _goodsDataMarr;
}

- (NSMutableArray *)hotGoodsMarr {
    if (!_hotGoodsMarr) {
        _hotGoodsMarr = [NSMutableArray array];
    }
    return _hotGoodsMarr;
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

- (NSMutableArray *)subjectMarr {
    if (!_subjectMarr) {
        _subjectMarr = [NSMutableArray array];
    }
    return _subjectMarr;
}

- (NSMutableArray *)subjectIdMarr {
    if (!_subjectIdMarr) {
        _subjectIdMarr = [NSMutableArray array];
    }
    return _subjectIdMarr;
}

- (NSMutableArray *)subjectTypeMarr {
    if (!_subjectTypeMarr) {
        _subjectTypeMarr = [NSMutableArray array];
    }
    return _subjectTypeMarr;
}

- (NSMutableArray *)cageSubjectMarr {
    if (!_cageSubjectMarr) {
        _cageSubjectMarr = [NSMutableArray array];
    }
    return _cageSubjectMarr;
}

- (NSMutableArray *)cageSubjectIdMarr {
    if (!_cageSubjectIdMarr) {
        _cageSubjectIdMarr = [NSMutableArray array];
    }
    return _cageSubjectIdMarr;
}

- (NSMutableArray *)cageSubjectTypeMarr {
    if (!_cageSubjectTypeMarr) {
        _cageSubjectTypeMarr = [NSMutableArray array];
    }
    return _cageSubjectTypeMarr;
}

- (NSMutableArray *)sceneListMarr {
    if (!_sceneListMarr) {
        _sceneListMarr = [NSMutableArray array];
    }
    return _sceneListMarr;
}

- (NSMutableArray *)sceneIdMarr {
    if (!_sceneIdMarr) {
        _sceneIdMarr = [NSMutableArray array];
    }
    return _sceneIdMarr;
}

- (NSMutableArray *)userIdMarr {
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}

@end
