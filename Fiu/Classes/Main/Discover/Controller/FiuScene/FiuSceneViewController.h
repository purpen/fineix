//
//  FiuSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "SuFiuScenrView.h"
#import "MJRefresh.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FBSceneInfoScrollView.h"
#import "FiuUserInfoTableViewCell.h"
#import "ContentAndTagTableViewCell.h"
#import "LikePeopleTableViewCell.h"
#import "SceneListTableViewCell.h"
#import "SceneInfoViewController.h"
#import "PictureToolViewController.h"
#import "FiuSceneInfoData.h"
#import "NoHaveSceneTableViewCell.h"
#import "NearChangViewController.h"
#import "FBAlertViewController.h"

@interface FiuSceneViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@pro_strong FBRequest               *   fiuSceneRequest;
@pro_strong FBRequest               *   fiuSceneListRequest;
@pro_strong FBRequest               *   suFiuSceneRequest;
@pro_strong FBRequest               *   cancelSuRequest;
@pro_strong FBRequest               *   suPeopleRequest;
@pro_strong FBRequest               *   delFiuSceneRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong NSArray                     *   textMar;
@pro_strong UITableView                 *   fiuSceneTable;          //  情景视图
@pro_strong GroupHeaderView             *   headerView;             //  分组头部视图
@pro_assign BOOL                            rollDown;               //  是否下拉
@pro_assign CGFloat                         lastContentOffset;      //  滚动的方向
@pro_strong NSString                    *   fiuSceneId;             //  情景Id

@pro_strong FiuSceneInfoData            *   fiuSceneData;
@pro_strong NSMutableArray              *   sceneListMarr;
@pro_strong NSMutableArray              *   sceneIdMarr;
@pro_strong NSMutableArray              *   suPeopleMarr;     //  点赞的人
/**城市图标加手势 */
@pro_strong UITapGestureRecognizer *cityTap;

@end
