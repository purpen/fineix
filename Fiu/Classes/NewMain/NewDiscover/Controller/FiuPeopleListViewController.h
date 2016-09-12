//
//  FiuPeopleListViewController.h
//  Fiu
//
//  Created by FLYang on 16/7/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FiuPeopleListViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDataSource, UITableViewDelegate>

@pro_strong FBRequest               *   fiuPeopleRequest;
@pro_strong UITableView             *   userListTable;

@end
