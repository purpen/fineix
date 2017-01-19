//
//  THNTradingRecordViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNTradingRecordViewController.h"
#import "THNTradingInfoViewController.h"
#import "THNWithdrawRecordTableViewCell.h"
#import "THNTradingRow.h"
#import "MJRefresh.h"

static NSString *const URLTrading = @"/balance/getlist";
static NSString *const recordCellId = @"THNWithdrawRecordTableViewCellId";

@interface THNTradingRecordViewController ()

@end

@implementation THNTradingRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkTradingRecordListData];
    [self setViewUI];
}

#pragma mark - 请求交易列表数据
- (void)thn_networkTradingRecordListData {
    [SVProgressHUD show];
    self.tradingRequest = [FBAPI postWithUrlString:URLTrading
                                 requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@"10", @"sort":@"0"}
                                          delegate:self];
    [self.tradingRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        NSArray *dataArr = dict[@"rows"];
        for (NSDictionary *modelDict in dataArr) {
            THNTradingRow *model = [[THNTradingRow alloc] initWithDictionary:modelDict];
            [self.dataMarr addObject:model];
            [self.idMarr addObject:model.idField];
        }
        
        if (self.dataMarr.count > 0) {
            [self.recordTable reloadData];
        }
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.recordTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
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
            [self thn_networkTradingRecordListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置UI
- (void)setViewUI {
    [self.view addSubview:self.recordHintView];
    [self.view addSubview:self.recordTable];
}

- (THNRecordHintView *)recordHintView {
    if (!_recordHintView) {
        _recordHintView = [[THNRecordHintView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [_recordHintView setTradingRecord];
    }
    return _recordHintView;
}

- (UITableView *)recordTable {
    if (!_recordTable) {
        _recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT -104) style:(UITableViewStylePlain)];
        _recordTable.delegate = self;
        _recordTable.dataSource = self;
        _recordTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _recordTable.tableFooterView = [UIView new];
        if ([_recordTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_recordTable setSeparatorInset:(UIEdgeInsetsZero)];
        }
        [self addMJRefresh:_recordTable];
    }
    return _recordTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNWithdrawRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellId];
    if (!cell) {
        cell = [[THNWithdrawRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:recordCellId];
        if (self.dataMarr.count) {
            [cell thn_setTradingRecordData:self.dataMarr[indexPath.row]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:(UIEdgeInsetsZero)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTradingInfoViewController *tradingInfoVC = [[THNTradingInfoViewController alloc] init];
    tradingInfoVC.recordId = self.idMarr[indexPath.row];
    [self.navigationController pushViewController:tradingInfoVC animated:YES];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"交易记录";
}

- (NSMutableArray *)dataMarr {
    if (!_dataMarr) {
        _dataMarr = [NSMutableArray array];
    }
    return _dataMarr;
}

- (NSMutableArray *)idMarr {
    if (!_idMarr) {
        _idMarr = [NSMutableArray array];
    }
    return _idMarr;
}

@end
