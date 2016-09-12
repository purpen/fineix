//
//  THNSubscribeViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNSubscribeViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong FBRequest *subscribeCountRequest;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *sceneListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong UIButton *lookAllSubscribe;
@pro_strong UICollectionView *sceneList;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong NSMutableArray *commentsMarr;

@end
