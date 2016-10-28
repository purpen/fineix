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
#import "THNSceneListViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNLoginRegisterViewController.h"

static NSString *const URLSubCount = @"/auth/user";
static NSString *const URLAddTheme = @"/my/add_interest_scene_id";
static NSString *const URLRemTheme = @"/my/remove_interest_scene_id";
static NSString *const SceneListCellId = @"sceneListCellId";
static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";

@interface DiscoverCategoryViewController () {
    NSString *_sort;
    NSArray *_subscribeArr;
}

@end

@implementation DiscoverCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    [self thn_networkSubCountData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sort = @"2";
    self.currentpageNum = 0;
    [self thn_networkSceneListData:_sort];

    [self setViewUI];
}

#pragma mark 网络请求
//  点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
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

//  取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
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

#pragma mark 订阅主题数量
- (void)thn_networkSubCountData {
    self.subscribeCountRequest = [FBAPI getWithUrlString:URLSubCount requestDictionary:@{} delegate:self];
    [self.subscribeCountRequest startRequestSuccess:^(FBRequest *request, id result) {
        _subscribeArr = [[result valueForKey:@"data"] valueForKey:@"interest_scene_cate"];
        NSMutableArray *subMarr = [NSMutableArray array];
        for (NSNumber *idx in _subscribeArr) {
            [subMarr addObject:[NSString stringWithFormat:@"%@", idx]];
        }
        
        if ([subMarr containsObject:self.categoryId]) {
            self.subscribeBtn.selected = YES;
        } else {
            self.subscribeBtn.selected = NO;
        }

    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)thn_AddOrRemThemeData:(NSInteger)type {
    if (type == 1) {
        self.suThemeRequest = [FBAPI postWithUrlString:URLAddTheme requestDictionary:@{@"id":self.categoryId} delegate:self];
    } else if (type == 2) {
        self.suThemeRequest = [FBAPI postWithUrlString:URLRemTheme requestDictionary:@{@"id":self.categoryId} delegate:self];
    }
    [self.suThemeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if (type == 1) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"subscribeSuccess", nil)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)thn_networkSceneListData:(NSString *)sort {
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1),
                                                                                     @"size":@"10",
                                                                                     @"sort":sort,
                                                                                     @"category_ids":self.categoryId
                                                                                     } delegate:self];
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
    
    __weak __typeof(self)weakSelf = self;
    
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                          forIndexPath:indexPath];
    if (self.sceneListMarr.count) {
        [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row] isLogin:[self isUserLogin]];
        
        cell.beginLikeTheSceneBlock = ^(NSString *idx) {
            [weakSelf thn_networkLikeSceneData:idx];
        };
        
        cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
            [weakSelf thn_networkCancelLikeData:idx];
        };
    }
    cell.vc = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNSceneDetalViewController *sceneDataVC = [[THNSceneDetalViewController alloc] init];
    sceneDataVC.sceneDetalId = self.sceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:sceneDataVC animated:YES];
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
    [self.subscribeBtn addTarget:self action:@selector(subscribeBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)subscribeBtnClick:(UIButton *)button {
    if ([self isUserLogin]) {
        if (button.selected == NO) {
            button.selected = YES;
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
            scaleAnimation.springBounciness = 10.f;
            scaleAnimation.springSpeed = 10.0f;
            [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            button.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
            button.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
            
            [self thn_AddOrRemThemeData:1];
            
        } else if (button.selected == YES) {
            button.selected = NO;
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
            scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
            scaleAnimation.springBounciness = 10.f;
            scaleAnimation.springSpeed = 10.0f;
            [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
            button.layer.borderColor = [UIColor colorWithHexString:WHITE_COLOR alpha:0.6].CGColor;
            button.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
            
            [self thn_AddOrRemThemeData:2];
        }
    
    } else {
        THNLoginRegisterViewController * loginSignupVC = [[THNLoginRegisterViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
        [self presentViewController:navi animated:YES completion:nil];
    }
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


@end
