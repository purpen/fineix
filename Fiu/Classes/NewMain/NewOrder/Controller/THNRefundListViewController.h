//
//  THNRefundListViewController.h
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "MJRefresh.h"

@interface THNRefundListViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *refundTable;
@property (nonatomic, strong) FBRequest *refundRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSMutableArray *dataMarr;
@property (nonatomic, strong) NSMutableArray *goodsMarr;
@property (nonatomic, strong) NSMutableArray *idMarr;
@property (nonatomic, strong) NSMutableArray *typeMarr;

@end
