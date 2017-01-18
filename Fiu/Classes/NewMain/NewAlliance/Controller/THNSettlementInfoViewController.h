//
//  THNSettlementInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNSettlementInfoViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) FBRequest *infoRequest;
@property (nonatomic, strong) NSMutableArray *dataMarr;
@property (nonatomic, strong) UITableView *infoTable;

@end
