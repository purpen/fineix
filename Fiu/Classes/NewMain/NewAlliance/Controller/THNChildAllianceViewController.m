//
//  THNChildAllianceViewController.m
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNChildAllianceViewController.h"
#import "THNAddChildUserViewController.h"
#import "THNTradingRecordViewController.h"
#import "THNEditChildUserInfoViewController.h"

#import "THNChildUserTableViewCell.h"
#import "THNAddChildUserTableViewCell.h"

static NSString *const ChildUserCellId = @"THNChildUserTableViewCellId";
static NSString *const AddChildCellId = @"THNAddChildUserTableViewCellId";
static NSString *const URLChildList = @"/storage_manage/getlist";
static NSString *const URLDeleteUser = @"/storage_manage/deleted";

@interface THNChildAllianceViewController () {
    CGFloat _totalMoney;
}

@end

@implementation THNChildAllianceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    [self thn_networkGetChildUserListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.childTable];
}

#pragma mark - 获取子账号列表
- (void)thn_networkGetChildUserListData {
    _totalMoney = 0;
    [SVProgressHUD showWithMaskType:(SVProgressHUDMaskTypeBlack)];
    self.childUserRquest = [FBAPI postWithUrlString:URLChildList requestDictionary:@{@"page":@"1", @"size":@"10000", @"sort":@"0"} delegate:nil];
    [self.childUserRquest startRequestSuccess:^(FBRequest *request, id result) {
        [self.childDataArr removeAllObjects];
        [self.childIdArr removeAllObjects];
        [self.deleteIdArr removeAllObjects];
        [self.scaleArr removeAllObjects];
        
        NSLog(@"------------- 子账号列表%@", result);
        NSDictionary *dataDict = [result valueForKey:@"data"];
        NSArray *dataArr = dataDict[@"rows"];
        for (NSDictionary *modelDict in dataArr) {
            THNChildUserModel *model = [[THNChildUserModel alloc] initWithDictionary:modelDict];
            [self.childDataArr addObject:model];
            [self.childIdArr addObject:model.cid];
            [self.deleteIdArr addObject:model.idField];
            [self.scaleArr addObject:[NSString stringWithFormat:@"%.2f",model.addition]];
            _totalMoney += model.money;
        }
        [self.childHeaderView thn_setChildUserEarningsMoney:_totalMoney];
        
        [self.childTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"---- %@ ----", error);
    }];
}

/**
 删除子账号

 @param userId 账号id
 */
- (void)thn_networkDeleteUser:(NSString *)userId {
    self.deleteUserRquest = [FBAPI postWithUrlString:URLDeleteUser requestDictionary:@{@"id":userId} delegate:nil];
    [self.deleteUserRquest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"-------========== 删除账号 %@", result);
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
//        [self thn_networkGetChildUserListData];
        NSInteger index = [self.deleteIdArr indexOfObject:userId];
        [self.childIdArr removeObjectAtIndex:index];
        [self.childDataArr removeObjectAtIndex:index];
        [self.deleteIdArr removeObjectAtIndex:index];
        [self.scaleArr removeObjectAtIndex:index];
        [self.childTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"---- %@ ----", error);
    }];
}

#pragma mark - 视图
/**
 子账号列表
 */
- (UITableView *)childTable {
    if (!_childTable) {
        _childTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _childTable.delegate = self;
        _childTable.dataSource = self;
        _childTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _childTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _childTable.tableHeaderView = self.childHeaderView;
        _childTable.allowsMultipleSelection = NO;
        _childTable.allowsSelectionDuringEditing = NO;
        _childTable.allowsMultipleSelectionDuringEditing = NO;
    }
    return _childTable;
}

- (THNChildHeaderView *)childHeaderView {
    if (!_childHeaderView) {
        _childHeaderView = [[THNChildHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }
    return _childHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.childDataArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        THNAddChildUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddChildCellId];
        cell = [[THNAddChildUserTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:AddChildCellId];
        return cell;
    }
    
    THNChildUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChildUserCellId];
    cell = [[THNChildUserTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ChildUserCellId];
    if (self.childDataArr.count) {
        [cell thn_setChildUserData:self.childDataArr[indexPath.row]];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 48;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        THNAddChildUserViewController *addChildUserVC = [[THNAddChildUserViewController alloc] init];
        [self.navigationController pushViewController:addChildUserVC animated:YES];
    } else {
        THNTradingRecordViewController *tradingVC = [[THNTradingRecordViewController alloc] init];
        tradingVC.userId = self.childIdArr[indexPath.row];
        [self.navigationController pushViewController:tradingVC animated:YES];
    }
}

#pragma mark - 删除/编辑子账号单元格
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //  删除数据
        [self thn_networkDeleteUser:self.deleteIdArr[indexPath.row]];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //  编辑数据
        THNEditChildUserInfoViewController *editVC = [[THNEditChildUserInfoViewController alloc] init];
        editVC.childId = self.deleteIdArr[indexPath.row];
        [editVC thn_setEditUserInfo:self.childDataArr[indexPath.row]];
        [self.navigationController pushViewController:editVC animated:YES];
    }];
    editAction.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    
    return @[deleteAction, editAction];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"子账号管理";
}

#pragma mark - 
- (NSMutableArray *)childDataArr {
    if (!_childDataArr) {
        _childDataArr = [NSMutableArray array];
    }
    return _childDataArr;
}

- (NSMutableArray *)childIdArr {
    if (!_childIdArr) {
        _childIdArr = [NSMutableArray array];
    }
    return _childIdArr;
}

- (NSMutableArray *)deleteIdArr {
    if (!_deleteIdArr) {
        _deleteIdArr = [NSMutableArray array];
    }
    return _deleteIdArr;
}

@end
