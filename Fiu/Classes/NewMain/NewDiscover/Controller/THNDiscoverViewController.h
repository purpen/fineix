//
//  THNDiscoverViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "MJRefresh.h"
#import "FBRefresh.h"

@interface THNDiscoverViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *categoryRequest;
@pro_strong FBRequest *sceneListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong UICollectionView *sceneList;
@pro_strong NSMutableArray *categoryMarr;

@end
