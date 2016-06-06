//
//  LookSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "GroupHeaderView.h"
#import "LikeSceneView.h"
#import "FBSceneInfoScrollView.h"

@interface LookSceneViewController : FBPictureViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   sceneInfoRequest;
@pro_strong FBRequest               *   sceneCommentRequest;
@pro_strong FBRequest               *   likePeopleRequest;
@pro_strong FBRequest               *   sceneGoodsRequest;
@pro_strong FBRequest               *   recommendRequest;
@pro_strong FBRequest               *   likeSceneRequest;
@pro_strong FBRequest               *   cancelLikeRequest;
@pro_strong FBRequest               *   wantBuyRequest;
@pro_strong FBRequest               *   deleteSceneRequest;

@pro_strong NSString                *   sceneId;                //  场景ID
@pro_strong UITableView             *   sceneTableView;         //  场景视图
@pro_strong GroupHeaderView         *   headerView;             //  分组头部视图
@pro_strong UIButton                *   allComment;             //  查看全部评论
@pro_strong NSMutableArray          *   textMar;
@pro_strong UIButton                *   shareSceneBtn;          //  分享

@end
