//
//  THNCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCategoryViewController.h"
#import "MallListGoodsCollectionViewCell.h"
#import "GoodsRow.h"
#import "ChildTagsTag.h"
#import "FBGoodsInfoViewController.h"
#import "NSString+JSON.h"
#import "CategoryRow.h"
#import "THNMallSubjectModelRow.h"
#import "THNMallListCollectionViewCell.h"

static NSString *const URLCategory = @"/category/getlist";
static NSString *const URLMallList = @"/product/getlist";
static NSString *const goodsListCellId = @"GoodsListCellId";
static NSString *const URLMallSubject = @"/scene_subject/getlist";
static NSString *const MallListCellId = @"mallListCellId";

@interface THNCategoryViewController () {
    NSString *_idx;
}

@end

@implementation THNCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self thn_networkCategoryData];
    [self thn_networkSubjectListData:self.categoryId];
    [self thn_networkGoodsListData:self.categoryId];
    [self setViewUI];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)thn_networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"1", @"page":@"1", @"size":@"10", @"use_cache":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.categoryMarr addObject:@"全部"];
        NSMutableArray *idxMarr = [NSMutableArray array];
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDict in dataArr) {
            CategoryRow *model = [[CategoryRow alloc] initWithDictionary:dataDict];
            [self.categoryMarr addObject:model.title];
            [idxMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        }
        
        NSString *allId = [idxMarr componentsJoinedByString:@","];
        [self.categoryIdMarr addObject:allId];
        [self.categoryIdMarr addObjectsFromArray:idxMarr];
        
        if (self.categoryMarr.count) {
            _idx = self.categoryId;
            self.menuView.menuTitle = self.categoryMarr;
            [self.menuView updateMenuButtonData];
            [self.menuView updateMenuBtnState:[self.categoryIdMarr indexOfObject:self.categoryId]];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 商品专题列表
- (void)thn_networkSubjectListData:(NSString *)categoryId {
    [self removeSubjectMarrData];
    
    NSDictionary *requestDic = @{@"category_id":categoryId,
                                 @"page":@"1",
                                 @"size":@"1",
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
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品列表
- (void)thn_networkGoodsListData:(NSString *)categoryId {
    [SVProgressHUD show];
    
    self.goodsListRequest = [FBAPI getWithUrlString:URLMallList requestDictionary:@{@"page":@(self.currentpageNum + 1),
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
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
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

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UICollectionView *)collectionView {
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self thn_networkGoodsListData:_idx];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.goodsList];
    [self.view addSubview:self.menuView];
}

#pragma mark - init
- (FBMenuView *)menuView {
    if (!_menuView) {
        if (SCREEN_HEIGHT == 812) {
            _menuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
        } else {
            _menuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        }
        _menuView.delegate = self;
        _menuView.defaultColor = @"#666666";
    }
    return _menuView;
}

- (void)menuItemSelectedWithIndex:(NSInteger)index {
    self.navViewTitle.text = self.categoryMarr[index];
    
    _idx = self.categoryIdMarr[index];
    
    [self.goodsIdMarr removeAllObjects];
    [self.goodsListMarr removeAllObjects];
    self.currentpageNum = 0;
    
    [self thn_networkGoodsListData:_idx];
    [self thn_networkSubjectListData:_idx];
}

- (void)removeSubjectMarrData {
    [self.subjectMarr removeAllObjects];
    [self.subjectIdMarr removeAllObjects];
    [self.subjectTypeMarr removeAllObjects];
}

- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
        [_goodsList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [self addMJRefresh:_goodsList];
    }
    return _goodsList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else
        return self.goodsListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId forIndexPath:indexPath];
        if (self.subjectMarr.count > 0) {
            [cell setMallSubjectData:self.subjectMarr[indexPath.row]];
            cell.nav = self.navigationController;
        } else {
            [cell thn_hiddenCellView];
        }
        return cell;
    }
    
    MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId forIndexPath:indexPath];
    if (self.goodsListMarr.count) {
        [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.subjectMarr.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, 366);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 0.01);
        }
    } else
        return CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        if (self.subjectMarr.count > 0) {
            return UIEdgeInsetsMake(15, 15, 0, 15);
        } else {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    } else
        return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
        goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = self.vcTitle;
    self.delegate = self;
}

#pragma mark - NSMutableArray
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


@end
