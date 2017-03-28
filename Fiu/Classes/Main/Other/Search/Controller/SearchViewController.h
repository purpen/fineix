//
//  SearchViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "SearchMenuView.h"
#import "FBSearchView.h"

@interface SearchViewController : THNViewController <
    SearchMenuBtnSelectedDelegate,
    FBSearchDelegate
>

@property (nonatomic, strong) UIScrollView *resultsView;  //  搜索结果视图
@property (nonatomic, strong) FBSearchView *searchView;   //  搜索框
@property (nonatomic, strong) NSArray *titleArr;          //  分类标题
@property (nonatomic, strong) SearchMenuView *menuView;   //  分类导航

/**
 * index
 * 0:产品 ／ 1:品牌 ／ 2:专题 ／ 3:情境 ／ 4:用户 ／
 */
@property (nonatomic, assign) NSInteger index;

/**
 *  keyword
 *  直接搜索传搜索关键字
 */
@property (nonatomic, strong) NSString *keyword;

/**
 *  evtType
 *  直接搜索的类型
 */
@property (nonatomic, strong) NSString *evtType;

@end
