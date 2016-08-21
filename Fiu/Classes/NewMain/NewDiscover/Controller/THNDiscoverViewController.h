//
//  THNDiscoverViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "GroupHeaderView.h"
#import "FBCategoryView.h"
#import "MJRefresh.h"
#import "FBRefresh.h"

@interface THNDiscoverViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong UITableView *discoverTable;
@pro_strong GroupHeaderView *headerView;
@pro_strong FBCategoryView *categoryView;
@pro_strong FBRequest *categoryRequest;
@pro_strong FBRequest *sceneListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;

@end
