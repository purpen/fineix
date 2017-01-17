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
    
    [self setViewUI];
}

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
        if ([_recordTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_recordTable setSeparatorInset:(UIEdgeInsetsZero)];
        }
    }
    return _recordTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSettlementRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellId];
    if (!cell) {
        cell = [[THNSettlementRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:recordCellId];
        [cell thn_setSettlementRecordData:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_recordTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_recordTable setSeparatorInset:(UIEdgeInsetsZero)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSettlementInfoViewController *settlementInfoVC = [[THNSettlementInfoViewController alloc] init];
    [self.navigationController pushViewController:settlementInfoVC animated:YES];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"结算记录";
}

@end
