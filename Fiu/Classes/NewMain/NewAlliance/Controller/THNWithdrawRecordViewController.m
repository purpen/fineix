//
//  THNWithdrawRecordViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawRecordViewController.h"
#import "THNWithdrawRecordTableViewCell.h"
#import "THNWithdrawRow.h"
#import "MJRefresh.h"

static NSString *const URLWithdraw = @"/withdraw_cash/getlist";
static NSString *const recordCellId = @"THNWithdrawRecordTableViewCellId";

@interface THNWithdrawRecordViewController ()

@end

@implementation THNWithdrawRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkWithdrawRecordListData];
    [self setViewUI];
}

#pragma mark - 请求结算列表数据
- (void)thn_networkWithdrawRecordListData {
    [SVProgressHUD show];
    self.withdrawRequest = [FBAPI postWithUrlString:URLWithdraw
                                  requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@"10", @"sort":@"0"}
                                           delegate:self];
    [self.withdrawRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        NSArray *dataArr = dict[@"rows"];
        for (NSDictionary *modelDict in dataArr) {
            THNWithdrawRow *model = [[THNWithdrawRow alloc] initWithDictionary:modelDict];
            [self.dataMarr addObject:model];
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
            [self thn_networkWithdrawRecordListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置UI
- (void)setViewUI {
    [self.view addSubview:self.recordTable];
}

- (UITableView *)recordTable {
    if (!_recordTable) {
        _recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:(UITableViewStylePlain)];
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
        [cell thn_setWithdrawRecordData:self.dataMarr[indexPath.row]];
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

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"提现记录";
}

- (NSMutableArray *)dataMarr {
    if (!_dataMarr) {
        _dataMarr = [NSMutableArray array];
    }
    return _dataMarr;
}

@end
