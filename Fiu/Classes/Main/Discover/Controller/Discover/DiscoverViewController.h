//
//  DiscoverViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "FBRollImages.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "FBRefresh.h"

@interface DiscoverViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   rollImgRequest;
@pro_strong FBRequest               *   fiuSceneRequest;
@pro_strong FBRequest               *   sceneListRequest;
@pro_strong FBRequest               *   tagsRequest;
@pro_strong FBRequest               *   fiuPeopleRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong UITableView             *   discoverTableView;
@pro_strong GroupHeaderView         *   headerView;
@pro_strong FBRollImages            *   rollView;

@end
