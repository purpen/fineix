//
//  THNSettlementInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNSettlementInfoViewController.h"
#import "THNRecordStateTableViewCell.h"
#import "THNRecordInfoTableViewCell.h"
#import "THNSettlementInfoRow.h"
#import "MJRefresh.h"

static NSString *const URLSettlementInfo = @"/balance_record/item_list";
static NSString *const infoCellId = @"THNRecordInfoTableViewCellId";
static NSString *const stateCellId = @"THNRecordStateTableViewCellId";

@interface THNSettlementInfoViewController ()

@end

@implementation THNSettlementInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.recordId.length) {
        [self thn_networkSettlementRecordInfoData];
    }
    [self setViewUI];
}

#pragma mark - 请求结算详情数据
- (void)thn_networkSettlementRecordInfoData {
    [SVProgressHUD show];
    self.infoRequest = [FBAPI postWithUrlString:URLSettlementInfo
                              requestDictionary:@{@"balance_record_id":self.recordId, @"page":@(self.currentpageNum + 1), @"size":@"10", @"sort":@"0"}
                                       delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        NSArray *dataArr = dict[@"rows"];
        for (NSDictionary *modelDict in dataArr) {
            THNSettlementInfoRow *model = [[THNSettlementInfoRow alloc] initWithDictionary:modelDict];
            [self.dataMarr addObject:model];
        }
        
        if (self.dataMarr.count > 0) {
            [self.infoTable reloadData];
        }

        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.infoTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 上拉加载更多
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self thn_networkSettlementRecordInfoData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置UI
- (void)setViewUI {
    [self.view addSubview:self.infoTable];
}

- (THNRecordTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNRecordTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_headerView thn_setSettlementMoney:self.money];
    }
    return _headerView;
}

- (UITableView *)infoTable {
    if (!_infoTable) {
        _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:(UITableViewStyleGrouped)];
        _infoTable.delegate = self;
        _infoTable.dataSource = self;
        _infoTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _infoTable.tableFooterView = [UIView new];
        _infoTable.tableHeaderView = self.headerView;
        if ([_infoTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_infoTable setSeparatorInset:(UIEdgeInsetsZero)];
        }
        [self addMJRefresh:_infoTable];
    }
    return _infoTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        THNRecordInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
        cell = [[THNRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:infoCellId];
        [cell thn_setSettlementRecordInfoData:self.dataMarr[indexPath.section]];
        return cell;
        
    } else {
        THNRecordStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateCellId];
        cell = [[THNRecordStateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:stateCellId];
        if (indexPath.row == 0) {
            [cell thn_setSettlementRecordInfoData:self.dataMarr[indexPath.section]];
        } else if (indexPath.row == 2) {
            [cell thn_setSettlementRecordInfoDataBottom:self.dataMarr[indexPath.section]];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 160.0f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:(UIEdgeInsetsZero)];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"结算明细";
}

- (NSMutableArray *)dataMarr {
    if (!_dataMarr) {
        _dataMarr = [NSMutableArray array];
    }
    return _dataMarr;
}

@end
