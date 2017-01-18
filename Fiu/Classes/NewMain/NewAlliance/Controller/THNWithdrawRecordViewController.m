//
//  THNWithdrawRecordViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawRecordViewController.h"
#import "THNWithdrawRecordTableViewCell.h"
#import "NSString+JSON.h"
#import "THNWithdrawRow.h"

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
    self.withdrawRequest = [FBAPI postWithUrlString:URLWithdraw requestDictionary:@{@"page":@"1", @"size":@"10000", @"sort":@"0"} delegate:self];
    [self.withdrawRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"==== %@", [NSString jsonStringWithObject:result]);
        NSDictionary *dict = [result valueForKey:@"data"];
        NSArray *dataArr = dict[@"rows"];
        for (NSDictionary *modelDict in dataArr) {
            THNWithdrawRow *model = [[THNWithdrawRow alloc] initWithDictionary:modelDict];
            [self.dataMarr addObject:model];
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
    [self.view addSubview:self.recordTable];
}

- (UITableView *)recordTable {
    if (!_recordTable) {
        _recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:(UITableViewStylePlain)];
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
