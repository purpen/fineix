//
//  THNDiscoverViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"
#import "HomeSceneListRow.h"
#import "THNCategoryCollectionReusableView.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "FiuPeopleListViewController.h"

static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLCategory = @"/category/getlist";

static NSString *const DiscoverCellId = @"discoverCellId";
static NSString *const SceneListCellId = @"sceneListCellId";
static NSString *const SceneListHeaderCellViewId = @"sceneListHeaderViewId";

@interface THNDiscoverViewController ()

@end

@implementation THNDiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setDiscoverViewUI];
    [self networkCategoryData];
    [self thn_networkSceneListData];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"13", @"page":@"1", @"size":@"10"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.categoryMarr = [NSMutableArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"rows"]];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 情景列表
- (void)thn_networkSceneListData {
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@10, @"sort":@"0"} delegate:self];
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
    FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    collectionView.mj_header = header;
    
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self thn_networkSceneListData];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadNewData {
    self.currentpageNum = 0;
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self thn_networkSceneListData];
}

#pragma mark - 设置视图UI
- (void)thn_setDiscoverViewUI {
    [self.view addSubview:self.sceneList];
}

#pragma mark - init
- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayou.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 224);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _sceneList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113)
                                        collectionViewLayout:flowLayou];
        _sceneList.showsVerticalScrollIndicator = NO;
        _sceneList.delegate = self;
        _sceneList.dataSource = self;
        _sceneList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_sceneList registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:SceneListCellId];
        [_sceneList registerClass:[THNCategoryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:SceneListHeaderCellViewId];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    THNCategoryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:SceneListHeaderCellViewId
                                                                                              forIndexPath:indexPath];
    if (self.categoryMarr.count) {
        [headerView setCategoryData:self.categoryMarr type:0];
    }
    headerView.nav = self.navigationController;
    
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"打开情景：%@",self.sceneIdMarr[indexPath.row]]];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addSearchBtnText:NSLocalizedString(@"discoverSearch", nil) type:1];
    [self thn_addBarItemLeftBarButton:@"" image:@"discover_user"];
    [self thn_addBarItemRightBarButton:@"" image:@"discover_ranking"];
}

- (void)thn_leftBarItemSelected {
    [SVProgressHUD showSuccessWithStatus:@"加好友"];
//    SearchViewController * searchVC = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    FiuPeopleListViewController * peopleListVC = [[FiuPeopleListViewController alloc] init];
    [self.navigationController pushViewController:peopleListVC animated:YES];
}

#pragma mark - NSMutableArray
- (NSMutableArray *)categoryMarr {
    if (!_categoryMarr) {
        _categoryMarr = [NSMutableArray array];
    }
    return _categoryMarr;
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
