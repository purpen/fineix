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

@interface SearchViewController : FBViewController <
    SearchMenuBtnSelectedDelegate,
    FBSearchDelegate
>

@pro_strong UIScrollView *resultsView;  //  搜索结果视图
@pro_strong FBSearchView *searchView;   //  搜索框
@pro_strong NSArray *titleArr;          //  分类标题
@pro_strong SearchMenuView *menuView;   //  分类导航

/**
 * index
 *  0:情境 ／ 1:用户 ／ 2:产品 ／ 3:品牌 ／ 4:专题
 */
@pro_assign NSInteger index;
/**
 *  keyword
 *  直接搜索传搜索关键字
 */
@pro_strong NSString *keyword;

@end
