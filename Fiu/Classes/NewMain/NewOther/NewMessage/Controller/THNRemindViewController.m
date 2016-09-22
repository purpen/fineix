//
//  THNRemindViewController.m
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRemindViewController.h"
#import "THNRemindTableViewCell.h"
#import "THNRemindModelRow.h"

static NSString *const URLRemind = @"/remind/getlist";
static NSString *const remindTableCellId = @"RemindTableCellId";

@interface THNRemindViewController ()

@end

@implementation THNRemindViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkReminData];
    [self thn_setRemindVcUI];
    
}

#pragma mark - 网络请求
- (void)thn_networkReminData {
    self.remindRequest = [FBAPI getWithUrlString:URLRemind requestDictionary:@{@"page":@"1", @"size":@"100000"} delegate:self];
    [self.remindRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDic in dataArr) {
            THNRemindModelRow *model = [[THNRemindModelRow alloc] initWithDictionary:dataDic];
            [self.remindMarr addObject:model];
        }
        [self.remindTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图
- (void)thn_setRemindVcUI {
    [self.view addSubview:self.remindTable];
}

#pragma mark - 提醒列表
- (UITableView *)remindTable {
    if (!_remindTable) {
        _remindTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _remindTable.delegate = self;
        _remindTable.dataSource = self;
        _remindTable.tableFooterView = [UIView new];
    }
    return _remindTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remindMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:remindTableCellId];
    cell = [[THNRemindTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:remindTableCellId];
    if (self.remindMarr.count) {
        [cell thn_setRemindData:self.remindMarr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.baseTable = self.remindTable;
    self.navViewTitle.text = NSLocalizedString(@"remindVC", nil);
}

#pragma mark - 
- (NSMutableArray *)remindMarr {
    if (!_remindMarr) {
        _remindMarr = [NSMutableArray array];
    }
    return _remindMarr;
}

@end
