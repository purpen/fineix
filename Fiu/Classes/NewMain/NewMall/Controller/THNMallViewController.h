//
//  THNMallViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "GroupHeaderView.h"
#import "CategoryMenuView.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "FBMenuView.h"

@interface THNMallViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    FBMenuViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UITableViewDelegate,
    UITableViewDataSource
>

//  好货推荐专题
@property (nonatomic, strong) FBRequest *categoryRequest;
@property (nonatomic, strong) FBRequest *mallListRequest;
@property (nonatomic, strong) FBRequest *subjectRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) UICollectionView *mallList;
@property (nonatomic, strong) NSMutableArray *goodsDataMarr;
@property (nonatomic, strong) NSMutableArray *subjectMarr;
@property (nonatomic, strong) NSMutableArray *subjectIdMarr;
@property (nonatomic, strong) NSMutableArray *subjectTypeMarr;

//  好货分类
@property (nonatomic, strong) FBMenuView *menuView;
@property (nonatomic, strong) NSMutableArray *categoryMarr;
@property (nonatomic, strong) NSMutableArray *categoryIdMarr;

//  分类商品列表
@property (nonatomic, strong) UICollectionView  *goodsList;
@property (nonatomic, strong) FBRequest *goodsListRequest;
@property (nonatomic, assign) NSInteger goodsCurrentpageNum;
@property (nonatomic, assign) NSInteger goodsTotalPageNum;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) NSMutableArray *cageSubjectMarr;
@property (nonatomic, strong) NSMutableArray *cageSubjectIdMarr;
@property (nonatomic, strong) NSMutableArray *cageSubjectTypeMarr;

//  人气商品
@property (nonatomic, strong) FBRequest *hotGoodsRequest;
@property (nonatomic, strong) NSMutableArray *hotGoodsMarr;

//  情境列表
@property (nonatomic, strong) FBRequest *sceneListRequest;
@property (nonatomic, assign) NSInteger sceneCurrentpage;
@property (nonatomic, assign) NSInteger sceneTotalPage;
@property (nonatomic, strong) FBRequest *likeSceneRequest;
@property (nonatomic, strong) FBRequest *cancelLikeRequest;
@property (nonatomic, strong) FBRequest *favoriteRequest;
@property (nonatomic, strong) FBRequest *cancelFavoriteRequest;
@property (nonatomic, strong) FBRequest *deleteRequest;
@property (nonatomic, strong) UITableView *sceneTable;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
@property (nonatomic, strong) NSMutableArray *userIdMarr;

@end
