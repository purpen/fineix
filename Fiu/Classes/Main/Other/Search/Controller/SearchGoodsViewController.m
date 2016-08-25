//
//  SearchGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "MallListGoodsCollectionViewCell.h"
#import "GoodsRow.h"
#import "FBGoodsInfoViewController.h"

static NSString *const URLSearchList = @"/search/getlist";
static NSString *const goodsListCellId = @"GoodsListCellId";

@interface SearchGoodsViewController () {
    NSString *_keyword;
}

@end

@implementation SearchGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navView.hidden = YES;
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewUI];
}

#pragma mark - 网络请求
- (void)searchAgain:(NSString *)keyword {
    [self.goodsListMarr removeAllObjects];
    [self.goodsIdMarr removeAllObjects];
    self.currentpageNum = 0;
    [self networkSearchData:keyword];
}

- (void)networkSearchData:(NSString *)keyword {
    _keyword = keyword;
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":@"content",
                                                                                       @"size":@"8",
                                                                                       @"page":@(self.currentpageNum + 1),
                                                                                       @"t":@"3",
                                                                                       @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        if (self.goodsListMarr.count) {
            self.noneLab.hidden = YES;
            self.goodsList.hidden = NO;
        } else {
            self.noneLab.hidden = NO;
            self.goodsList.hidden = YES;
        }
        
        [self.goodsList reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
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
    if ([collectionView.mj_header isRefreshing]) {
        CGPoint tableY = collectionView.contentOffset;
        tableY.y = 0;
        if (collectionView.bounds.origin.y > 0) {
            [UIView animateWithDuration:.3 animations:^{
                collectionView.contentOffset = tableY;
            }];
        }
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

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UICollectionView *)collectionView {
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkSearchData:_keyword];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.goodsList];
    [self.view addSubview:self.noneLab];
}

#pragma mark - init
#pragma mark - 没有搜索结果
- (UILabel *)noneLab {
    if (!_noneLab) {
        _noneLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _noneLab.textAlignment = NSTextAlignmentCenter;
        _noneLab.textColor = [UIColor colorWithHexString:titleColor];
        _noneLab.font = [UIFont systemFontOfSize:12];
        _noneLab.text = NSLocalizedString(@"noneSearch", nil);
    }
    return _noneLab;
}

- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108)
                                        collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
        [self addMJRefresh:_goodsList];
    }
    return _goodsList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId
                                                                                       forIndexPath:indexPath];
    if (self.goodsListMarr.count) {
        [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
    [self.navigationController pushViewController:goodsVC animated:YES];
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

@end
