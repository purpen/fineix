//
//  GoodsBrandViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

@interface GoodsBrandViewController : FBViewController <
    FBNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong UITableView             *   goodsBrandTable;
@pro_strong FBRequest               *   brandRequest;
@pro_strong FBRequest               *   brandGoodsRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong NSString                *   brandId;
@pro_strong UILabel                 *   titleLab;
@pro_strong NSString                *   brandBgImg;

@pro_strong FBRequest *sceneRequest;
@pro_strong UICollectionView *sceneList;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;

@end
