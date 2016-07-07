//
//  MallViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"
#import "GroupHeaderView.h"
#import "FBRollImages.h"
#import "FBRefresh.h"
#import "CategoryMenuView.h"

@interface MallViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   rollImgRequest;
@pro_strong FBRequest               *   tagsRequest;
@pro_strong FBRequest               *   categoryRequest;
@pro_strong FBRequest               *   fiuGoodsRequest;
@pro_strong FBRequest               *   fiuBrandRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong UITableView             *   mallTableView;
@pro_strong GroupHeaderView         *   headerView;
@pro_strong FBRollImages            *   rollView;
@pro_strong CategoryMenuView        *   categoryMenu;

@end
