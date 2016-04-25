//
//  DiscoverViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "FBRollImages.h"

@interface DiscoverViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   rollImgRequest;
@pro_strong UITableView             *   discoverTableView;
@pro_strong GroupHeaderView         *   headerView;
@pro_strong FBRollImages            *   rollView;

@end
