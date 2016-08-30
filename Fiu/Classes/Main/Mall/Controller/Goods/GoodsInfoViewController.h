//
//  GoodsInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBRollImages.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface GoodsInfoViewController : FBViewController <
    FBNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong NSString *goodsID;
@pro_strong UITableView *goodsInfoTable;

@end
