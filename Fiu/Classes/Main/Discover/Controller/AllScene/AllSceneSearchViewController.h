//
//  AllSceneSearchViewController.h
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBSearchView.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AllSceneSearchViewController : FBViewController <FBNavigationBarItemsDelegate, FBSearchDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong FBSearchView            *   searchView;             //  搜索框
@pro_strong FBRequest               *   allSceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong UICollectionView        *   allSceneView;           //  全部的情景

@end
