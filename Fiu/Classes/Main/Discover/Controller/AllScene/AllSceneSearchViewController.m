//
//  AllSceneSearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllSceneSearchViewController.h"
#import "SelectAllFSceneCollectionViewCell.h"
#import "FiuSceneViewController.h"

static NSString *const URLSearchFScene = @"/search/getlist";

@interface AllSceneSearchViewController ()

@pro_strong NSMutableArray          *   allFiuSceneMarr;        //   情景列表
@pro_strong NSMutableArray          *   allFiuSceneIdMarr;      //   情景Id列表
@pro_strong NSMutableArray          *   allFiuSceneTitleMarr;   //   情景Id列表

@end

@implementation AllSceneSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentpageNum = 0;
    [self setSearchFSceneVcUI];
    
}

#pragma mark - 网络请求
- (void)networkAllFiuSceneList:(NSString *)keyword {
    [SVProgressHUD show];
    self.allSceneListRequest = [FBAPI getWithUrlString:URLSearchFScene requestDictionary:@{@"q":keyword, @"t":@"8", @"page":@(self.currentpageNum + 1), @"size":@"8"} delegate:self];
    [self.allSceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            FiuSceneInfoData * allFiuScene = [[FiuSceneInfoData alloc] initWithDictionary:sceneDic];
            [self.allFiuSceneMarr addObject:allFiuScene];
            [self.allFiuSceneIdMarr addObject:[NSString stringWithFormat:@"%zi", allFiuScene.idField]];
            [self.allFiuSceneTitleMarr addObject:allFiuScene.title];
        }
        
        [self.allSceneView reloadData];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        
        if (self.totalPageNum > 1) {
            self.allSceneView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                if (self.currentpageNum < self.totalPageNum) {
                    [self networkAllFiuSceneList:self.searchView.searchInputBox.text];
                } else {
                    [self.allSceneView.mj_footer endRefreshing];
                }
            }];
        }
        
        //  判断是否为最后一条数据
        BOOL isLastPage = (self.currentpageNum == self.totalPageNum);
        if (!isLastPage) {
            if (self.allSceneView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.allSceneView.mj_footer resetNoMoreData];
            }
        }
        if (self.currentpageNum == self.totalPageNum == 1) {
            self.allSceneView.mj_footer.state = MJRefreshStateNoMoreData;
            self.allSceneView.mj_footer.hidden = true;
        }
        if ([self.allSceneView.mj_header isRefreshing]) {
            [self.allSceneView.mj_header endRefreshing];
        }
        if ([self.allSceneView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [self.allSceneView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [self.allSceneView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark - 设置视图
- (void)setSearchFSceneVcUI {
    [self.view addSubview:self.searchView];
    [self.searchView.searchInputBox becomeFirstResponder];
    
    [self.view addSubview:self.allSceneView];
}

#pragma mark - 情景列表
- (UICollectionView *)allSceneView {
    if (!_allSceneView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2 * 1.77);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0;
        
        _allSceneView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - 110) collectionViewLayout:flowLayout];
        _allSceneView.delegate = self;
        _allSceneView.dataSource = self;
        _allSceneView.backgroundColor = [UIColor whiteColor];
        _allSceneView.showsVerticalScrollIndicator = NO;
        _allSceneView.showsHorizontalScrollIndicator = NO;
        [_allSceneView registerClass:[SelectAllFSceneCollectionViewCell class] forCellWithReuseIdentifier:@"searchSceneCollectionViewCellID"];
        
    }
    return _allSceneView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allFiuSceneMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"searchSceneCollectionViewCellID";
    SelectAllFSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setAllFiuSceneListData:self.allFiuSceneMarr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
    fiuSceneVC.fiuSceneId = self.allFiuSceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:fiuSceneVC animated:YES];
}

#pragma mark - 搜素框
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"searchFScene", nil);
        _searchView.delegate = self;
    }
    return _searchView;
}

#pragma mark - 开始搜索
- (void)beginSearch:(NSString *)searchKeyword {
    if ([searchKeyword isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"noKeyword", nil)];
        
    } else {
        self.currentpageNum = 0;
        [self.allFiuSceneMarr removeAllObjects];
        [self networkAllFiuSceneList:searchKeyword];
    }
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"AllSceneVcTitle", nil);
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark -
- (NSMutableArray *)allFiuSceneMarr {
    if (!_allFiuSceneMarr) {
        _allFiuSceneMarr = [NSMutableArray array];
    }
    return _allFiuSceneMarr;
}

- (NSMutableArray *)allFiuSceneIdMarr {
    if (!_allFiuSceneIdMarr) {
        _allFiuSceneIdMarr = [NSMutableArray array];
    }
    return _allFiuSceneIdMarr;
}

- (NSMutableArray *)allFiuSceneTitleMarr {
    if (!_allFiuSceneTitleMarr) {
        _allFiuSceneTitleMarr = [NSMutableArray array];
    }
    return _allFiuSceneTitleMarr;
}

@end
