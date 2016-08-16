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

@pro_strong FBRollImages *homerollView;
@pro_strong FBRequest *rollImgRequest;
@pro_strong UITableView *homeTable;
@pro_strong FBRequest *sceneListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong GroupHeaderView *headerView;

@pro_strong NSMutableArray *rollList;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;
@pro_strong NSMutableArray *userIdMarr;
@pro_strong NSMutableArray *commentsMarr;

@end
