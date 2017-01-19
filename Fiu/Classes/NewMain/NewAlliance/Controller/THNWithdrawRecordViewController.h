//
//  THNWithdrawRecordViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNWithdrawRecordViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FBRequest *withdrawRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSMutableArray *dataMarr;
@property (nonatomic, strong) UITableView *recordTable;

@end
