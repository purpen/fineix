//
//  DiscoverCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "FBSegmentView.h"
#import "MJRefresh.h"

@interface DiscoverCategoryViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    FBSegmentViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong NSString *vcTitle;
@pro_strong FBSegmentView *menuView;

@pro_strong NSString *categoryId;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *subscribeCountRequest;
@pro_strong FBRequest *suThemeRequest;
@pro_strong FBRequest *sceneListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong NSMutableArray *commentsMarr;
@pro_strong UICollectionView *sceneList;

@end
