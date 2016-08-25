//
//  THNContentViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNContentViewController.h"
#import "UIView+FSExtension.h"
#import "FBRefresh.h"
#import "UserInfoEntity.h"
#import "GoodsRow.h"
#import "THNGoodsCollectionViewCell.h"
#import "GoodsInfoViewController.h"
#import "HomeSceneListRow.h"
#import "SceneInfoViewController.h"
#import "THNHomeSenceCollectionViewCell.h"

@interface THNContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_sceneListMarr;
    NSMutableArray *_sceneIdMarr;
}
/**  */
@property (nonatomic, strong) UICollectionView *contenView;
/**  */
@property (nonatomic, strong) NSDictionary *params;
/** 收藏的商品数组 */
@property (nonatomic, strong) NSMutableArray *goodsList;
/** 收藏的商品id数组 */
@property (nonatomic, strong) NSMutableArray *goodsIdList;
/**  */
@property (nonatomic, assign) CGFloat page;

@end

static NSString *sceneCellId = @"THNHomeSenceCollectionViewCell";
static NSString *goodsCellId = @"goods";
static NSString *const URLFiuGoods = @"/favorite/get_new_list";

@implementation THNContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    _sceneListMarr = [NSMutableArray array];
    _sceneIdMarr = [NSMutableArray array];
    [self.view addSubview:self.contenView];
    // 添加刷新控件
    [self setupRefresh];
    
}

-(UICollectionView *)contenView{
    if (!_contenView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _contenView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) collectionViewLayout:layout];
        _contenView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _contenView.showsVerticalScrollIndicator = NO;
        _contenView.delegate = self;
        _contenView.dataSource = self;
        [_contenView registerNib:[UINib nibWithNibName:sceneCellId bundle:nil] forCellWithReuseIdentifier:sceneCellId];
        [_contenView registerNib:[UINib nibWithNibName:NSStringFromClass([THNGoodsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:goodsCellId];
    }
    return _contenView;
}

- (void)setupRefresh
{
    self.contenView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.contenView.mj_header.automaticallyChangeAlpha = YES;
    [self.contenView.mj_header beginRefreshing];
    
    self.contenView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadMoreTopics
{
    // 结束下拉
    [self.contenView.mj_header endRefreshing];
    
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    NSInteger page = self.page + 1;
    // 参数
    NSDictionary *params = @{
                             @"page" : @(page),
                             @"size":@"8",
                             @"sort":@"0",
                             @"type" : @(self.type),
                             @"event":@"1",
                             @"user_id":entity.userId
                                    };
    self.params = params;
    
    FBRequest *request = [FBAPI postWithUrlString:URLFiuGoods requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (self.params != params) return;
        if (self.type == CollectionTypeSence) {
            if (result[@"success"]) {
                NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
                for (NSDictionary * goodsDic in goodsArr) {
                    if (![goodsDic[@"scene_product"] isKindOfClass:[NSNull class]]) {
                        NSDictionary *productDict = goodsDic[@"scene_product"];
                        GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:productDict];
                        [self.goodsList addObject:goodsModel];
                        [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
                    }
                }
                [_contenView reloadData];
                // 结束刷新
                [self.contenView.mj_footer endRefreshing];
                if (goodsArr.count == 0) {
                    self.contenView.mj_footer.hidden = YES;
                }
                // 清空页码
                self.page = page;
            }else{
                if (self.params != params) return;
                
                // 结束刷新
                [self.contenView.mj_footer endRefreshing];
            }
        }else{
            if (result[@"success"]) {
                NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
                for (NSDictionary * sceneDic in sceneArr) {
                    NSDictionary *sight = sceneDic[@"sight"];
                    HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] init];
                    homeSceneModel.coverUrl = sight[@"cover_url"];
                    homeSceneModel.title = sight[@"scene_title"];
                    [_sceneListMarr addObject:homeSceneModel];
                    [_sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
                }
                
                [_contenView reloadData];
                // 结束刷新
                [self.contenView.mj_footer endRefreshing];
                if (sceneArr.count == 0) {
                    self.contenView.mj_footer.hidden = YES;
                }
                // 清空页码
                self.page = page;
            }else{
                if (self.params != params) return;
                
                // 结束刷新
                [self.contenView.mj_footer endRefreshing];
            }
        }
        
    } failure:nil];
}


#pragma mark - 收藏的商品数组
-(NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

#pragma mark - 收藏的商品id数组
-(NSMutableArray *)goodsIdList{
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}

- (void)loadNewTopics
{
    // 结束上啦
    [self.contenView.mj_footer endRefreshing];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    // 参数
    NSDictionary *params = @{
                             @"page" : @(1),
                                    @"size":@"8",
                                    @"sort":@"0",
                                    @"type" : @(self.type),
                                    @"event":@"1",
                                    @"user_id":entity.userId
                                    };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:URLFiuGoods requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (self.params != params) return;
        if (self.type == CollectionTypeGood) {
            if (result[@"success"]) {
                [self.goodsList removeAllObjects];
                [self.goodsIdList removeAllObjects];
                NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
                for (NSDictionary * goodsDic in goodsArr) {
                    if (![goodsDic[@"scene_product"] isKindOfClass:[NSNull class]]) {
                        NSDictionary *productDict = goodsDic[@"scene_product"];
                        GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:productDict];
                        [self.goodsList addObject:goodsModel];
                        [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
                    }
                }
                [_contenView reloadData];
                // 结束刷新
                [self.contenView.mj_header endRefreshing];
                if ([result[@"data"][@"total_page"] integerValue] == 1) {
                    self.contenView.mj_footer.hidden = YES;
                }
                // 清空页码
                self.page = 1;
            }else{
                if (self.params != params) return;
                
                // 结束刷新
                [self.contenView.mj_header endRefreshing];
            }
        }else{
            if (result[@"success"]) {
                NSLog(@"result %@",result);
                [_sceneListMarr removeAllObjects];
                [_sceneIdMarr removeAllObjects];
                NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
                for (NSDictionary * sceneDic in sceneArr) {
                    NSDictionary *sight = sceneDic[@"sight"];
                    HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] init];
                    homeSceneModel.coverUrl = sight[@"cover_url"];
                    homeSceneModel.title = sight[@"scene_title"];
                    [_sceneListMarr addObject:homeSceneModel];
                    [_sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
                }
                [_contenView reloadData];
                // 结束刷新
                [self.contenView.mj_header endRefreshing];
                if ([result[@"data"][@"total_page"] integerValue] == 1) {
                    self.contenView.mj_footer.hidden = YES;
                }
                // 清空页码
                self.page = 1;
            }else{
                if (self.params != params) return;
                
                // 结束刷新
                [self.contenView.mj_header endRefreshing];
            }
        }
        
    } failure:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == CollectionTypeGood) {
        return self.goodsIdList.count;
    }
    return _sceneIdMarr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 1, 15);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == CollectionTypeGood) {
        THNGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellId forIndexPath:indexPath];
        cell.model = self.goodsList[indexPath.row];
        return cell;
    }else if (self.type == CollectionTypeSence){
        THNHomeSenceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneCellId forIndexPath:indexPath];
        cell.model = _sceneListMarr[indexPath.row];
        return cell;
    }
    UICollectionViewCell *cell;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == CollectionTypeGood) {
        return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.31 * SCREEN_HEIGHT);
    }
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.25 * SCREEN_HEIGHT);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == CollectionTypeGood) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
        goodsInfoVC.isWant = YES;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }else{
        SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
        sceneInfoVC.sceneId = _sceneIdMarr[indexPath.row];
        [self.navigationController pushViewController:sceneInfoVC animated:YES];
    }
}

@end
