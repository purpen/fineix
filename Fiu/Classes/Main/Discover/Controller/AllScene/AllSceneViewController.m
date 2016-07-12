//
//  AllSceneViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllSceneViewController.h"
#import "PictureToolViewController.h"
#import "AllSceneCollectionViewCell.h"
#import "FiuSceneViewController.h"
#import "FiuSceneInfoData.h"
#import "FBRefresh.h"
#import "AllSceneSearchViewController.h"

static NSString *const URLAllFiuSceneList = @"/scene_scene/";

@interface AllSceneViewController ()

@pro_strong NSMutableArray          *   allFiuSceneMarr;        //   情景列表
@pro_strong NSMutableArray          *   allFiuSceneIdMarr;      //   情景Id列表

@end

@implementation AllSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setFirstAppStart];
    [self setNavigationViewUI];
    
    self.currentpageNum = 0;
    [self networkAllFiuSceneList];
    
    //  frome #import "ReleaseViewController.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refreshAllFSceneList" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAllSceneViewUI];
}

#pragma mark - 刷新列表
- (void)refreshList {
    [self.allSceneView.mj_header beginRefreshing];
}

#pragma mark - 网络请求
- (void)networkAllFiuSceneList {
    self.allSceneListRequest = [FBAPI getWithUrlString:URLAllFiuSceneList requestDictionary:@{@"stick":@"0", @"size":@"10", @"page":@(self.currentpageNum + 1)} delegate:self];
    [self.allSceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝－－－－－－－－－－－ %@", result);
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            FiuSceneInfoData * allFiuScene = [[FiuSceneInfoData alloc] initWithDictionary:sceneDic];
            [self.allFiuSceneMarr addObject:allFiuScene];
            [self.allFiuSceneIdMarr addObject:[NSString stringWithFormat:@"%zi", allFiuScene.idField]];
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
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark - 
- (void)setAllSceneViewUI {
    [self.view addSubview:self.beginSearchBtn];
    [self.view addSubview:self.allSceneView];
}

#pragma mark - 搜索情境按钮
- (UIButton *)beginSearchBtn {
    if (!_beginSearchBtn) {
        _beginSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 74, SCREEN_WIDTH - 30, 32)];
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
    AllSceneSearchViewController * searchFSceneVC = [[AllSceneSearchViewController alloc] init];
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
        
        _allSceneView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 117, SCREEN_WIDTH, SCREEN_HEIGHT - 117) collectionViewLayout:flowLayout];
        _allSceneView.delegate = self;
        _allSceneView.dataSource = self;
        _allSceneView.backgroundColor = [UIColor whiteColor];
        _allSceneView.showsVerticalScrollIndicator = NO;
        _allSceneView.showsHorizontalScrollIndicator = NO;
        [_allSceneView registerClass:[AllSceneCollectionViewCell class] forCellWithReuseIdentifier:@"allSceneCollectionViewCellID"];
        
        FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
            [self loadNewData];
        }];
        _allSceneView.mj_header = header;

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

- (void)loadNewData {
    [self.allFiuSceneMarr removeAllObjects];
    [self.allFiuSceneIdMarr removeAllObjects];
    
    self.currentpageNum = 0;
    [self networkAllFiuSceneList];
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allFiuSceneMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";
    AllSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setAllFiuSceneListData:self.allFiuSceneMarr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
    fiuSceneVC.fiuSceneId = self.allFiuSceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:fiuSceneVC animated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"AllSceneVcTitle", nil);
    self.delegate = self;
    [self addBarItemRightBarButton:@"" image:@"icon_newScene" isTransparent:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    if ([self isUserLogin]) {
        [SVProgressHUD showInfoWithStatus:@"暂无权限发布地盘"];
//        PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
//        pictureToolVC.createType = @"fScene";
//        [self presentViewController:pictureToolVC animated:YES completion:nil];
        
    } else {
        [self openUserLoginVC];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"allSceneLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"allSceneLaunch"];
        [self setGuideImgForVC:@"Guide_SceneList"];
    }
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

@end
