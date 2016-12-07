//
//  THNLogisticsInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2016/12/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNLogisticsInfoViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *expressNo;
@property (nonatomic, strong) NSString *expressCaty;
@property (nonatomic, strong) NSString *expressCom;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *logisticTable;
@property (nonatomic, strong) FBRequest *logisticRequest;
@property (nonatomic, strong) NSMutableArray *logisticMarr;

@end
