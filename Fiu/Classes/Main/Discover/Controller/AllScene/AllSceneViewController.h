//
//  AllSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AllSceneViewController : FBViewController <FBNavigationBarItemsDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong FBRequest               *   allSceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong UICollectionView        *   allSceneView;       //  全部的情景

@end
