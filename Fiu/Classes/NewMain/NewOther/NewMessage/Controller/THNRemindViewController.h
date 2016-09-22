//
//  THNRemindViewController.h
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNRemindViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong FBRequest *remindRequest;
@pro_strong UITableView *remindTable;
@pro_strong NSMutableArray *remindMarr;

@end
