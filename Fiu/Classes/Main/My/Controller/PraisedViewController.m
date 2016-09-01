//
//  PraisedViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PraisedViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "HomeSceneListRow.h"
#import "UserInfoEntity.h"
#import "THNHomeSenceCollectionViewCell.h"
#import "THNSenecCollectionViewCell.h"
#import "THNSceneDetalViewController.h"
#import "THNSenceModel.h"

@interface PraisedViewController ()<FBNavigationBarItemsDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@pro_strong NSMutableArray      *   sceneListMarr;
@pro_strong NSMutableArray      *   sceneIdMarr;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;

/** 主体部分 */
@property (nonatomic, strong) UICollectionView *myCollectionView;
@end

static NSString *const URLSceneList = @"/scene_sight/";
static NSString *sceneCollectionCellId = @"THNHomeSenceCollectionViewCell";

@implementation PraisedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self setNavigationViewUI];
    [self requestDataForOderList];
    
    // 下拉刷新
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [self.sceneListMarr removeAllObjects];
        [self.sceneIdMarr removeAllObjects];
        [self requestDataForOderListOperation];
    }];
    
    //上拉加载更多
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
//            [self.sceneListMarr removeAllObjects];
//            [self.sceneIdMarr removeAllObjects];
            [self requestDataForOderListOperation];
        } else {
            [self.myCollectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
}


- (void)requestDataForOderListOperation
{
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    NSDictionary *  requestParams = @{@"size":@"10", @"page":@(_currentPageNumber + 1),@"user_id":entity.userId,@"type":@"12",@"event":@"love"};
    self.sceneListRequest = [FBAPI getWithUrlString:@"/favorite/get_new_list" requestDictionary:requestParams delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"赞过的情境  %@",result);
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        
        for (NSDictionary * sceneDic in sceneArr) {
            NSDictionary * sightDict = sceneDic[@"sight"];
            THNSenceModel * homeSceneModel = [THNSenceModel mj_objectWithKeyValues:sightDict];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%@", homeSceneModel._id]];
            NSLog(@"啊啦拉  %@",homeSceneModel.title);
        }
        [self.myCollectionView reloadData];
        _currentPageNumber = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        _totalPageNumber = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.myCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.myCollectionView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            self.myCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
            self.myCollectionView.mj_footer.hidden = true;
        }
        
        if ([self.myCollectionView.mj_header isRefreshing]) {
            [self.myCollectionView.mj_header endRefreshing];
        }
        if ([self.myCollectionView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [self.myCollectionView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myCollectionView];
    
}

#pragma mark - 加载首页表格
-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"THNSenecCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"allSceneCollectionViewCellID"];
    }
    return _myCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sceneListMarr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 1, 15);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";
    THNSenecCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    cell.model = self.sceneListMarr[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.25 * SCREEN_HEIGHT + 35);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
    vc.sceneDetalId = self.sceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.navViewTitle.text = @"赞过的情境";
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
