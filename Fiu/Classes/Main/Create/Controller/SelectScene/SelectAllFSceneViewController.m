//
//  SelectAllFSceneViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SelectAllFSceneViewController.h"
#import "SelectAllFSceneCollectionViewCell.h"
#import "ReleaseViewController.h"
#import "SearchFSceneViewController.h"
#import "CatagoryFiuSceneModel.h"

static NSString *const URLAllFiuSceneList = @"/scene_scene/";

@interface SelectAllFSceneViewController ()

@pro_strong NSMutableArray          *   allFiuSceneMarr;        //   情景列表
@pro_strong NSMutableArray          *   allFiuSceneIdMarr;      //   情景Id列表
@pro_strong NSMutableArray          *   allFiuSceneTitleMarr;   //   情景Id列表

@end

@implementation SelectAllFSceneViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAllSceneViewUI];
    self.currentpageNum = 0;
    [self networkAllFiuSceneList];
    
}

#pragma mark - 网络请求
#pragma mark 地盘列表
- (void)networkAllFiuSceneList {
    [SVProgressHUD show];
    self.allSceneListRequest = [FBAPI getWithUrlString:URLAllFiuSceneList requestDictionary:@{@"sort":@"1", @"category_id":self.categoryId, @"size":@"10", @"page":@(self.currentpageNum + 1)} delegate:self];
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

#pragma mark - 设置界面UI
- (void)setAllSceneViewUI {
    [self.view addSubview:self.beginSearchBtn];
    [self.view addSubview:self.allSceneView];
}

#pragma mark - 搜索情境按钮
- (UIButton *)beginSearchBtn {
    if (!_beginSearchBtn) {
        _beginSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 57, SCREEN_WIDTH - 30, 32)];
        _beginSearchBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _beginSearchBtn.layer.borderWidth = 0.5f;
        _beginSearchBtn.layer.cornerRadius = 4;
        _beginSearchBtn.layer.masksToBounds = YES;
        [_beginSearchBtn setTitle:NSLocalizedString(@"searchFScene", nil) forState:(UIControlStateNormal)];
        [_beginSearchBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        _beginSearchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_beginSearchBtn setImage:[UIImage imageNamed:@"Search"] forState:(UIControlStateNormal)];
        [_beginSearchBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        [_beginSearchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _beginSearchBtn;
}

#pragma mark - 跳转搜索情境
- (void)searchBtnClick {
    SearchFSceneViewController * searchFSceneVC = [[SearchFSceneViewController alloc] init];
    [self.navigationController pushViewController:searchFSceneVC animated:YES];
}

#pragma mark - 情景列表
- (UICollectionView *)allSceneView {
    if (!_allSceneView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2 * 1.77);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0;
        
        _allSceneView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, SCREEN_HEIGHT - 95) collectionViewLayout:flowLayout];
        _allSceneView.delegate = self;
        _allSceneView.dataSource = self;
        _allSceneView.backgroundColor = [UIColor whiteColor];
        _allSceneView.showsVerticalScrollIndicator = NO;
        _allSceneView.showsHorizontalScrollIndicator = NO;
        [_allSceneView registerClass:[SelectAllFSceneCollectionViewCell class] forCellWithReuseIdentifier:@"allSceneCollectionViewCellID"];
        
        _allSceneView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.allFiuSceneMarr removeAllObjects];
            
            self.currentpageNum = 0;
            [self networkAllFiuSceneList];
        }];
        
        _allSceneView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.currentpageNum < self.totalPageNum) {
                [self networkAllFiuSceneList];
            } else {
                [_allSceneView.mj_footer endRefreshing];
            }
        }];
    }
    return _allSceneView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allFiuSceneMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";
    SelectAllFSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setAllFiuSceneListData:self.allFiuSceneMarr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.fiuSceneId = self.allFiuSceneIdMarr[indexPath.row];
    self.fiuSceneTitle = self.allFiuSceneTitleMarr[indexPath.row];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"chooseSceneVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton:@"icon_back"];
    [self addLine];
    [self.navView addSubview:self.sureBtn];
}

#pragma mark - 确定按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
        [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

#pragma mark - 返回“发布页”
- (void)sureBtnClick {
    if (self.fiuSceneId.length > 0) {
        //  to :ReleaseViewController.h
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFiuSceneId" object:self.fiuSceneId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFiuSceneTitle" object:self.fiuSceneTitle];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"pleaseChooseFiuScene", nil)];
    }
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
