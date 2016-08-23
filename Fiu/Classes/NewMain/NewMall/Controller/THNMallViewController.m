//
//  THNMallViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallViewController.h"
#import "THNCategoryCollectionReusableView.h"
#import "THNMallNewGoodsCollectionViewCell.h"
#import "THNMallListCollectionViewCell.h"
#import "GoodsCarViewController.h"
#import "QRCodeScanViewController.h"
#import "THNMallGoodsModelItem.h"
#import "THNMallSubjectModelRow.h"

static NSString *const URLNewGoodsList = @"/scene_product/index_new";
static NSString *const URLCategory = @"/category/getlist";
static NSString *const URLMallSubject = @"/scene_subject/getlist";

static NSString *const DiscoverCellId = @"discoverCellId";
static NSString *const MallListCellId = @"mallListCellId";
static NSString *const NewGoodsListCellId = @"newGoodsListCellId";
static NSString *const MallListHeaderCellViewId = @"mallListHeaderCellViewId";

@implementation THNMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self networkCategoryData];
    [self thn_networkNewGoodsListData];
    [self thn_networkSubjectListData];
    [self thn_setMallViewUI];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"10", @"page":@"1", @"size":@"10"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.categoryMarr = [NSMutableArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"rows"]];
        if (self.categoryMarr.count) {
            [self thn_networkNewGoodsListData];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 最新商品列表
- (void)thn_networkNewGoodsListData {
    self.mallListRequest = [FBAPI getWithUrlString:URLNewGoodsList requestDictionary:@{@"type":@"1"} delegate:self];
    [self.mallListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.goodsDataMarr addObject:goodsModel];
        }
    
        [self.mallList reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品专题列表
- (void)thn_networkSubjectListData {
    self.subjectRequest = [FBAPI getWithUrlString:URLMallSubject requestDictionary:@{@"page":@"1", @"size":@"100", @"sort":@"2", @"type":@"5", @"fine":@"1"} delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallSubjectModelRow *goodsModel = [[THNMallSubjectModelRow alloc] initWithDictionary:goodsDic];
            [self.subjectMarr addObject:goodsModel];
        }
        
        [self.mallList reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图UI
- (void)thn_setMallViewUI {
    [self.view addSubview:self.mallList];
}

#pragma mark - init
- (UICollectionView *)mallList {
    if (!_mallList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake(SCREEN_WIDTH, 190);
        flowLayou.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 224);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _mallList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113)
                                        collectionViewLayout:flowLayou];
        _mallList.showsVerticalScrollIndicator = NO;
        _mallList.delegate = self;
        _mallList.dataSource = self;
        _mallList.backgroundColor = [UIColor whiteColor];
        [_mallList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [_mallList registerClass:[THNMallNewGoodsCollectionViewCell class] forCellWithReuseIdentifier:NewGoodsListCellId];
        [_mallList registerClass:[THNCategoryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:MallListHeaderCellViewId];
//        [self addMJRefresh:_mallList];
    }
    return _mallList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subjectMarr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNMallNewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewGoodsListCellId
                                                                                forIndexPath:indexPath];
        if (self.goodsDataMarr.count) {
            [cell setNewGoodsData:self.goodsDataMarr];
        }
        return cell;
        
    } else {
        THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                forIndexPath:indexPath];
        if (self.subjectMarr.count) {
            [cell setMallSubjectData:self.subjectMarr[indexPath.row-1]];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH, 190);
    } else
        return CGSizeMake(SCREEN_WIDTH, 366);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    THNCategoryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:MallListHeaderCellViewId
                                                                                              forIndexPath:indexPath];
    if (self.categoryMarr.count) {
        [headerView setCategoryData:self.categoryMarr type:1];
    }
    headerView.nav = self.navigationController;
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        [SVProgressHUD showSuccessWithStatus:@"打开商品专题，查看全部"];
    }
}


#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addSearchBtnText:NSLocalizedString(@"mallSearch", nil) type:2];
    [self thn_addBarItemLeftBarButton:@"" image:@"mall_saoma"];
    [self thn_addBarItemRightBarButton:@"" image:@"mall_car"];
}

- (void)thn_leftBarItemSelected {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

#pragma mark - NSMutableArray
- (NSMutableArray *)goodsDataMarr {
    if (!_goodsDataMarr) {
        _goodsDataMarr = [NSMutableArray array];
    }
    return _goodsDataMarr;
}

- (NSMutableArray *)subjectMarr {
    if (!_subjectMarr) {
        _subjectMarr = [NSMutableArray array];
    }
    return _subjectMarr;
}

@end
