//
//  THNDiscoverViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"
#import "HomeSceneListRow.h"
#import "THNMallSubjectModelRow.h"
#import "THNCategoryCollectionReusableView.h"
#import "THNHotActionCollectionReusableView.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "FiuPeopleListViewController.h"
#import "THNSceneListViewController.h"
#import "FindeFriendViewController.h"

static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLCategory = @"/category/getlist";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const URLSubject = @"/scene_subject/getlist";

static NSString *const DiscoverCellId = @"discoverCellId";
static NSString *const SceneListCellId = @"sceneListCellId";
static NSString *const SceneListHeaderCellViewId = @"sceneListHeaderViewId";
static NSString *const SceneListFooterCellViewId = @"sceneListFooterViewId";

@interface THNDiscoverViewController ()

@end

@implementation THNDiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setDiscoverViewUI];
    [self networkCategoryData];
    self.currentpageNum = 0;
    [self thn_networkSceneListData];
    [self thn_networkSubjectData];
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

#pragma mark 点赞
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

#pragma mark 取消点赞
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

#pragma mark 专题
- (void)thn_networkSubjectData {
    self.subjectRequest = [FBAPI getWithUrlString:URLSubject requestDictionary:@{@"page":@"1",
                                                                                 @"size":@"2",
                                                                                 @"fine":@"1",
                                                                                 @"sort":@"0",
                                                                                 @"type":@"1,2"} delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *subArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * subjectDic in subArr) {
            THNMallSubjectModelRow *subjectModel = [[THNMallSubjectModelRow alloc] initWithDictionary:subjectDic];
            [self.subjectMarr addObject:subjectModel];
            [self.subjectTypeMarr addObject:[NSString stringWithFormat:@"%zi",subjectModel.type]];
            [self.subjectIdMarr addObject:[NSString stringWithFormat:@"%zi",subjectModel.idField]];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 情景列表
- (void)thn_networkSceneListData {
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@"30", @"sort":@"0"} delegate:self];
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
}

#pragma mark - init
- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);

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
        
        [_sceneList registerClass:[THNHotActionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:SceneListFooterCellViewId];
        
        [self addMJRefresh:_sceneList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTheScene:) name:@"findLikeTheScene" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLikeTheScene:) name:@"findCancelLikeTheScene" object:nil];
    }
    return _sceneList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else if (section == 1) {
        return 10;
    } else if (section == 2) {
        if (self.sceneListMarr.count) {
            return self.sceneListMarr.count - 20;
        }
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                              forIndexPath:indexPath];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row]];
        }
        return cell;
        
    } else if (indexPath.section == 1) {
        THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                              forIndexPath:indexPath];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row + 10]];
        }
        return cell;
    
    } else {
        THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                              forIndexPath:indexPath];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row + 20]];
        }
        return cell;
    }
    return nil;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            THNCategoryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                               withReuseIdentifier:SceneListHeaderCellViewId
                                                                                                      forIndexPath:indexPath];
            if (self.categoryMarr.count) {
                [headerView setCategoryData:self.categoryMarr type:0];
            }
            headerView.nav = self.navigationController;
            
            return headerView;
        }
        
    } else {
        if (indexPath.section == 0 || indexPath.section == 1) {
            THNHotActionCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                withReuseIdentifier:SceneListFooterCellViewId
                                                                                                       forIndexPath:indexPath];
            
            if (self.subjectMarr.count) {
                if (indexPath.section == 0) {
                    [footerView thn_setSubjectModel:self.subjectMarr[0]];
                } else if (indexPath.section == 1) {
                    [footerView thn_setSubjectModel:self.subjectMarr[1]];
                }
            }
            footerView.nav = self.navigationController;
            
            return footerView;
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *0.56 + 30);
    } else
        return CGSizeMake(SCREEN_WIDTH, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 224);
    } else
        return CGSizeMake(SCREEN_WIDTH, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addSearchBtnText:NSLocalizedString(@"discoverSearch", nil) type:1];
    [self thn_addBarItemLeftBarButton:@"" image:@"discover_user"];
    [self thn_addBarItemRightBarButton:@"" image:@"discover_ranking"];
}

- (void)thn_leftBarItemSelected {
    FindeFriendViewController * searchVC = [[FindeFriendViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    FiuPeopleListViewController * peopleListVC = [[FiuPeopleListViewController alloc] init];
    [self.navigationController pushViewController:peopleListVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"discoverLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"discoverLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"faxian_tianjia",@"faxian_paihangbang"]];
    }
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

- (NSMutableArray *)commentsMarr {
    if (!_commentsMarr) {
        _commentsMarr = [NSMutableArray array];
    }
    return _commentsMarr;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"findLikeTheScene" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"findCancelLikeTheScene" object:nil];
}

@end
