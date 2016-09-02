//
//  THNSceneListViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNSceneListViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *followRequest;
@pro_strong FBRequest *cancelFollowRequest;
@pro_strong FBRequest *favoriteRequest;
@pro_strong FBRequest *cancelFavoriteRequest;

@pro_strong UITableView *sceneTable;
@pro_assign NSInteger index;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong NSMutableArray *commentsMarr;

@end
