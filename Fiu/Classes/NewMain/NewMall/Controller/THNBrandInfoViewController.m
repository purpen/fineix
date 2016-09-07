//
//  THNBrandInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/9/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNBrandInfoViewController.h"
#import "THNBrandInfoCollectionReusableView.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "MallListGoodsCollectionViewCell.h"
#import "BrandInfoData.h"
#import "GoodsRow.h"
#import "FBGoodsInfoViewController.h"
#import "THNSceneDetalViewController.h"

static NSString *const URLBrandInfo = @"/scene_brands/view";
static NSString *const URLGoodslist = @"/product/getlist";
static NSString *const URLSceneList = @"/sight_and_product/getlist";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";

static NSString *const MallListCellId = @"mallListCellId";
static NSString *const brandCollectionCellId = @"brandCollectionCellId";
static NSString *const brandInfoHeader = @"BrandInfoHeader";

@interface THNBrandInfoViewController () {
    /**
     *  showType展示的类型
     *  1:商品列表／2:情境列表
     */
    NSInteger _showType;
    BrandInfoData *_brandInfo;
    NSString *_brandDes;
}


@end

@implementation THNBrandInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showType = 1;
    [self.view addSubview:self.brandCollection];
    [self.view sendSubviewToBack:self.brandCollection];
    
    self.currentpageNum = 0;
    [self networkBrandInfoData];
    [self networkBrandGoodsList];
}

#pragma mark - 网络请求
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

#pragma mark 品牌详情
- (void)networkBrandInfoData {
    self.brandRequest = [FBAPI getWithUrlString:URLBrandInfo requestDictionary:@{@"id":self.brandId} delegate:self];
    [self.brandRequest startRequestSuccess:^(FBRequest *request, id result) {
        _brandInfo = [[BrandInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        self.navViewTitle.text = [[result valueForKey:@"data"] valueForKey:@"title"];
        _brandDes = [[result valueForKey:@"data"] valueForKey:@"des"];
        [self.brandCollection reloadData];
        
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
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.brandCollection currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [self.brandCollection reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 品牌商品
- (void)networkBrandGoodsList {
    [SVProgressHUD show];
    self.brandGoodsRequest = [FBAPI getWithUrlString:URLGoodslist requestDictionary:@{@"stage":@"9,16", @"size":@"8", @"page":@(self.currentpageNum + 1), @"brand_id":self.brandId} delegate:self];
    [self.brandGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.brandCollection currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [self.brandCollection reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    
}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UICollectionView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
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
- (void)addMJRefresh:(UICollectionView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            if (_showType == 1) {
                [self networkBrandGoodsList];
            } else if (_showType == 2) {
                [self thn_networkSceneListData];
            }
            
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 商品信息列表
- (UICollectionView *)brandCollection {
    if (!_brandCollection) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _brandCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT + 20)
                                        collectionViewLayout:flowLayou];
        _brandCollection.showsVerticalScrollIndicator = NO;
        _brandCollection.delegate = self;
        _brandCollection.dataSource = self;
        _brandCollection.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_brandCollection registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:MallListCellId];
        [_brandCollection registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:brandCollectionCellId];
        [_brandCollection registerClass:[THNBrandInfoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:brandInfoHeader];
        [self addMJRefresh:_brandCollection];
    }
    return _brandCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showType == 1) {
        return self.goodsListMarr.count;
    } else if (_showType == 2) {
        return self.sceneListMarr.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_showType == 1) {
        MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MallListCellId
                                                                                           forIndexPath:indexPath];
        if (self.goodsListMarr.count) {
            [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
        }
        return cell;
        
    } else if (_showType == 2) {
        __weak __typeof(self)weakSelf = self;
        
        THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCollectionCellId
                                                                                              forIndexPath:indexPath];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row] isLogin:[self isUserLogin]];
            cell.beginLikeTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkLikeSceneData:idx];
            };
            
            cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
                [weakSelf thn_networkCancelLikeData:idx];
            };
        }
        cell.vc = self;
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    THNBrandInfoCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                        withReuseIdentifier:brandInfoHeader
                                                                                               forIndexPath:indexPath];
    [headerView setBrandInfoData:_brandInfo];
    headerView.menuView.delegate = self;
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, [self getContentCellHeight:_brandDes]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_showType == 1) {
        FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
        goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
        [self.navigationController pushViewController:goodsVC animated:YES];
    
    } else if (_showType == 2) {
        THNSceneDetalViewController *sceneDataVC = [[THNSceneDetalViewController alloc] init];
        sceneDataVC.sceneDetalId = self.sceneIdMarr[indexPath.row];
        [self.navigationController pushViewController:sceneDataVC animated:YES];
    }
}

- (CGFloat)getContentCellHeight:(NSString *)content {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;

    CGFloat brandInfoHeight = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                              attributes:@{NSParagraphStyleAttributeName :paragraphStyle,
                                                           NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                 context:nil].size.height;
    brandInfoHeight += 310;
    return brandInfoHeight;
}

- (void)menuItemSelected:(NSInteger)index {
    _showType = index +1;
    if (index == 1) {
        if (self.sceneListMarr.count == 0) {
            self.currentpageNum = 0;
            [self thn_networkSceneListData];
            
        } else {
            [self.brandCollection reloadData];
        }
        
    } else if (index == 0) {
        if (self.goodsListMarr.count == 0) {
            self.currentpageNum = 0;
            [self networkBrandGoodsList];
        
        } else {
            [self.brandCollection reloadData];
        }
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
    self.navViewTitle.textColor = [UIColor whiteColor];
    self.delegate = self;
}

#pragma mark - NSMutableArray
- (NSMutableArray *)goodsListMarr {
    if (!_goodsListMarr) {
        _goodsListMarr = [NSMutableArray array];
    }
    return _goodsListMarr;
}

- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
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
