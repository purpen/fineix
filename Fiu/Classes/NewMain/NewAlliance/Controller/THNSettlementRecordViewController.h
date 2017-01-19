//
//  THNSettlementRecordViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNRecordHintView.h"

@interface THNSettlementRecordViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FBRequest *balanceRequest;
@property (nonatomic, strong) NSMutableArray *dataMarr;
@property (nonatomic, strong) NSMutableArray *idMarr;
@property (nonatomic, strong) NSMutableArray *moneyMarr;
@property (nonatomic, strong) THNRecordHintView *recordHintView;
@property (nonatomic, strong) UITableView *recordTable;

@end
