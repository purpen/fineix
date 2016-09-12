//
//  THNUserAddGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 16/9/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNUserAddGoodsViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong UIImageView *rollImageView;
@pro_strong UITableView *goodsTable;
@pro_strong NSString *brandTitle;
@pro_strong NSString *goodsTitle;

@end
