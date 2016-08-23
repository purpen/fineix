//
//  THNHomeViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "FBRollImages.h"
#import "GroupHeaderView.h"

@interface THNHomeViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong FBRequest *rollImgRequest;
@pro_strong FBRequest *subjectRequest;
@pro_strong FBRequest *sceneListRequest;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *followRequest;
@pro_strong FBRequest *cancelFollowRequest;
@pro_strong FBRequest *viewCountRequest;
@pro_strong FBRequest *favoriteRequest;

@pro_strong FBRollImages *homerollView;
@pro_strong UITableView *homeTable;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong GroupHeaderView *headerView;

@pro_strong NSMutableArray *rollList;
@pro_strong NSMutableArray *subjectMarr;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong NSMutableArray *commentsMarr;

@end
