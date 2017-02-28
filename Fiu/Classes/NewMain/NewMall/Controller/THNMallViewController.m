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

static NSString *const URLMallList = @"/product/getlist";
static NSString *const URLNewGoodsList = @"/product/index_new";
static NSString *const URLCategory = @"/category/getlist";
static NSString *const URLMallSubject = @"/scene_subject/getlist";
static NSString *const DiscoverCellId = @"discoverCellId";
static NSString *const MallListCellId = @"mallListCellId";
static NSString *const CategoryGoodsListCellId = @"CategoryGoodsListCellId";
static NSString *const NewGoodsListCellId = @"newGoodsListCellId";
static NSString *const goodsListCellId = @"GoodsListCellId";

@interface THNMallViewController () {
    NSInteger   _type;
    BOOL        _rollDown;              //  是否下拉
    CGFloat     _lastContentOffset;     //  滚动的偏移量
    BOOL        _goTop;
    NSString   *_idx;
}

@end

@implementation THNMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self thn_setMallViewUI];
    [self networkCategoryData];
    [self thn_networkNewGoodsListData];
    [self thn_networkSubjectListData];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"1", @"page":@"1", @"size":@"10", @"use_cache":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.categoryMarr addObject:@"推荐"];
        [self.categoryMarr addObject:@"全部"];
        NSMutableArray *idxMarr = [NSMutableArray array];
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDict in dataArr) {
            CategoryRow *model = [[CategoryRow alloc] initWithDictionary:dataDict];
            [self.categoryMarr addObject:model.title];
            [idxMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        }
        
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

#pragma mark 推荐商品专题列表
- (void)thn_networkSubjectListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"100",
                                 @"sort":@"2",
                                 @"type":@"5",
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

- (void)requestIsLastData:(UICollectionView *)collectionView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        collectionView.mj_footer.hidden = true;
    }
    
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
    
    if ([collectionView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [collectionView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 分类商品专题列表
- (void)thn_networkCagetorySubjectListData:(NSString *)categoryId {
    NSDictionary *requestDic = @{@"category_id":categoryId,
                                 @"page":@"1",
                                 @"size":@"10",
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

#pragma mark - 设置视图UI
- (void)thn_setMallViewUI {
    _goTop = NO;
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.mallList];
    [self.view addSubview:self.goodsList];
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
    [self networkCategoryData];
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
    
    if (index > 0) {
        [self removeCategorySubjectMarrData];
        [self thn_networkCagetorySubjectListData:_idx];
        
        [self removeGoodsListMarrData];
        self.goodsCurrentpageNum = 0;
        [self thn_networkGoodsListData:_idx];
    }
}

- (void)changeCollectionViewFrame:(NSInteger)index {
    if (index > 0) {
        CGRect goodsRect = self.goodsList.frame;
        goodsRect = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
        CGRect mallRect = self.mallList.frame;
        mallRect = CGRectMake(-SCREEN_WIDTH, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
        [UIView animateWithDuration:0.3 animations:^{
            self.goodsList.frame = goodsRect;
            self.mallList.frame = mallRect;
        }];
        
    } else if (index == 0) {
        CGRect goodsRect = self.goodsList.frame;
        goodsRect = CGRectMake(SCREEN_WIDTH, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
        CGRect mallRect = self.mallList.frame;
        mallRect = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
        [UIView animateWithDuration:0.3 animations:^{
            self.goodsList.frame = goodsRect;
            self.mallList.frame = mallRect;
        }];
    }
}

#pragma mark - 好货列表
- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157) collectionViewLayout:flowLayou];
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
    
    return self.subjectMarr.count + 1;
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
            [cell setMallSubjectData:self.cageSubjectMarr[indexPath.row]];
            cell.nav = self.navigationController;
        } else {
            [cell thn_hiddenCellView];
        }
        return cell;
        
    } else if (collectionView == self.mallList) {
        if (indexPath.row == 0) {
            THNMallNewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewGoodsListCellId
                                                                                                forIndexPath:indexPath];
            if (self.goodsDataMarr.count) {
                [cell setNewGoodsData:self.goodsDataMarr];
            }
            cell.nav = self.navigationController;
            return cell;
            
        } else {
            THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                            forIndexPath:indexPath];
            if (self.subjectMarr.count) {
                [cell setMallSubjectData:self.subjectMarr[indexPath.row - 1]];
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
        if (indexPath.row == 0) {
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
            NSInteger type = [self.cageSubjectTypeMarr[indexPath.row] integerValue];
            NSString *subjectId = self.cageSubjectIdMarr[indexPath.row];
            [self openSubjectInfoController:type subjectId:subjectId];
        }
        
    } else if (collectionView == self.mallList) {
        if (indexPath.row != 0) {
            
            NSInteger type = [self.subjectTypeMarr[indexPath.row - 1] integerValue];
            NSString *subjectId = self.subjectIdMarr[indexPath.row - 1];
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


@end
