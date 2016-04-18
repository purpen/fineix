//
//  SceneInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "LikeSceneView.h"

@interface SceneInfoViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong UITableView             *   sceneTableView;         //  场景视图
@pro_strong GroupHeaderView         *   headerView;             //  分组头部视图
@pro_strong LikeSceneView           *   likeScene;              //  点赞
@pro_strong NSMutableArray          *   textMar;
@pro_assign BOOL                        rollDown;               //  是否下拉
@pro_assign CGFloat                     lastContentOffset;      //  滚动的方向

@end
