//
//  THNMallViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "GroupHeaderView.h"
#import "FBCategoryView.h"

@interface THNMallViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong UITableView *mallTable;
@pro_strong GroupHeaderView *headerView;
@pro_strong FBCategoryView *categoryView;

@end
