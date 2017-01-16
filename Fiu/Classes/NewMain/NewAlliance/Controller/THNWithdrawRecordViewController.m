//
//  THNWithdrawRecordViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawRecordViewController.h"
#import "THNWithdrawRecordTableViewCell.h"

static NSString *const withdrawRecordCellId = @"THNWithdrawRecordTableViewCellId";

@interface THNWithdrawRecordViewController ()

@end

@implementation THNWithdrawRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewUI];
}

- (void)setViewUI {
    [self.view addSubview:self.recordTable];
}

- (UITableView *)recordTable {
    if (!_recordTable) {
        _recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:(UITableViewStyleGrouped)];
        _recordTable.delegate = self;
        _recordTable.dataSource = self;
        _recordTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _recordTable.tableFooterView = [UIView new];
    }
    return _recordTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNWithdrawRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:withdrawRecordCellId];
    if (!cell) {
        cell = [[THNWithdrawRecordTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:withdrawRecordCellId];
        if (indexPath.section == 0) {
            [cell thn_showTotalMoney];
            
        } else {
            [cell thn_setWithdrawRecordData:indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"提现记录";
}

@end
