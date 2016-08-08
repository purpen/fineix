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

@pro_strong FBRollImages *homerollView;     //  轮播图
@pro_strong FBRequest *rollImgRequest;
@pro_strong UITableView *homeTable;         //  首页列表
@pro_strong GroupHeaderView *headerView;    //  单元格分组视图

@end
