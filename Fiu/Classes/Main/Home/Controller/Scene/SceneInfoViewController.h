//
//  SceneInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "FBSceneInfoScrollView.h"
#import "UserInfoTableViewCell.h"
#import "DataNumTableViewCell.h"
#import "ContentAndTagTableViewCell.h"
#import "LikePeopleTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentNViewController.h"
#import "FBAlertViewController.h"
#import "GoodsInfoViewController.h"
#import "SceneInfoData.h"
#import "GoodsTableViewCell.h"
#import "CommentRow.h"
#import "GoodsRow.h"
#import "LikeOrSuPeopleRow.h"
#import "HomePageViewController.h"
#import "NearQingViewController.h"
#import "FBShareViewController.h"
#import "CommentNViewController.h"
#import "UIView+TYAlertView.h"
#import "UIImage+MultiFormat.h"
#import "DownSceneInfoView.h"

@interface SceneInfoViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@pro_strong FBRequest               *   sceneInfoRequest;
@pro_strong FBRequest               *   sceneCommentRequest;
@pro_strong FBRequest               *   likePeopleRequest;
@pro_strong FBRequest               *   sceneGoodsRequest;
@pro_strong FBRequest               *   recommendRequest;
@pro_strong FBRequest               *   likeSceneRequest;
@pro_strong FBRequest               *   cancelLikeRequest;
@pro_strong FBRequest               *   deleteSceneRequest;

@pro_strong NSString                *   sceneId;                //  场景ID
@pro_strong UITableView             *   sceneTableView;         //  场景视图
@pro_strong DownSceneInfoView       *   downImgView;
@pro_strong GroupHeaderView         *   headerView;             //  分组头部视图
@pro_strong UIButton                *   allComment;             //  查看全部评论
@pro_strong NSMutableArray          *   textMar;

@pro_strong HomeSceneListRow    *   homeSceneModel;
@pro_strong SceneInfoData       *   sceneInfoModel;
@pro_strong NSArray             *   commentArr;
@pro_strong NSMutableArray      *   sceneCommentMarr;   //  场景评论
@pro_strong NSMutableArray      *   likePeopleMarr;     //  点赞的人
@pro_strong NSArray             *   goodsId;            //  场景中商品id
@pro_strong NSMutableArray      *   goodsList;          //  商品列表
@pro_strong NSMutableArray      *   goodsIdList;        //  商品id
@pro_strong NSMutableArray      *   reGoodsList;        //  推荐商品列表
@pro_strong NSMutableArray      *   reGoodsIdList;      //  推荐商品id


@end
