//
//  SearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsRow.h"
#import "HomeSceneListRow.h"
#import "FiuSceneInfoData.h"

#import "AllSceneCollectionViewCell.h"
#import "SceneListTableViewCell.h"
#import "GoodsTableViewCell.h"

#import "FiuSceneViewController.h"
#import "GoodsInfoViewController.h"
#import "SceneInfoViewController.h"

static NSString *const URLSearchList = @"/search/getlist";

@interface SearchViewController () {
    NSString * _searchEvt;
}

@pro_strong NSMutableArray      *   sceneList;              //  场景
@pro_strong NSMutableArray      *   sceneIdMarr;
@pro_strong NSMutableArray      *   fiuSceneList;           //  情景
@pro_strong NSMutableArray      *   allFiuSceneIdMarr;      //   情景Id列表
@pro_strong NSMutableArray      *   goodsList;              //  商品
@pro_strong NSMutableArray      *   goodsIdList;            //  商品id

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
    if (self.beginSearch == YES) {
        [self.searchView.searchInputBox becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchVcUI];
    if (self.keyword.length > 0) {
        self.searchView.searchInputBox.text = self.keyword;
    }
    [self searchRequest:self.searchType withKeyword:self.keyword];
}

#pragma mark - 网络请求
- (void)networkSearchData:(NSString *)keyword withType:(NSString *)type withSearchType:(NSString *)evt {
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":evt, @"size":@"8", @"page":@(self.currentpageNum + 1), @"t":type , @"q":keyword} delegate:self];
    _searchEvt = evt;
    
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([type isEqualToString:@"10"]) {
            NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * goodsDic in goodsArr) {
                GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
                [self.goodsList addObject:goodsModel];
                [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
            }

            [self.goodsTable reloadData];
            if (self.goodsList.count == 0) {
                self.noneLab.hidden = NO;
            } else {
                self.noneLab.hidden = YES;
            }
            
            self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
            self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
            [self requestIsLastData:self.goodsTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        }
        else if ([type isEqualToString:@"9"]) {
            NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * sceneDic in sceneArr) {
                HomeSceneListRow * sceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
                [self.sceneList addObject:sceneModel];
                [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", sceneModel.idField]];
            }
            [self.sceneTable reloadData];
            if (self.sceneList.count == 0) {
                self.noneLab.hidden = NO;
            } else {
                self.noneLab.hidden = YES;
            }
            
            self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
            self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
            [self requestIsLastData:self.sceneTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        } else if ([type isEqualToString:@"8"]) {
            NSArray * fSceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
            for (NSDictionary * fSceneDic in fSceneArr) {
                FiuSceneInfoData * fSceneModel = [[FiuSceneInfoData alloc] initWithDictionary:fSceneDic];
                [self.fiuSceneList addObject:fSceneModel];
                [self.allFiuSceneIdMarr addObject:[NSString stringWithFormat:@"%zi", fSceneModel.idField]];
            }
        
            [self.fSceneCollection reloadData];
            if (self.fiuSceneList.count == 0) {
                self.noneLab.hidden = NO;
            } else {
                self.noneLab.hidden = YES;
            }
            
            self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
            self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
            //  判断是否为最后一条数据
            BOOL isLastPage = (self.currentpageNum == self.totalPageNum);
            if (!isLastPage) {
                if (self.fSceneCollection.mj_footer.state == MJRefreshStateNoMoreData) {
                    [self.fSceneCollection.mj_footer resetNoMoreData];
                }
            }
            if (self.currentpageNum == self.totalPageNum == 1) {
                self.fSceneCollection.mj_footer.state = MJRefreshStateNoMoreData;
                self.fSceneCollection.mj_footer.hidden = true;
            }
            if ([self.fSceneCollection.mj_header isRefreshing]) {
                [self.fSceneCollection.mj_header endRefreshing];
            }
            if ([self.fSceneCollection.mj_footer isRefreshing]) {
                if (isLastPage) {
                    [self.fSceneCollection.mj_footer endRefreshingWithNoMoreData];
                } else  {
                    [self.fSceneCollection.mj_footer endRefreshing];
                }
            }
            
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark - 设置视图UI 
- (void)setSearchVcUI {
    self.titleArr = @[NSLocalizedString(@"SceneBtn", nil), NSLocalizedString(@"FiuSceneBtn", nil), NSLocalizedString(@"GoodsBtn", nil)];
    
    [self.view addSubview:self.menuView];
    
    [self.view addSubview:self.resultsView];
    
    [self.view addSubview:self.noneLab];
}

#pragma mark - 搜索情景
- (void)searchRequest:(NSInteger)type withKeyword:(NSString *)keyword {
    [self changeMenuBtnState:type];
    
    if (keyword.length > 0) {
        if (type == 1) {
            [self networkSearchData:keyword withType:@"8" withSearchType:@"tag"];
        } else if (type == 2) {
            [self networkSearchData:keyword withType:@"10" withSearchType:@"tag"];
        }
        else if (type == 0) {
            [self networkSearchData:keyword withType:@"9" withSearchType:@"tag"];
        }
        
    } else if (keyword.length == 0) {
        self.noneLab.hidden = YES;
    }
}

#pragma mark - 搜索结果视图
- (UIScrollView *)resultsView {
    if (!_resultsView) {
        _resultsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _resultsView.pagingEnabled = YES;
        _resultsView.showsHorizontalScrollIndicator = NO;
        _resultsView.showsVerticalScrollIndicator = NO;
        _resultsView.backgroundColor = [UIColor whiteColor];
        _resultsView.scrollEnabled = NO;
        _resultsView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        
        [_resultsView addSubview:self.sceneTable];
        [_resultsView addSubview:self.fSceneCollection];
        [_resultsView addSubview:self.goodsTable];
    }
    return _resultsView;
}

#pragma mark - 场景
- (UITableView *)sceneTable {
    if (!_sceneTable) {
        _sceneTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        _sceneTable.delegate = self;
        _sceneTable.dataSource = self;
        _sceneTable.showsVerticalScrollIndicator = NO;
        _sceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sceneTable.backgroundColor = [UIColor whiteColor];
        _sceneTable.tableFooterView = [UIView new];
        _sceneTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.currentpageNum < self.totalPageNum) {
                [self networkSearchData:self.searchView.searchInputBox.text withType:@"9" withSearchType:_searchEvt];
            } else {
                [_sceneTable.mj_footer endRefreshing];
            }
        }];
    }
    return _sceneTable;
}

#pragma mark - 商品
- (UITableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.showsVerticalScrollIndicator = NO;
        _goodsTable.backgroundColor = [UIColor whiteColor];
        _goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTable.tableFooterView = [UIView new];
        _goodsTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.currentpageNum < self.totalPageNum) {
                [self networkSearchData:self.searchView.searchInputBox.text withType:@"10" withSearchType:_searchEvt];
                
            } else {
                [_goodsTable.mj_footer endRefreshing];
            }
        }];
    }
    return _goodsTable;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.sceneTable) {
        return self.sceneList.count;
    } else if (tableView == self.goodsTable) {
        return self.goodsList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.sceneTable) {
        static NSString * SceneTablecellId = @"sceneTablecellId";
        SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SceneTablecellId];
        if (!cell) {
            cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:SceneTablecellId];
        }
        [cell setHomeSceneListData:self.sceneList[indexPath.row]];
        return cell;
        
    } else if (tableView == self.goodsTable) {
        static NSString * GoodsTablecellId = @"goodsTablecellId";
        GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GoodsTablecellId];
        cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsTablecellId];
        cell.nav = self.navigationController;
        [cell setGoodsData:self.goodsList[indexPath.row]];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.sceneTable) {
        return SCREEN_HEIGHT + 5;
    } else if (tableView == self.goodsTable) {
        return 210;
    }
    return 0;
}

#pragma mark - 打开详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.goodsTable) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    
    } else if (tableView == self.sceneTable) {
        SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
        sceneInfoVC.sceneId = self.sceneIdMarr[indexPath.row];
        [self.navigationController pushViewController:sceneInfoVC animated:YES];
    }
}

#pragma mark - 情景
- (UICollectionView *)fSceneCollection {
    if (!_fSceneCollection) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2 * 1.77);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0;
        
        _fSceneCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) collectionViewLayout:flowLayout];
        _fSceneCollection.delegate = self;
        _fSceneCollection.dataSource = self;
        _fSceneCollection.backgroundColor = [UIColor whiteColor];
        _fSceneCollection.showsVerticalScrollIndicator = NO;
        _fSceneCollection.showsHorizontalScrollIndicator = NO;
        [_fSceneCollection registerClass:[AllSceneCollectionViewCell class] forCellWithReuseIdentifier:@"fSceneCollectionViewCellID"];
        
        _fSceneCollection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.currentpageNum < self.totalPageNum) {
                [self networkSearchData:self.searchView.searchInputBox.text withType:@"8" withSearchType:_searchEvt];
            } else {
                [_fSceneCollection.mj_footer endRefreshing];
            }
        }];

    }
    return _fSceneCollection;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fiuSceneList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"fSceneCollectionViewCellID";
    AllSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setAllFiuSceneListData:self.fiuSceneList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
    fiuSceneVC.fiuSceneId = self.allFiuSceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:fiuSceneVC animated:YES];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = NSLocalizedString(@"search", nil);
        _searchView.delegate = self;
        _searchView.line.hidden = YES;
    }
    return _searchView;
}

- (void)cancelSearch {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 没有搜索结果
- (UILabel *)noneLab {
    if (!_noneLab) {
        _noneLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _noneLab.textAlignment = NSTextAlignmentCenter;
        _noneLab.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _noneLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _noneLab.font = [UIFont systemFontOfSize:12];
        }
        _noneLab.text = NSLocalizedString(@"noneSearch", nil);
    }
    return _noneLab;
}

#pragma mark - 搜索
- (void)beginSearch:(NSString *)searchKeyword {
    self.currentpageNum = 0;

    if (self.searchType == 0) {
        [self.sceneList removeAllObjects];
        [self.sceneIdMarr removeAllObjects];
        [self networkSearchData:searchKeyword withType:@"9" withSearchType:@"content"];
    } else if (self.searchType == 1) {
        [self.fiuSceneList removeAllObjects];
        [self.allFiuSceneIdMarr removeAllObjects];
        [self networkSearchData:searchKeyword withType:@"8" withSearchType:@"content"];
    } else if (self.searchType == 2) {
        [self.goodsList removeAllObjects];
        [self.goodsIdList removeAllObjects];
        [self networkSearchData:searchKeyword withType:@"10" withSearchType:@"content"];
    }
}

#pragma mark - 导航菜单视图
- (SearchMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SearchMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        [_menuView setSearchMenuView:self.titleArr];
    }
    return _menuView;
}

#pragma mark - 改变菜单栏的状态
- (void)SearchMenuSeleted:(NSInteger)index {
    self.searchType = index;
    [self searchRequest:index withKeyword:self.searchView.searchInputBox.text];
    [self changeMenuBtnState:index];
}

//  改变搜索视图位置
- (void)changeMenuBtnState:(NSInteger)index {
    CGPoint rollPoint = self.resultsView.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    self.resultsView.contentOffset = rollPoint;
    
    self.menuView.selectedBtn.selected = NO;
    NSUInteger tag = index + menuBtnTag;
    UIButton * newbtn = (UIButton *)[self.view viewWithTag:tag];
    newbtn.selected = YES;
    self.menuView.selectedBtn = newbtn;
    self.menuView.selectBtnTag = tag;
    [self.menuView changeMenuBottomLinePosition:self.menuView.selectedBtn withIndex:index];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navView addSubview:self.searchView];
    self.navLine.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark -
- (NSMutableArray *)sceneList {
    if (!_sceneList) {
        _sceneList = [NSMutableArray array];
    }
    return _sceneList;
}

- (NSMutableArray *)sceneIdMarr {
    if (!_sceneIdMarr) {
        _sceneIdMarr = [NSMutableArray array];
    }
    return _sceneIdMarr;
}

- (NSMutableArray *)fiuSceneList {
    if (!_fiuSceneList) {
        _fiuSceneList = [NSMutableArray array];
    }
    return _fiuSceneList;
}

- (NSMutableArray *)allFiuSceneIdMarr {
    if (!_allFiuSceneIdMarr) {
        _allFiuSceneIdMarr = [NSMutableArray array];
    }
    return _allFiuSceneIdMarr;
}

- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

- (NSMutableArray *)goodsIdList {
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}

//  清空数组
- (void)clearMarrData {
    [self.sceneList removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self.fiuSceneList removeAllObjects];
    [self.allFiuSceneIdMarr removeAllObjects];
    [self.goodsList removeAllObjects];
    [self.goodsIdList removeAllObjects];
}

@end
