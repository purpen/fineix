//
//  THNRefundInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRefundInfoViewController.h"
#import "THNGoodsInfoTableViewCell.h"
#import "THNDefaultTextTableViewCell.h"

static NSString *const GoodsInfoCellId   = @"THNGoodsInfoTableViewCellId";
static NSString *const DefaultTextCellId = @"THNDefaultTextTableViewCellId";
static NSString *const URLRefundInfo     = @"/shopping/refund_view";

@interface THNRefundInfoViewController ()

@end

@implementation THNRefundInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self post_networkRefundInfoData];
}

#pragma mark - 网络请求退款详情
- (void)post_networkRefundInfoData {
    [SVProgressHUD show];
    self.refundRequest = [FBAPI postWithUrlString:URLRefundInfo requestDictionary:@{@"id":self.refundId} delegate:nil];
    [self.refundRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"========= 退款详情：%@", result);
        NSDictionary *data = [result valueForKey:@"data"];
        self.productModel = [[ProductInfoModel alloc] initWithDictionary:[data valueForKey:@"product"]];
        
        NSString *price = [data valueForKey:@"refund_price"];
        NSString *reason = [data valueForKey:@"reason_label"];
        NSString *content = [data valueForKey:@"content"];
        NSString *idNum = [data valueForKey:@"_id"];
        NSString *time = [data valueForKey:@"created_at"];
        RefundStage stage = (RefundStage)[[data valueForKey:@"stage"] integerValue];
        NSString *summary;
        if (![[data valueForKey:@"summary"] isKindOfClass:[NSNull class]]) {
            summary = [data valueForKey:@"summary"];
        }
        _dataArr = @[price, reason, content, idNum, time];
        [self.headerView thn_setRefundStage:stage withSummary:summary type:self.type];
        
        [self.view addSubview:self.infoTable];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - headerView
- (THNStateHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNStateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    }
    return _headerView;
}

#pragma mark - UiTableView
- (UITableView *)infoTable {
    if (!_infoTable) {
        _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _infoTable.delegate = self;
        _infoTable.dataSource = self;
        _infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTable.bounces = NO;
        _infoTable.showsVerticalScrollIndicator = NO;
        _infoTable.tableHeaderView = self.headerView;
        _infoTable.tableFooterView = [UIView new];
        _infoTable.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _infoTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsInfoCellId];
        cell = [[THNGoodsInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsInfoCellId];
        if (self.productModel) {
            [cell thn_setGoodsInfoData:self.productModel withRid:@""];
        }
        return cell;
        
    } else {
        THNDefaultTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultTextCellId];
        cell = [[THNDefaultTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:DefaultTextCellId];
        [cell thn_setExplainText:indexPath.row - 1 data:_dataArr[indexPath.row - 1]];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 95;
    } else {
        return 44;
    }
    return 0.01;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    if (self.type == 1) {
        self.navViewTitle.text = @"退款详情";
    } else if (self.type == 2) {
        self.navViewTitle.text = @"退货详情";
    }
}

#pragma mark - 
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

@end
