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
#import "CategoryMenuView.h"

@interface THNDiscoverViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *categoryRequest;
@pro_strong FBRequest *sceneListRequest;
@pro_strong FBRequest *subjectRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong UICollectionView *sceneList;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong NSMutableArray *categoryMarr;
@pro_strong NSMutableArray *commentsMarr;
@pro_strong NSMutableArray *subjectMarr;
@pro_strong NSMutableArray *subjectIdMarr;
@pro_strong NSMutableArray *subjectTypeMarr;

@pro_strong CategoryMenuView *topCategoryView;

@end
