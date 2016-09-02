//
//  SearchSceneViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchSceneViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "THNSceneDetalViewController.h"

static NSString *const URLSearchList = @"/search/getlist";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";

static NSString *const SceneListCellId = @"sceneListCellId";

@interface SearchSceneViewController () {
    NSString *_keyword;
}

@end

@implementation SearchSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navView.hidden = YES;
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setSceneListViewUI];
}

#pragma mark - 网络请求
- (void)searchAgain:(NSString *)keyword {
    [self.searchSceneListMarr removeAllObjects];
    [self.searchSceneIdMarr removeAllObjects];
    self.currentpageNum = 0;
    [self networkSearchData:keyword];
}

- (void)networkSearchData:(NSString *)keyword {
    _keyword = keyword;
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":@"content", @"size":@"8", @"page":@(self.currentpageNum + 1), @"t":@"9" , @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.searchSceneListMarr addObject:homeSceneModel];
            [self.searchSceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        
        if (self.searchSceneListMarr.count) {
            self.noneLab.hidden = YES;
            self.sceneList.hidden = NO;
        } else {
            self.noneLab.hidden = NO;
            self.sceneList.hidden = YES;
        }
        
        [self.sceneList reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.sceneList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];

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

#pragma mark 点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.searchSceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.searchSceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.searchSceneListMarr[index] setValue:@"1" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.searchSceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.searchSceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.searchSceneListMarr[index] setValue:@"0" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图UI
- (void)thn_setSceneListViewUI {
    [self.view addSubview:self.sceneList];
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

- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _sceneList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108)
                                        collectionViewLayout:flowLayou];
        _sceneList.showsVerticalScrollIndicator = NO;
        _sceneList.delegate = self;
        _sceneList.dataSource = self;
        _sceneList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_sceneList registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:SceneListCellId];
        [self addMJRefresh:_sceneList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTheScene:) name:@"searchFindLikeTheScene" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLikeTheScene:) name:@"searchFindCancelLikeTheScene" object:nil];
    }
    return _sceneList;
}

#pragma mark - 点赞
- (void)likeTheScene:(NSNotification *)idx {
    [self thn_networkLikeSceneData:[idx object]];
}

- (void)cancelLikeTheScene:(NSNotification *)idx {
    [self thn_networkCancelLikeData:[idx object]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchSceneListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                          forIndexPath:indexPath];
    if (self.searchSceneListMarr.count) {
        [cell thn_setSceneUserInfoData:self.searchSceneListMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNSceneDetalViewController *sceneDataVC = [[THNSceneDetalViewController alloc] init];
    sceneDataVC.sceneDetalId = self.searchSceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:sceneDataVC animated:YES];
}

- (NSMutableArray *)searchSceneListMarr {
    if (!_searchSceneListMarr) {
        _searchSceneListMarr = [NSMutableArray array];
    }
    return _searchSceneListMarr;
}

- (NSMutableArray *)searchSceneIdMarr {
    if (!_searchSceneIdMarr) {
        _searchSceneIdMarr = [NSMutableArray array];
    }
    return _searchSceneIdMarr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchFindLikeTheScene" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchFindCancelLikeTheScene" object:nil];
}

@end
