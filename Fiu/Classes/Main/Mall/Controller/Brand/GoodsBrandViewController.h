//
//  GoodsBrandViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface GoodsBrandViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong UITableView             *   goodsBrandTable;
@pro_strong FBRequest               *   brandRequest;
@pro_strong NSString                *   brandId;
@pro_strong UILabel                 *   titleLab;
@pro_strong NSString                *   brandBgImg;

@end
