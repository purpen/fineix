//
//  AllSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBMenuView.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AllSceneViewController : FBViewController <FBNavigationBarItemsDelegate, UICollectionViewDelegate, UICollectionViewDataSource, FBMenuViewDelegate>

@pro_strong FBRequest               *   categoryListRequest;
@pro_strong FBRequest               *   allSceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong FBMenuView              *   categoryMenuView;       //  滑动导航栏
@pro_strong UICollectionView        *   allSceneView;           //  全部的情景
@pro_strong UIButton                *   beginSearchBtn;         //  搜索情境

@end
