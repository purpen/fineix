//
//  THNLogisticsInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2016/12/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLogisticsInfoViewController.h"
#import "THNLogisticTableViewCell.h"

static NSString *const LogisticCellId = @"THNLogisticTableViewCellId";
static NSString *const URLLogistic = @"/shopping/logistic_tracking";

@interface THNLogisticsInfoViewController () {
    NSInteger _index;
}

@end

@implementation THNLogisticsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.logisticTable];
    
    BOOL isHasRid = self.rid.length && self.expressNo.length && self.expressCaty.length;
    if (isHasRid) {
        [self post_networkLogisticInfoData];
    }
}

#pragma mark - 获取物流信息
- (void)post_networkLogisticInfoData {
    [SVProgressHUD show];
    NSDictionary *dict = @{@"rid":self.rid, @"express_no":self.expressNo, @"express_caty":self.expressCaty};
    self.logisticRequest = [FBAPI postWithUrlString:URLLogistic requestDictionary:dict delegate:nil];
    [self.logisticRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self thn_getLogisticData:result];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)thn_getLogisticData:(id)result {
    NSDictionary *dataDict = [result valueForKey:@"data"];
    self.logisticMarr = [NSMutableArray arrayWithArray:[dataDict valueForKey:@"Traces"]];
    [self.logisticTable reloadData];
    [SVProgressHUD dismiss];
}

#pragma mark - UITableView
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        NSString *noStr = [NSString stringWithFormat:@"快递单号: %@", self.expressNo];
        NSString *catyStr = [NSString stringWithFormat:@"快递公司: %@", self.expressCom];
        NSArray *textArr = @[catyStr, noStr];
        for (NSUInteger idx = 0; idx < textArr.count; ++ idx) {
            UILabel *catyLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 30*idx, SCREEN_WIDTH - 30, 15)];
            catyLab.textColor = [UIColor colorWithHexString:@"#333333"];
            catyLab.font = [UIFont systemFontOfSize:14];
            catyLab.text = textArr[idx];
            [_headerView addSubview:catyLab];
        }
        
        UILabel *botLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 79, SCREEN_WIDTH - 15, 1)];
        botLab.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [_headerView addSubview:botLab];
    }
    return _headerView;
}

- (UITableView *)logisticTable {
    if (!_logisticTable) {
        _logisticTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _logisticTable.delegate = self;
        _logisticTable.dataSource = self;
        _logisticTable.tableFooterView = [UIView new];
        _logisticTable.tableHeaderView = self.headerView;
        _logisticTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _logisticTable.showsVerticalScrollIndicator = NO;
        _logisticTable.estimatedRowHeight = 120;
        _logisticTable.backgroundColor = [UIColor whiteColor];
    }
    return _logisticTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logisticMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLogisticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LogisticCellId];
    cell = [[THNLogisticTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:LogisticCellId];
    if (self.logisticMarr.count) {
        _index = (self.logisticMarr.count - 1) - indexPath.row;
        [cell thn_setLogisticData:self.logisticMarr[_index] index:indexPath.row];
    }
    return cell;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"物流详情";
}

#pragma mark - 
- (NSMutableArray *)logisticMarr {
    if (!_logisticMarr) {
        _logisticMarr = [NSMutableArray array];
    }
    return _logisticMarr;
}

@end
