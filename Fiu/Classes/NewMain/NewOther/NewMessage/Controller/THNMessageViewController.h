//
//  THNMessageViewController.h
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNMessageViewController : THNViewController <
    UITableViewDataSource,
    UITableViewDelegate
>

@pro_strong FBRequest *userMessageRequest;
@pro_strong UITableView *messageTable;

@end
