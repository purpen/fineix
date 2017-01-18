//
//  THNSettlementRecordViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNSettlementRecordViewController.h"
#import "THNSettlementInfoViewController.h"
#import "THNSettlementRecordTableViewCell.h"
#import "THNBalanceRow.h"

static NSString *const URLbalance = @"/balance_record/getlist";
static NSString *const recordCellId = @"THNSettlementRecordTableViewCellId";

@interface THNSettlementRecordViewController ()

@end

@implementation THNSettlementRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkBalanceRecordListData];
    [self setViewUI];
}

#pragma mark - 请求结算列表数据
- (void)thn_networkBalanceRecordListData {
    [SVProgressHUD show];
    self.balanceRequest = [FBAPI postWithUrlString:URLbalance requestDictionary:@{@"page":@"1", @"size":@"10000", @"sort":@"0"} delegate:self];
    [self.balanceRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        NSArray *dataArr = dict[@"rows"];
        for (NSDictionary *modelDict in dataArr) {
            THNBalanceRow *model = [[THNBalanceRow alloc] initWithDictionary:modelDict];
            [self.dataMarr addObject:model];
            [self.idMarr addObject:model.idField];
        }
    
        if (self.dataMarr.count > 0) {
            [self.recordTable reloadData];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
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
        [_recordHintView setSettlementRecord];
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
        _recordTable.bounces = NO;
        if ([_recordTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_recordTable setSeparatorInset:(UIEdgeInsetsZero)];
        }
    }
    return _recordTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSettlementRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellId];
    if (!cell) {
        cell = [[THNSettlementRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:recordCellId];
        if (self.dataMarr.count) {
            [cell thn_setSettlementRecordData:self.dataMarr[indexPath.row]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:(UIEdgeInsetsZero)];
    }
}

#pragma makr - 查看详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSettlementInfoViewController *settlementInfoVC = [[THNSettlementInfoViewController alloc] init];
    settlementInfoVC.recordId = self.idMarr[indexPath.row];
    [self.navigationController pushViewController:settlementInfoVC animated:YES];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"结算记录";
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
