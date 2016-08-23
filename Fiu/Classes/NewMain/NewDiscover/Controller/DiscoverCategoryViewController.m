//
//  DiscoverCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DiscoverCategoryViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "HomeSceneListRow.h"

static NSString *const SceneListCellId = @"sceneListCellId";
static NSString *const URLSceneList = @"/scene_sight/";

@interface DiscoverCategoryViewController () {
    NSString *_sort;
}

@end

@implementation DiscoverCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sort = @"2";
    [self thn_networkSceneListData:_sort];
    [self setViewUI];
}

#pragma mark 情景列表
- (void)thn_networkSceneListData:(NSString *)sort {
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1),
                                                                                     @"size":@10,
                                                                                     @"sort":sort
//                                                                                     @"category_ids":self.categoryId
                                                                                     } delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        
        [self.sceneList reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.sceneList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
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
            [self thn_networkSceneListData:_sort];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.sceneList];
}

#pragma mark - init
- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _sceneList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)
                                        collectionViewLayout:flowLayou];
        _sceneList.showsVerticalScrollIndicator = NO;
        _sceneList.delegate = self;
        _sceneList.dataSource = self;
        _sceneList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_sceneList registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:SceneListCellId];
        [self addMJRefresh:_sceneList];
    }
    return _sceneList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                          forIndexPath:indexPath];
    if (self.sceneListMarr.count) {
        [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"打开情景：%@",self.sceneIdMarr[indexPath.row]]];
}


- (FBSegmentView *)menuView {
    if (!_menuView) {
        NSArray *titleArr = @[NSLocalizedString(@"fineScene", nil), NSLocalizedString(@"newScene", nil)];
        _menuView = [[FBSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        [_menuView set_menuItemTitle:titleArr];
        [_menuView set_showBottomLine:YES];
    }
    return _menuView;
}

- (void)menuItemSelected:(NSInteger)index {
    [self.sceneIdMarr removeAllObjects];
    [self.sceneListMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    
    if (index == 0) {
        _sort = @"2";
    } else {
        _sort = @"0";
    }
    self.currentpageNum = 0;
    [self thn_networkSceneListData:_sort];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = self.vcTitle;
    self.delegate = self;
    [self thn_addSubscribeBtn];
}

#pragma mark - NSMutableArray
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
