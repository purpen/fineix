//
//  THNDomainSetViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNDomainSetViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *setTableView;

@end
