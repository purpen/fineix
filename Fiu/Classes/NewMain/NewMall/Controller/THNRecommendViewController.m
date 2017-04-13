//
//  THNRecommendViewController.m
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRecommendViewController.h"
#import "THNMallGoodsModelItem.h"
#import "THNMallSubjectModelRow.h"
#import "THNMallListCollectionViewCell.h"
#import "THNMallNewGoodsCollectionViewCell.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"

#import <MJRefresh/MJRefresh.h>
#import "FBRefresh.h"

static NSString *const URLNewGoodsList    = @"/product/index_new";
static NSString *const URLHotGoodsList    = @"/product/index_hot";
static NSString *const URLMallSubject     = @"/scene_subject/getlist";
static NSString *const NewGoodsListCellId = @"newGoodsListCellId";
static NSString *const MallListCellId     = @"mallListCellId";

@interface THNRecommendViewController ()

@end

@implementation THNRecommendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setViewUI];
}

#pragma mark -
#pragma mark 最新商品列表
- (void)thn_networkNewGoodsListData {
    self.newestGoodsRequest = [FBAPI getWithUrlString:URLNewGoodsList requestDictionary:@{@"type":@"1", @"use_cache":@"1"} delegate:self];
    [self.newestGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.newestGoodsMarr removeAllObjects];
        
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.newestGoodsMarr addObject:goodsModel];
        }
    
        [self.recommendList reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 最热商品列表
- (void)thn_networkHotGoodsListData {
    self.hotGoodsRequest = [FBAPI getWithUrlString:URLHotGoodsList requestDictionary:@{@"type":@"1"} delegate:self];
    [self.hotGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.hotGoodsMarr removeAllObjects];
        
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.hotGoodsMarr addObject:goodsModel];
        }
    
        [self.recommendList reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 推荐商品专题列表
- (void)thn_networkSubjectListData {
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"5",
                                 @"sort":@"1",
                                 @"type":@"5",
                                 @"stick":@"1",
                                 @"use_cache":@"1"};
    self.subjectRequest = [FBAPI getWithUrlString:URLMallSubject requestDictionary:requestDic delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self thn_removeSubjectObjects];
        
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallSubjectModelRow *goodsModel = [[THNMallSubjectModelRow alloc] initWithDictionary:goodsDic];
            [self.subjectMarr addObject:goodsModel];
            [self.subjectTypeMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.type]];
            [self.subjectIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.recommendList reloadData];
        [self thn_stopRefresh];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)thn_removeSubjectObjects {
    [self.subjectMarr removeAllObjects];
    [self.subjectIdMarr removeAllObjects];
    [self.subjectTypeMarr removeAllObjects];
}

- (void)thn_stopRefresh {
     [self.recommendList.mj_header endRefreshing];
}

#pragma mark - 视图
- (void)thn_setViewUI {
    [self.view addSubview:self.recommendList];
    
    [self thn_networkNewGoodsListData];
    [self thn_networkHotGoodsListData];
    [self thn_networkSubjectListData];
}

#pragma mark 好货列表
- (UICollectionView *)recommendList {
    if (!_recommendList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _recommendList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157)
                                       collectionViewLayout:flowLayou];
        _recommendList.showsVerticalScrollIndicator = NO;
        _recommendList.delegate = self;
        _recommendList.dataSource = self;
        _recommendList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_recommendList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [_recommendList registerClass:[THNMallNewGoodsCollectionViewCell class] forCellWithReuseIdentifier:NewGoodsListCellId];
        [self addHeaderMJRefresh:_recommendList];
    }
    return _recommendList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subjectMarr.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                        forIndexPath:indexPath];
        if (self.subjectMarr.count) {
            [cell setMallSubjectData:self.subjectMarr[indexPath.row - 2]];
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else {
        THNMallNewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewGoodsListCellId
                                                                                            forIndexPath:indexPath];
        if (self.newestGoodsMarr.count) {
            if (indexPath.row == 0) {
                [cell setNewGoodsData:self.newestGoodsMarr];
            } else if (indexPath.row == 1) {
                [cell setHotGoodsData:self.hotGoodsMarr];
            }
        }
        cell.nav = self.navigationController;
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        return CGSizeMake(SCREEN_WIDTH, 366);
    } else
        return CGSizeMake(SCREEN_WIDTH, 230);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        NSInteger type = [self.subjectTypeMarr[indexPath.row - 2] integerValue];
        NSString *subjectId = self.subjectIdMarr[indexPath.row - 2];
        [self openSubjectInfoController:type subjectId:subjectId];
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

#pragma mark - 下拉刷新
- (void)addHeaderMJRefresh:(UICollectionView *)collectionView {
    FBRefresh *header = [FBRefresh headerWithRefreshingBlock:^{
        [self thn_loadRecommendListData];
    }];
    collectionView.mj_header = header;
}

- (void)thn_loadRecommendListData {
    [self thn_networkNewGoodsListData];
    [self thn_networkHotGoodsListData];
    [self thn_networkSubjectListData];
}

#pragma mark - NSMutableArray
- (NSMutableArray *)newestGoodsMarr {
    if (!_newestGoodsMarr) {
        _newestGoodsMarr = [NSMutableArray array];
    }
    return _newestGoodsMarr;
}

- (NSMutableArray *)hotGoodsMarr {
    if (!_hotGoodsMarr) {
        _hotGoodsMarr = [NSMutableArray array];
    }
    return _hotGoodsMarr;
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
