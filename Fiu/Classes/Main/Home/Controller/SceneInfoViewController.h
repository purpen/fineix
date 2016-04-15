//
//  SceneInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "GroupHeaderView.h"

@interface SceneInfoViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong UITableView             *   sceneTableView;     //  场景视图
@pro_strong GroupHeaderView         *   headerView;         //  分组头部视图

@pro_strong NSMutableArray          *   textMar;

@end
