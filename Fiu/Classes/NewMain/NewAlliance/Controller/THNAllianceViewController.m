//
//  THNAllianceViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAllianceViewController.h"
#import "THNWithdrawViewController.h"
#import "THNAlianceTableViewCell.h"
#import "THNTradingRecordViewController.h"
#import "THNWithdrawRecordViewController.h"
#import "THNSettlementRecordViewController.h"
#import "THNAlianceHeaderTableViewCell.h"
#import "THNChildAllianceViewController.h"

static NSString *const URLAliance = @"/alliance/view";
static NSString *const alianceCellId = @"THNAlianceTableViewCellId";
static NSString *const headerCellId = @"THNAlianceHeaderTableViewCellId";

@interface THNAllianceViewController () {
    BOOL _isAdmain;
}

@end

@implementation THNAllianceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    [self thn_networkAllinaceListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_isUserAdmin];
}

#pragma mark - 是否为父类账号可管理子账号
- (void)thn_isUserAdmin {
    _isAdmain = [self getLoginUserInfo].is_storage_manage;
    [self setViewUI];
}

#pragma mark - 请求账户数据
- (void)thn_networkAllinaceListData {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    self.alianceRequest = [FBAPI postWithUrlString:URLAliance requestDictionary:@{} delegate:self];
    [self.alianceRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        self.dataModel = [[THNAllinaceData alloc] initWithDictionary:dict];
        [self.alianceTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

#pragma mark - 设置UI
- (void)setViewUI {
    [self.view addSubview:self.alianceTable];
}

- (THNAllianceFootView *)footerView {
    if (!_footerView) {
        _footerView = [[THNAllianceFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _footerView.nav = self.navigationController;
    }
    return _footerView;
}

- (UITableView *)alianceTable {
    if (!_alianceTable) {
        _alianceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:(UITableViewStyleGrouped)];
        _alianceTable.delegate = self;
        _alianceTable.dataSource = self;
        _alianceTable.sectionFooterHeight = 10.0f;
        _alianceTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _alianceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _alianceTable.tableFooterView = self.footerView;
    }
    return _alianceTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isAdmain ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNAlianceHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellId];
        cell = [[THNAlianceHeaderTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:headerCellId];
        [cell thn_showAllianceData:self.dataModel];
        return cell;
    
    } else {
        THNAlianceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:alianceCellId];
        cell = [[THNAlianceTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:alianceCellId];
        if (indexPath.section == 1) {
            [cell thn_setShowRecordCellData:indexPath.row];
        } else {
            [cell thn_setChildUserCellData];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNWithdrawViewController *withdrawVC = [[THNWithdrawViewController alloc] init];
        [self.navigationController pushViewController:withdrawVC animated:YES];
        
    } else if (indexPath.section == 1) {
        [self.navigationController pushViewController:[self thn_getControllerArr][indexPath.row] animated:YES];
        
    } else if (indexPath.section == 2) {
        THNChildAllianceViewController *childAllianceVC = [[THNChildAllianceViewController alloc] init];
        [self.navigationController pushViewController:childAllianceVC animated:YES];
    }
}

- (NSArray *)thn_getControllerArr {
    THNTradingRecordViewController *tRecordVC = [[THNTradingRecordViewController alloc] init];
    tRecordVC.userId = @"";
    THNSettlementRecordViewController *sRecordVC = [[THNSettlementRecordViewController alloc] init];
    THNWithdrawRecordViewController *wRecordVC = [[THNWithdrawRecordViewController alloc] init];
    NSArray *controllerArr = @[tRecordVC, sRecordVC, wRecordVC];
    return controllerArr;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"我的钱包";
}

@end
