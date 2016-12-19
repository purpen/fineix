//
//  THNMallViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallViewController.h"
#import "THNCategoryCollectionReusableView.h"
#import "THNMallNewGoodsCollectionViewCell.h"
#import "THNMallListCollectionViewCell.h"
#import "GoodsCarViewController.h"
#import "QRCodeScanViewController.h"
#import "THNMallGoodsModelItem.h"
#import "THNMallSubjectModelRow.h"

#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"

static NSString *const URLNewGoodsList = @"/product/index_new";
static NSString *const URLCategory = @"/category/getlist";
static NSString *const URLMallSubject = @"/scene_subject/getlist";

static NSString *const DiscoverCellId = @"discoverCellId";
static NSString *const MallListCellId = @"mallListCellId";
static NSString *const NewGoodsListCellId = @"newGoodsListCellId";
static NSString *const MallListHeaderCellViewId = @"mallListHeaderCellViewId";

@interface THNMallViewController () {
    NSInteger _type;
    BOOL _rollDown;                  //  是否下拉
    CGFloat _lastContentOffset;      //  滚动的偏移量
    BOOL _goTop;
}

@end

@implementation THNMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setFirstAppStart];
    [self getGoodsCarNumData];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self networkCategoryData];
    [self thn_networkNewGoodsListData];
    [self thn_networkSubjectListData];
    [self thn_setMallViewUI];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"1", @"page":@"1", @"size":@"10", @"use_cache":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.categoryMarr = [NSMutableArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"rows"]];
        [self.topCategoryView setCategoryData:self.categoryMarr withType:2];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 最新商品列表
- (void)thn_networkNewGoodsListData {
    self.mallListRequest = [FBAPI getWithUrlString:URLNewGoodsList requestDictionary:@{@"type":@"1", @"use_cache":@"1"} delegate:self];
    [self.mallListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.goodsDataMarr addObject:goodsModel];
        }
    
        [self.mallList reloadData];
        [self requestIsLastData:self.mallList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品专题列表
- (void)thn_networkSubjectListData {
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"100",
                                 @"sort":@"2",
                                 @"type":@"5",
                                 @"use_cache":@"1"};
    self.subjectRequest = [FBAPI getWithUrlString:URLMallSubject requestDictionary:requestDic delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallSubjectModelRow *goodsModel = [[THNMallSubjectModelRow alloc] initWithDictionary:goodsDic];
            [self.subjectMarr addObject:goodsModel];
            [self.subjectTypeMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.type]];
            [self.subjectIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.mallList reloadData];
        [self requestIsLastData:self.mallList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestIsLastData:(UICollectionView *)collectionView {
    if ([collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header endRefreshing];
    }
}

#pragma mark - 设置视图UI
- (void)thn_setMallViewUI {
    _goTop = NO;
    [self.view addSubview:self.mallList];
    [self.view addSubview:self.topCategoryView];
    [self.view addSubview:self.goTopBtn];
}

#pragma mark - 滚动后的顶部分类视图
- (CategoryMenuView *)topCategoryView {
    if (!_topCategoryView) {
        _topCategoryView = [[CategoryMenuView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 60)];
        _topCategoryView.nav = self.navigationController;
    }
    return _topCategoryView;
}

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UICollectionView *)collectionView {
    FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    collectionView.mj_header = header;
}

- (void)loadNewData {
    self.currentpageNum = 0;
    [self.goodsDataMarr removeAllObjects];
    [self.subjectMarr removeAllObjects];
    [self.subjectIdMarr removeAllObjects];
    [self.subjectTypeMarr removeAllObjects];
    [self.categoryMarr removeAllObjects];
    [self networkCategoryData];
    [self thn_networkNewGoodsListData];
    [self thn_networkSubjectListData];
}

#pragma mark - init
- (UICollectionView *)mallList {
    if (!_mallList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.4 + 64);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _mallList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113)
                                        collectionViewLayout:flowLayou];
        _mallList.showsVerticalScrollIndicator = NO;
        _mallList.delegate = self;
        _mallList.dataSource = self;
        _mallList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_mallList registerClass:[THNMallListCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [_mallList registerClass:[THNMallNewGoodsCollectionViewCell class] forCellWithReuseIdentifier:NewGoodsListCellId];
        [_mallList registerClass:[THNCategoryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:MallListHeaderCellViewId];
        [self addMJRefresh:_mallList];
    }
    return _mallList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subjectMarr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNMallNewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewGoodsListCellId
                                                                                forIndexPath:indexPath];
        if (self.goodsDataMarr.count) {
            [cell setNewGoodsData:self.goodsDataMarr];
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else {
        THNMallListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                forIndexPath:indexPath];
        if (self.subjectMarr.count) {
            [cell setMallSubjectData:self.subjectMarr[indexPath.row - 1]];
        }
        cell.nav = self.navigationController;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH, 195);
    } else
        return CGSizeMake(SCREEN_WIDTH, 366);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    THNCategoryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:MallListHeaderCellViewId
                                                                                              forIndexPath:indexPath];
    if (self.categoryMarr.count) {
        [headerView setCategoryData:self.categoryMarr type:1];
    }
    headerView.nav = self.navigationController;
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
    
        _type = [self.subjectTypeMarr[indexPath.row - 1] integerValue];

        if (_type == 1) {
            THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
            articleVC.articleDetalid = self.subjectIdMarr[indexPath.row - 1];
            [self.navigationController pushViewController:articleVC animated:YES];
            
        } else if (_type == 2) {
            THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
            activity.activeDetalId = self.subjectIdMarr[indexPath.row - 1];
            [self.navigationController pushViewController:activity animated:YES];
            
        } else if (_type == 3) {
            THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
            cuXiao.cuXiaoDetalId = self.subjectIdMarr[indexPath.row - 1];
            cuXiao.vcType = 1;
            [self.navigationController pushViewController:cuXiao animated:YES];
            
        } else if (_type == 4) {
            THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
            xinPin.xinPinDetalId = self.subjectIdMarr[indexPath.row - 1];
            [self.navigationController pushViewController:xinPin animated:YES];
            
        } else if (_type == 5) {
            THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
            cuXiao.cuXiaoDetalId = self.subjectIdMarr[indexPath.row - 1];
            cuXiao.vcType = 2;
            [self.navigationController pushViewController:cuXiao animated:YES];
            
        }
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.mallList) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.mallList) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            _rollDown = YES;
        } else {
            _rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mallList) {
        CGRect tabBarRect = self.tabBarController.tabBar.frame;
        CGRect tableRect = self.mallList.frame;
        CGRect topCategoryRect = self.topCategoryView.frame;
        CGRect goTopBtnRect = self.goTopBtn.frame;
        
        if (_rollDown == YES && self.subjectMarr.count > 2) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 20, SCREEN_WIDTH, 49);
            tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            topCategoryRect = CGRectMake(0, 0, SCREEN_WIDTH, 60);
            goTopBtnRect = CGRectMake(SCREEN_WIDTH - 55, SCREEN_HEIGHT - 100, 40, 40);
            [UIView animateWithDuration:.3 animations:^{
                self.tabBarController.tabBar.frame = tabBarRect;
                self.mallList.frame = tableRect;
                self.navView.alpha = 0;
                self.leftBtn.alpha = 0;
                self.rightBtn.alpha = 0;
                self.topCategoryView.frame = topCategoryRect;
                self.goTopBtn.frame = goTopBtnRect;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
            }];
            
        } else if (_rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            tableRect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
            topCategoryRect = CGRectMake(0, -60, SCREEN_WIDTH, 60);
            [UIView animateWithDuration:.3 animations:^{
                self.topCategoryView.frame = topCategoryRect;
                self.mallList.frame = tableRect;
                self.navView.alpha = 1;
                self.leftBtn.alpha = 1;
                self.rightBtn.alpha = 1;
                self.tabBarController.tabBar.frame = tabBarRect;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
            }];
        }
        
        //  隐藏“返回顶部”按钮
        if (scrollView.contentOffset.y < SCREEN_HEIGHT) {
            goTopBtnRect = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 100, 40, 40);
            [UIView animateWithDuration:.3 animations:^{
                self.goTopBtn.frame = goTopBtnRect;
            }];
        }
        
        if (_goTop) {
            //  滚动到顶恢复视图
            if (scrollView.contentOffset.y == 0) {
                tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
                tableRect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
                topCategoryRect = CGRectMake(0, -60, SCREEN_WIDTH, 60);
                
                [UIView animateWithDuration:.2
                                      delay:0
                     usingSpringWithDamping:10.0f
                      initialSpringVelocity:5.0f
                                    options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                                        self.topCategoryView.frame = topCategoryRect;
                                        self.mallList.frame = tableRect;
                                        self.navView.alpha = 1;
                                        self.leftBtn.alpha = 1;
                                        self.rightBtn.alpha = 1;
                                        self.tabBarController.tabBar.frame = tabBarRect;
                                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
                                    }
                                 completion:^(BOOL finished) {
                                     _goTop = NO;
                                 }
                 ];
            }
        }
        
    }
}

#pragma mark - 返回顶部按钮
- (UIButton *)goTopBtn {
    if (!_goTopBtn) {
        _goTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 100, 40, 40)];
        [_goTopBtn setImage:[UIImage imageNamed:@"top_icon"] forState:(UIControlStateNormal)];
        _goTopBtn.layer.cornerRadius = 40/2;
        _goTopBtn.layer.masksToBounds = YES;
        [_goTopBtn addTarget:self action:@selector(goTopBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _goTopBtn;
}

- (void)goTopBtnClick:(UIButton *)button {
    _goTop = YES;
    [self.mallList scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addSearchBtnText:NSLocalizedString(@"mallSearch", nil) type:2];
    [self thn_addBarItemLeftBarButton:@"" image:@"mall_saoma"];
    [self thn_addBarItemRightBarButton:@"" image:@"mall_car"];
    [self setNavGoodsCarNumLab];
}

- (void)thn_leftBarItemSelected {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    if ([self isUserLogin]) {
        GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
        [self.navigationController pushViewController:goodsCarVC animated:YES];
        
    } else {
        [self openUserLoginVC];
    }
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"MallGoodsLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"MallGoodsLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"haohuo_saoyisao",@"haohuo_gouwuche"]];
    }
}

#pragma mark - NSMutableArray
- (NSMutableArray *)goodsDataMarr {
    if (!_goodsDataMarr) {
        _goodsDataMarr = [NSMutableArray array];
    }
    return _goodsDataMarr;
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

@end
