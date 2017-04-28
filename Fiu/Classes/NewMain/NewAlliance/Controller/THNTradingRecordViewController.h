//
//  THNTradingRecordViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNRecordHintView.h"

@interface THNTradingRecordViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

/**
 查询子账户id
 */
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) FBRequest *tradingRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSMutableArray *dataMarr;
@property (nonatomic, strong) NSMutableArray *idMarr;
@property (nonatomic, strong) THNRecordHintView *recordHintView;
@property (nonatomic, strong) UITableView *recordTable;

@end
