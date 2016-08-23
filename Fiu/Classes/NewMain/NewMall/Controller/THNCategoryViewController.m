//
//  THNCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCategoryViewController.h"
#import "MallListGoodsCollectionViewCell.h"
#import "GoodsRow.h"
#import "ChildTagsTag.h"

static NSString *const URLChildTags = @"/category/fetch_child_tags";
static NSString *const URLMallList = @"/scene_product/getlist";
static NSString *const goodsListCellId = @"GoodsListCellId";

@interface THNCategoryViewController () {
    NSString *_tagId;
}

@end

@implementation THNCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkCategoryData];
    [self setViewUI];
}

#pragma mark - 网络请求
#pragma mark 子分类
- (void)thn_networkCategoryData {
    self.childTagsRequest = [FBAPI getWithUrlString:URLChildTags requestDictionary:@{@"tag_id":self.categoryId} delegate:self];
    [self.childTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * childTagsArr = [[result valueForKey:@"data"] valueForKey:@"tags"];
        for (NSDictionary * childTagsDic in childTagsArr) {
            ChildTagsTag * childTagsModel = [[ChildTagsTag alloc] initWithDictionary:childTagsDic];
            [self.childTagsList addObject:childTagsModel.titleCn];
            [self.childTagsId addObject:[NSString stringWithFormat:@"%zi", childTagsModel.idField]];
        }
        if (self.childTagsId.count) {
            _tagId = self.childTagsId[0];
            [self thn_networkGoodsListData:_tagId];
        }
        [self.menuView updateMenuButtonData];
        [self.menuView updateMenuBtnState:0];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品列表
- (void)thn_networkGoodsListData:(NSString *)tagId {
    [SVProgressHUD show];
    self.goodsListRequest = [FBAPI getWithUrlString:URLMallList requestDictionary:@{@"page":@(self.currentpageNum + 1),
                                                                                    @"size":@10,
                                                                            @"category_tag_ids":tagId} delegate:self];
    [self.goodsListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.goodsList reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestIsLastData:(UICollectionView *)collectionView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        collectionView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (collectionView.mj_footer.state == MJRefreshStateNoMoreData) {
            [collectionView.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        collectionView.mj_footer.hidden = true;
    }
    if ([collectionView.mj_header isRefreshing]) {
        CGPoint tableY = collectionView.contentOffset;
        tableY.y = 0;
        if (collectionView.bounds.origin.y > 0) {
            [UIView animateWithDuration:.3 animations:^{
                collectionView.contentOffset = tableY;
            }];
        }
        [collectionView.mj_header endRefreshing];
    }
    if ([collectionView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [collectionView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UICollectionView *)collectionView {
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self thn_networkGoodsListData:_tagId];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.goodsList];
    [self.view addSubview:self.menuView];
}

#pragma mark - init
- (FBMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.menuTitle = self.childTagsList;
        _menuView.delegate = self;
        _menuView.defaultColor = @"#666666";
    }
    return _menuView;
}

- (void)menuItemSelectedWithIndex:(NSInteger)index {
    _tagId = self.childTagsId[index];
    
    [self.goodsIdMarr removeAllObjects];
    [self.goodsListMarr removeAllObjects];
    self.currentpageNum = 0;
    [self thn_networkGoodsListData:_tagId];
}

- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108)
                                        collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
        [self addMJRefresh:_goodsList];
    }
    return _goodsList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId
                                                                                          forIndexPath:indexPath];
    if (self.goodsListMarr.count) {
        [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"查看商品详情：%@",self.goodsIdMarr[indexPath.row]]];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = self.vcTitle;
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"" image:@"mall_car"];
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

- (NSMutableArray *)childTagsList {
    if (!_childTagsList) {
        _childTagsList = [NSMutableArray array];
    }
    return _childTagsList;
}

- (NSMutableArray *)childTagsId {
    if (!_childTagsId) {
        _childTagsId = [NSMutableArray array];
    }
    return _childTagsId;
}

@end
