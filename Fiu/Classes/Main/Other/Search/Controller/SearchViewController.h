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
@pro_strong NSString                        *   keyword;        //  搜索关键词

/*
 *  搜索的类型
 *  0:场景 / 1:情景 / 2:用户 / 3:产品
 */
@pro_assign NSInteger                           searchType;

@end
