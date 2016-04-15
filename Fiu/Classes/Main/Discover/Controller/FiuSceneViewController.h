//
//  FiuSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "SuFiuScenrView.h"

@interface FiuSceneViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong NSArray                 *   textMar;
@pro_strong UITableView             *   fiuSceneTable;      //  情景视图
@pro_strong GroupHeaderView         *   headerView;         //  分组头部视图
@pro_strong SuFiuScenrView          *   suBtn;              //  订阅按钮

@end
