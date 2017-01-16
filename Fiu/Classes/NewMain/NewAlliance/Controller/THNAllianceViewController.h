//
//  THNAllianceViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNAllianceViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *alianceTable;

@end
