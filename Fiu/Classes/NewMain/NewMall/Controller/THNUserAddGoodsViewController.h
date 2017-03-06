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

@property (nonatomic, strong) UIImageView *rollImageView;
@property (nonatomic, strong) UITableView *goodsTable;
@property (nonatomic, strong) NSString *brandTitle;
@property (nonatomic, strong) NSString *goodsTitle;

@end
