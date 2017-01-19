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

static NSString *const URLTradingInfo = @"/balance/view";
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
    
    if (self.recordId.length) {
        [self thn_networkTradingRecordInfoData];
    }
    [self setViewUI];
}

#pragma mark - 请求交易详情数据
- (void)thn_networkTradingRecordInfoData {
    [SVProgressHUD show];
    self.infoRequest = [FBAPI postWithUrlString:URLTradingInfo requestDictionary:@{@"id":self.recordId} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        self.dataModel = [[THNTradingInfoData alloc] initWithDictionary:dict];
        [self.infoTable reloadData];

        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置UI
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
        if ([_infoTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_infoTable setSeparatorInset:(UIEdgeInsetsZero)];
        }
    }
    return _infoTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        THNRecordInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
        cell = [[THNRecordInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:infoCellId];
        [cell thn_setTradingRecordInfoData:self.dataModel];
        return cell;
    
    } else {
        THNRecordStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateCellId];
        cell = [[THNRecordStateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:stateCellId];
        if (indexPath.row == 0) {
            [cell thn_setTradingRecordInfoDataTop:self.dataModel];
        } else if (indexPath.row == 2) {
            [cell thn_setTradingRecordInfoDataBottom:self.dataModel];
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
