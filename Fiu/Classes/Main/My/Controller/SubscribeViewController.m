//
//  SubscribeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubscribeViewController.h"
#import "UserInfoEntity.h"
#import "SVProgressHUD.h"
#import "FiuSceneRow.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "THNSubHeadView.h"
#import "THNSenceModel.h"
#import "THNSenecCollectionViewCell.h"
#import "THNSceneDetalViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface SubscribeViewController ()<FBNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBRequestDelegate>
@pro_strong NSMutableArray          *   allFiuSceneMarr;        //   情景列表
@pro_strong NSMutableArray          *   allFiuSceneIdMarr;      //   情景Id列表
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
/**  */
@property (nonatomic, strong) THNSubHeadView *headView;
@end

static NSString *const URLAllFiuSceneList = @"/scene_scene/";

@implementation SubscribeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self setNavigationViewUI];
    
    //[self networkAllFiuSceneList];
    [self requestDataForOderList];
    
    // 下拉刷新
    self.allSceneView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [self.allFiuSceneMarr removeAllObjects];
        [self.allFiuSceneIdMarr removeAllObjects];
        [self requestDataForOderListOperation];
    }];
    
    //上拉加载更多
    self.allSceneView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self requestDataForOderListOperation];
        } else {
            [self.allSceneView.mj_footer endRefreshing];
        }
    }];
}

-(THNSubHeadView *)headView{
    if (!_headView) {
        _headView = [[THNSubHeadView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _headView.navi = self.navigationController;
    }
    return _headView;
}

//上拉下拉分页请求订单列表
- (void)requestDataForOderListOperation
{
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.interest_scene_cate.length == 0) {
        entity.interest_scene_cate = @"null";
    }
    self.allSceneListRequest = [FBAPI getWithUrlString:@"/scene_sight/getlist" requestDictionary:@{@"size":@"10", @"page":@(_currentPageNumber + 1),@"category_ids" : entity.interest_scene_cate} delegate:self];
    
    [self.allSceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            THNSenceModel * allFiuScene = [THNSenceModel mj_objectWithKeyValues:sceneDic];
            [self.allFiuSceneMarr addObject:allFiuScene];
            [self.allFiuSceneIdMarr addObject:allFiuScene._id];
        }
        
        [self.view addSubview:self.headView];
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        FBRequest *request1 = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
        [request1 startRequestSuccess:^(FBRequest *request, id result) {
            NSArray *ary = [result objectForKey:@"data"][@"interest_scene_cate"];
            self.headView.num = ary.count;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
        
        [self.allSceneView reloadData];
        
        _currentPageNumber = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        _totalPageNumber = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.allSceneView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.allSceneView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
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
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [self.allFiuSceneMarr removeAllObjects];
    [self.allFiuSceneIdMarr removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setAllSceneViewUI];
    
}


#pragma mark -
- (void)setAllSceneViewUI {
    [self.view addSubview:self.allSceneView];
}

#pragma mark - 情景列表
- (UICollectionView *)allSceneView {
    if (!_allSceneView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15)/2, (SCREEN_WIDTH - 15)/2 * 1.77);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0;
        
        _allSceneView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) collectionViewLayout:flowLayout];
        
        
        _allSceneView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _allSceneView.delegate = self;
        _allSceneView.dataSource = self;
        _allSceneView.showsVerticalScrollIndicator = NO;
        _allSceneView.showsHorizontalScrollIndicator = NO;
        [_allSceneView registerNib:[UINib nibWithNibName:@"THNSenecCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"allSceneCollectionViewCellID"];
    }
    return _allSceneView;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.3 * SCREEN_HEIGHT);
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allFiuSceneMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";
    THNSenecCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    cell.model = self.allFiuSceneMarr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
    vc.sceneDetalId = self.allFiuSceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = @"订阅";
    self.delegate = self;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
