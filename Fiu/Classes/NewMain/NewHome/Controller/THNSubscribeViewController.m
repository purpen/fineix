//
//  THNSubscribeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSubscribeViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "HomeSceneListRow.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "THNSceneListViewController.h"
#import "THNSenceTopicViewController.h"

static NSString *const URLSubCount = @"/auth/user";
static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLLikeScene = @"/favorite/ajax_sight_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_sight_love";

static NSString *const SceneListCellId = @"sceneListCellId";

@interface THNSubscribeViewController () {
    NSString *_categoryIds;
    NSArray *_subscribeArr;
}

@end

@implementation THNSubscribeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    [self thn_networkSubCountData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _categoryIds = [self getLoginUserInterestSceneCate];
    [self thn_setDiscoverViewUI];
    [self thn_networkSceneListData];
}

#pragma mark - 网络请求
#pragma mark 订阅主题数量
- (void)thn_networkSubCountData {
    self.subscribeCountRequest = [FBAPI getWithUrlString:URLSubCount requestDictionary:@{} delegate:self];
    [self.subscribeCountRequest startRequestSuccess:^(FBRequest *request, id result) {
        _subscribeArr = [[result valueForKey:@"data"] valueForKey:@"interest_scene_cate"];
        [self.lookAllSubscribe setTitle:[NSString stringWithFormat:@"%@%zi%@", NSLocalizedString(@"SubscribeDone", nil), _subscribeArr.count, NSLocalizedString(@"SubscribeScene", nil)] forState:(UIControlStateNormal)];
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx} delegate:self];
    [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 情景列表
- (void)thn_networkSceneListData {
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1),
                                                                                     @"size":@"10",
                                                                                     @"category_ids":_categoryIds,
                                                                                     @"sort":@"0"} delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        
        [self.commentsMarr addObjectsFromArray:[sceneArr valueForKey:@"comments"]];
        
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
    [self.view addSubview:self.lookAllSubscribe];
}

#pragma mark - init
- (UIButton *)lookAllSubscribe {
    if (!_lookAllSubscribe) {
        _lookAllSubscribe = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        [_lookAllSubscribe setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _lookAllSubscribe.titleLabel.font = [UIFont systemFontOfSize:14];
        _lookAllSubscribe.backgroundColor = [UIColor whiteColor];
        _lookAllSubscribe.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_lookAllSubscribe setTitleEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        [_lookAllSubscribe setImage:[UIImage imageNamed:@"icon_Next"] forState:(UIControlStateNormal)];
        [_lookAllSubscribe setImageEdgeInsets:(UIEdgeInsetsMake(0, SCREEN_WIDTH - 25, 0, 0))];
        [_lookAllSubscribe addTarget:self action:@selector(lookAllSubscribeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookAllSubscribe;
}

- (void)lookAllSubscribeClick:(UIButton *)button {
    THNSenceTopicViewController *sceneTopicVC = [[THNSenceTopicViewController alloc] init];
    [self.navigationController pushViewController:sceneTopicVC animated:YES];
}

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTheScene:) name:@"subFindLikeTheScene" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLikeTheScene:) name:@"subFindCancelLikeTheScene" object:nil];
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
        [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row] type:3];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"打开情景：%@",self.sceneIdMarr[indexPath.row]]];
    THNSceneListViewController *sceneListVC = [[THNSceneListViewController alloc] init];
    sceneListVC.sceneListMarr = self.sceneListMarr;
    sceneListVC.commentsMarr = self.commentsMarr;
    sceneListVC.sceneIdMarr = self.sceneIdMarr;
    sceneListVC.userIdMarr = self.userIdMarr;
    sceneListVC.index = indexPath.row;
    [self.navigationController pushViewController:sceneListVC animated:YES];
}

#pragma mark - 点赞
- (void)likeTheScene:(NSNotification *)idx {
    [self thn_networkLikeSceneData:[idx object]];
}

- (void)cancelLikeTheScene:(NSNotification *)idx {
    [self thn_networkCancelLikeData:[idx object]];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    self.navViewTitle.text = NSLocalizedString(@"SubscribeVC", nil);
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

- (NSMutableArray *)commentsMarr {
    if (!_commentsMarr) {
        _commentsMarr = [NSMutableArray array];
    }
    return _commentsMarr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"subFindLikeTheScene" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"subFindCancelLikeTheScene" object:nil];
}

@end
