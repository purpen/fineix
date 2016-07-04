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
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJRefresh.h"

@interface SearchViewController : FBViewController <SearchMenuBtnSelectedDelegate, FBSearchDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong FBRequest                       *   searchListRequest;
@pro_assign NSInteger                           currentpageNum;
@pro_assign NSInteger                           totalPageNum;

@pro_assign BOOL                                beginSearch;
@pro_strong UIScrollView                    *   resultsView;            //  搜索结果视图
@pro_strong FBSearchView                    *   searchView;             //  搜索框
@pro_strong NSArray                         *   titleArr;               //  分类标题
@pro_strong SearchMenuView                  *   menuView;               //  分类导航
@pro_strong NSString                        *   keyword;                //  搜索关键词
@pro_strong UITableView                     *   sceneTable;             //  场景
@pro_strong UICollectionView                *   fSceneCollection;       //  情景
@pro_strong UITableView                     *   goodsTable;             //  商品
@pro_strong UILabel                         *   noneLab;

/*
 *  搜索的类型
 *  0:场景 / 1:情景 / 2:产品
 */
@pro_assign NSInteger                           searchType;

@end
