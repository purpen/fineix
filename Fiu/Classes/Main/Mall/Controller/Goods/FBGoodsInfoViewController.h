//
//  FBGoodsInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBRollImages.h"
#import "IDMPhotoBrowser.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FBSegmentView.h"
#import "THNGoodsBuyView.h"

@interface FBGoodsInfoViewController : FBViewController <
    FBRequestDelegate,
    FBNavigationBarItemsDelegate,
    FBSegmentViewDelegate,
    THNGoodsBuyViewBtnDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIWebViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIScrollView    *goodsInfoRoll;
@property (nonatomic, strong) FBRollImages    *rollImgView;        //  轮播图
@property (nonatomic, strong) UITableView     *goodsTable;
@property (nonatomic, strong) UIWebView       *goodsInfoWeb;
@property (nonatomic, strong) FBSegmentView   *menuView;
@property (nonatomic, strong) NSString        *goodsID;            //  商品id
@property (nonatomic, strong) NSString        *storageId;          //  地盘id
@property (nonatomic, strong) FBRequest       *buyingRequest;
@property (nonatomic, strong) FBRequest       *goodsInfoRequest;
@property (nonatomic, strong) FBRequest       *addCarRequest;
@property (nonatomic, strong) FBRequest       *collectRequest;
@property (nonatomic, strong) FBRequest       *cancelCollectRequest;
@property (nonatomic, strong) FBRequest       *likeSceneRequest;
@property (nonatomic, strong) FBRequest       *cancelLikeRequest;
@property (nonatomic, strong) FBRequest       *sceneRequest;
@property (nonatomic, assign) NSInteger        currentpageNum;
@property (nonatomic, assign) NSInteger        totalPageNum;

@property (nonatomic, strong) UICollectionView *sceneList;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
@property (nonatomic, strong) THNGoodsBuyView *goodsBuyView;

@end
