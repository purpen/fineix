//
//  SearchViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "SearchMenuView.h"
#import "FBSearchView.h"
#import "SearchResultsRollView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SearchViewController : FBViewController <SearchMenuBtnSelectedDelegate, FBSearchDelegate>

@pro_strong SearchResultsRollView           *   resultsView;    //  搜索结果视图
@pro_strong FBSearchView                    *   searchView;     //  搜索框
@pro_strong NSArray                         *   titleArr;       //  分类标题
@pro_strong SearchMenuView                  *   menuView;       //  分类导航

@end
