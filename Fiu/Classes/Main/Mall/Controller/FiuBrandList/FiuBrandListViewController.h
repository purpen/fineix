//
//  FiuBrandListViewController.h
//  Fiu
//
//  Created by FLYang on 16/7/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBBrandGoodsView.h"
#import "BrandListModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FiuBrandListViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   brandListRequest;
@pro_strong FBRequest               *   selfBrandListRequest;

@pro_strong FBBrandGoodsView        *   seleBrandView;
@pro_strong UITableView             *   brandTable;

@end
