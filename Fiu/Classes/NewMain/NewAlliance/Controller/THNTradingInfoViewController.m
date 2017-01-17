//
//  THNTradingInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNTradingInfoViewController.h"
#import "THNRecordStateTableViewCell.h"
#import "THNRecordInfoTableViewCell.h"

static NSString *const infoCellId = @"THNRecordInfoTableViewCellId";
static NSString *const stateCellId = @"THNRecordStateTableViewCellId";

@interface THNTradingInfoViewController ()

@end

@implementation THNTradingInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewUI];
}

- (void)setViewUI {
    [self.view addSubview:self.infoTable];
}

- (UITableView *)infoTable {
    if (!_infoTable) {
        _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:(UITableViewStyleGrouped)];
        _infoTable.delegate = self;
        _infoTable.dataSource = self;
        _infoTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _infoTable.tableFooterView = [UIView new];
        _infoTable.bounces = NO;
        if ([_infoTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_infoTable setSeparatorInset:(UIEdgeInsetsZero)];
        }
    }
    return _infoTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        THNRecordInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
        if (!cell) {
            cell = [[THNRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:infoCellId];
            [cell thn_setTradingRecordInfoData];
        }
        return cell;
    
    } else {
        THNRecordStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateCellId];
        if (!cell) {
            cell = [[THNRecordStateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:stateCellId];
            if (indexPath.row == 0) {
                [cell thn_setTradingRecordInfoDataTop];
            } else if (indexPath.row == 2) {
                [cell thn_setTradingRecordInfoDataBottom];
            }
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 155.0f;
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
    self.navViewTitle.text = @"交易明细";
}

@end
