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

@interface FBGoodsInfoViewController : FBViewController <
    FBRequestDelegate,
    FBNavigationBarItemsDelegate,
    FBSegmentViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIWebViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@pro_strong UIScrollView    *   goodsInfoRoll;
@pro_strong FBRollImages    *   rollImgView;        //  轮播图
@pro_strong UITableView     *   goodsTable;
@pro_strong UIView          *   buyView;
@pro_strong UIButton        *   buyingBtn;
@pro_strong UIButton        *   likeBtn;
@pro_strong UIWebView       *   goodsInfoWeb;
@pro_strong FBSegmentView   *   menuView;

@pro_strong NSString        *   goodsID;            //  商品id
@pro_strong FBRequest       *   goodsInfoRequest;
@pro_strong FBRequest       *   addCarRequest;
@pro_strong FBRequest       *   collectRequest;
@pro_strong FBRequest       *   cancelCollectRequest;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *sceneRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong UICollectionView *sceneList;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;

@end
