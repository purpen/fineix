//
//  AllSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "AllSceneView.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AllSceneViewController : FBViewController <FBNavigationBarItemsDelegate>

@pro_strong FBRequest               *   allSceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong AllSceneView            *   allSceneList;   //  情景列表

@end
