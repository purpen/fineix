//
//  MallSearchViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBSearchView.h"
#import "FBSegmentView.h"

@interface MallSearchViewController : FBViewController <
    FBSearchDelegate,
    FBSegmentViewDelegate
>

@pro_strong FBSearchView *searchView;   //  搜索框
@pro_strong FBSegmentView *menuView;
@pro_strong UIScrollView *resultsView;  //  搜索结果视图

@end
