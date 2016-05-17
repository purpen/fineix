//
//  MarkGoodsViewController.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "FBMenuView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

typedef void(^GetImgBlock)(NSString * imgUrl, NSString * title, NSString * price, NSString * ids);

@interface MarkGoodsViewController : FBPictureViewController <FBSearchDelegate, FBMenuViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong FBRequest               *   markGoodsRequest;
@pro_strong FBRequest               *   goodsDataRequest;
@pro_strong FBRequest               *   searchRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong UICollectionView        *   goodsListView;          //  商品列表
@pro_strong FBMenuView              *   categoryMenuView;       //  滑动导航栏
@pro_strong FBSearchView            *   searchGoods;            //  搜索框

@pro_strong GetImgBlock getImgBlock;

@end
