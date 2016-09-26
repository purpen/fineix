//
//  GoodsBrandViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsBrandViewController.h"
#import "GoodsBrandTableViewCell.h"
#import "BrandInfoData.h"
#import "GoodsRow.h"
#import "FBGoodsInfoViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"

static NSString *const URLBrandInfo = @"/scene_brands/view";
static NSString *const URLGoodslist = @"/product/getlist";
static NSString *const URLSceneList = @"/sight_and_product/getlist";
static NSString *const SceneListCellId = @"SceneListCellId";

@interface GoodsBrandViewController ()

@pro_strong BrandInfoData               *   brandInfo;
@pro_strong NSMutableArray              *   goodsList;
@pro_strong NSMutableArray              *   goodsIdList;

@end

@implementation GoodsBrandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkBrandInfoData];
    [self networkBrandGoodsList];
    [self thn_networkSceneListData];
    [self.view addSubview:self.goodsBrandTable];
}

#pragma mark - 网络请求
#pragma mark 品牌详情
- (void)networkBrandInfoData {
    self.brandRequest = [FBAPI getWithUrlString:URLBrandInfo requestDictionary:@{@"id":self.brandId} delegate:self];
    [self.brandRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.brandInfo = [[BrandInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        self.title = [[result valueForKey:@"data"] valueForKey:@"title"];
        self.titleLab.text = self.title;
        [self.view addSubview:self.titleLab];
        [self.goodsBrandTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 情景列表
- (void)thn_networkSceneListData {
    NSDictionary *requestDic = @{@"page":@(self.currentpageNum + 1),
                                 @"size":@"30",
                                 @"sort":@"0",
                                 @"brand_id":self.brandId};
    self.sceneRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:[sceneDic valueForKey:@"sight"]];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        
        self.goodsBrandTable.tableFooterView = self.sceneList;
        [self.sceneList reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 品牌商品
- (void)networkBrandGoodsList  {
    [SVProgressHUD show];
    self.brandGoodsRequest = [FBAPI getWithUrlString:URLGoodslist requestDictionary:@{@"size":@"8", @"page":@(self.currentpageNum + 1), @"brand_id":self.brandId, @"stage":@"9"} delegate:self];
    [self.brandGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsList addObject:goodsModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
    
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        if (self.totalPageNum > 1) {
            [self addMJRefresh:self.goodsBrandTable];
            [self requestIsLastData:self.goodsBrandTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        }
        [self.goodsBrandTable reloadData];
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
    } else {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
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

#pragma mark 上拉加载
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkBrandGoodsList];
            
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 品牌视图
#pragma mark - 商品信息列表
- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _sceneList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                        collectionViewLayout:flowLayou];
        _sceneList.showsVerticalScrollIndicator = NO;
        _sceneList.delegate = self;
        _sceneList.dataSource = self;
        _sceneList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_sceneList registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:SceneListCellId];
    }
    return _sceneList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    __weak __typeof(self)weakSelf = self;
    
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                          forIndexPath:indexPath];
    if (self.sceneListMarr.count) {
        [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row] isLogin:[self isUserLogin]];
        
//        cell.beginLikeTheSceneBlock = ^(NSString *idx) {
//            [weakSelf thn_networkLikeSceneData:idx];
//        };
//        
//        cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
//            [weakSelf thn_networkCancelLikeData:idx];
//        };
    }
    cell.vc = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    THNSceneDetalViewController *sceneDataVC = [[THNSceneDetalViewController alloc] init];
//    sceneDataVC.sceneDetalId = self.sceneIdMarr[indexPath.row];
//    [self.navigationController pushViewController:sceneDataVC animated:YES];
}

- (UITableView *)goodsBrandTable {
    if (!_goodsBrandTable) {
        _goodsBrandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, SCREEN_HEIGHT + 40) style:(UITableViewStyleGrouped)];
        _goodsBrandTable.showsVerticalScrollIndicator = NO;
        _goodsBrandTable.showsHorizontalScrollIndicator = NO;
        _goodsBrandTable.delegate = self;
        _goodsBrandTable.dataSource = self;
        _goodsBrandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsBrandTable.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _goodsBrandTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else  {
        return self.goodsList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * goodsBrandCellId = @"GoodsBrandCellId";
        GoodsBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsBrandCellId];
        if (!cell) {
            cell = [[GoodsBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsBrandCellId];
        }
        [cell setBrandInfoData:self.brandInfo];
        return cell;
    
    } else {
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsBrandTableViewCell * cell = [[GoodsBrandTableViewCell alloc] init];
        [cell getContentCellHeight:self.brandInfo.des];
        return  cell.cellHeight;
    } else {
        return 210;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}
#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"icon_back_white" isTransparent:YES];
}

- (void)leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

#pragma mark - 控制器标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, 20, 200, 44)];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

#pragma mark - 
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

@end
