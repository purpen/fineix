//
//  THNMallGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNMallGoodsViewController.h"
#import "GoodsRow.h"
#import "THNMallListCollectionViewCell.h"
#import "THNMallNewGoodsCollectionViewCell.h"
#import "MallListGoodsCollectionViewCell.h"
#import "FBGoodsInfoViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"

#import <MJRefresh/MJRefresh.h>

static NSString *const URLMallList    = @"/product/getlist";
static NSString *const URLMallSubject = @"/scene_subject/getlist";

static NSString *const DiscoverCellId           = @"discoverCellId";
static NSString *const GoodsListCellId          = @"GoodsListCellId";
static NSString *const CategoryGoodsListCellId  = @"CategoryGoodsListCellId";

@interface THNMallGoodsViewController () {
    NSString *_categoryIdx;
}

@end

@implementation THNMallGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setViewUI];
}

#pragma mark - 开始请求网络
- (void)thn_getCategoryGoodsListData:(NSString *)idx {
    _categoryIdx = idx;
    
    [self thn_removeCategorySubjectMarrData];
    [self thn_removeGoodsListMarrData];
    
    self.goodsCurrentpageNum = 0;
    [self thn_networkGoodsListData:idx];
    [self thn_networkCagetorySubjectListData:idx];
}

#pragma mark - 清空数据
- (void)thn_removeCategorySubjectMarrData {
    [self.cageSubjectMarr removeAllObjects];
    [self.cageSubjectIdMarr removeAllObjects];
    [self.cageSubjectTypeMarr removeAllObjects];
}

- (void)thn_removeGoodsListMarrData {
    [self.goodsIdMarr removeAllObjects];
    [self.goodsListMarr removeAllObjects];
}

#pragma mark - 分类商品列表
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

#pragma mark 分类商品专题列表
- (void)thn_networkCagetorySubjectListData:(NSString *)categoryId {
    NSDictionary *requestDic = @{@"category_id":categoryId,
                                 @"page":@"1",
                                 @"size":@"1",
                                 @"sort":@"0",
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

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)addFooterMJRefresh:(UICollectionView *)collectionView {
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.goodsCurrentpageNum < self.goodsTotalPageNum) {
                [self thn_networkGoodsListData:_categoryIdx];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置视图
- (void)thn_setViewUI {
    [self.view addSubview:self.goodsList];
}

#pragma mark - 商品列表
- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;

        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157) collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:GoodsListCellId];
        [_goodsList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:CategoryGoodsListCellId];
        [self addFooterMJRefresh:_goodsList];
    }
    return _goodsList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.goodsList) {
        return self.cageSubjectMarr.count + 1;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == self.cageSubjectMarr.count) {
        return self.goodsListMarr.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.cageSubjectMarr.count) {
        MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListCellId forIndexPath:indexPath];
        if (self.goodsListMarr.count) {
            [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
        }
        return cell;
    
    } else {
        THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryGoodsListCellId forIndexPath:indexPath];
        if (self.cageSubjectMarr.count > 0) {
            [cell setMallSubjectData:self.cageSubjectMarr[indexPath.section]];
            cell.nav = self.navigationController;
        } else {
            [cell thn_hiddenCellView];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.cageSubjectMarr.count) {
        return CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        
    } else {
        if (self.cageSubjectMarr.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, 366);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 0.01);
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == self.cageSubjectMarr.count) {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.cageSubjectMarr.count) {
        FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
        goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
        [self.navigationController pushViewController:goodsVC animated:YES];
        
    } else {
        NSInteger type = [self.cageSubjectTypeMarr[indexPath.section] integerValue];
        NSString *subjectId = self.cageSubjectIdMarr[indexPath.section];
        [self openSubjectInfoController:type subjectId:subjectId];
    }
}

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
