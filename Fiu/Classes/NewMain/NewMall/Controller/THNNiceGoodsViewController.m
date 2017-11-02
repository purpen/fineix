//
//  THNNiceGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNNiceGoodsViewController.h"
#import "THNMallSubjectModelRow.h"
#import "THNMallListCollectionViewCell.h"
#import "FBRefresh.h"
#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"

static NSString *const MallListCellId = @"mallListCellId";
static NSString *const URLMallSubject = @"/scene_subject/getlist";

@interface THNNiceGoodsViewController () {
    NSInteger _type;
}

@end

@implementation THNNiceGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.isIndex, -64 * self.isIndex, SCREEN_WIDTH, SCREEN_HEIGHT - (157 * self.isIndex));
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mallList];
    self.currentpageNum = 0;
    [self thn_networkSubjectListData];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    if (Is_iPhoneX) {
        self.mallList.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT - (self.isIndex == 0 ? 88 : 190));
    }
}

#pragma mark 商品专题列表
- (void)thn_networkSubjectListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@(self.currentpageNum + 1),
                                 @"size":@"10",
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
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.mallList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
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
            [self thn_networkSubjectListData];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - init
- (UICollectionView *)mallList {
    if (!_mallList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _mallList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - (self.isIndex == 0 ? 64 : 157))
                                       collectionViewLayout:flowLayou];
        _mallList.showsVerticalScrollIndicator = NO;
        _mallList.delegate = self;
        _mallList.dataSource = self;
        _mallList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_mallList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [self addMJRefresh:_mallList];
    }
    return _mallList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subjectMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                    forIndexPath:indexPath];
    if (self.subjectMarr.count) {
        [cell setMallSubjectData:self.subjectMarr[indexPath.row]];
    }
    cell.nav = self.navigationController;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, 366);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _type = [self.subjectTypeMarr[indexPath.row] integerValue];
    
    if (_type == 1) {
        THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
        articleVC.articleDetalid = self.subjectIdMarr[indexPath.row];
        [self.navigationController pushViewController:articleVC animated:YES];
        
    } else if (_type == 2) {
        THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
        activity.activeDetalId = self.subjectIdMarr[indexPath.row];
        [self.navigationController pushViewController:activity animated:YES];
        
    } else if (_type == 3) {
        THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
        cuXiao.cuXiaoDetalId = self.subjectIdMarr[indexPath.row];
        cuXiao.vcType = 1;
        [self.navigationController pushViewController:cuXiao animated:YES];
        
    } else if (_type == 4) {
        THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
        xinPin.xinPinDetalId = self.subjectIdMarr[indexPath.row];
        [self.navigationController pushViewController:xinPin animated:YES];
        
    } else if (_type == 5) {
        THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
        cuXiao.cuXiaoDetalId = self.subjectIdMarr[indexPath.row];
        cuXiao.vcType = 2;
        [self.navigationController pushViewController:cuXiao animated:YES];
        
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"好货合集";
}

#pragma mark - NSMutableArray
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
