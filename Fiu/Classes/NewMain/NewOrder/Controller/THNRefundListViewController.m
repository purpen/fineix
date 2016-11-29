//
//  THNRefundListViewController.m
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRefundListViewController.h"
#import "THNRefundNumberTableViewCell.h"
#import "THNRefundTimeTableViewCell.h"
#import "THNGoodsInfoTableViewCell.h"
#import "RefundGoodsModel.h"
#import "ProductInfoModel.h"
#import "THNRefundInfoViewController.h"

static NSString *const URLRefundList      = @"/shopping/refund_list";
static NSString *const RefundNumCellId    = @"THNRefundNumberTableViewCellId";
static NSString *const RefundTimeCellId   = @"THNRefundTimeTableViewCellId";
static NSString *const RefundGoodsCellId  = @"THNGoodsInfoTableViewCellId";

@interface THNRefundListViewController ()

@end

@implementation THNRefundListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.refundTable];
    self.currentpageNum = 0;
    [self post_networkRefundListData];
}

- (void)post_networkRefundListData {
    [SVProgressHUD show];
    self.refundRequest = [FBAPI postWithUrlString:URLRefundList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@"10"} delegate:nil];
    [self.refundRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"====== %@", result);
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dict in dataArr) {
            RefundGoodsModel *model = [[RefundGoodsModel alloc] initWithDictionary:dict];
            [self.dataMarr addObject:model];
            [self.idMarr addObject:model.idField];
            [self.typeMarr addObject:[NSString stringWithFormat:@"%zi", model.type]];
            
            ProductInfoModel *goodsModel = [[ProductInfoModel alloc] initWithDictionary:[dict valueForKey:@"product"]];
            [self.goodsMarr addObject:goodsModel];
        }
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.refundTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [self.refundTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 上拉加载更多
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self post_networkRefundListData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableView
- (UITableView *)refundTable {
    if (!_refundTable) {
        _refundTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _refundTable.delegate = self;
        _refundTable.dataSource = self;
        _refundTable.showsVerticalScrollIndicator = NO;
        _refundTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _refundTable.tableFooterView = [UIView new];
        [self addMJRefresh:_refundTable];
    }
    return _refundTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 95;
    } else {
        return 44;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNRefundNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundNumCellId];
        cell = [[THNRefundNumberTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:RefundNumCellId];
        if (self.dataMarr.count) {
            [cell thn_setRefundNumberData:self.dataMarr[indexPath.section]];
        }
        return cell;
        
    } else if (indexPath.row == 1) {
        THNGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundGoodsCellId];
        cell = [[THNGoodsInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:RefundGoodsCellId];
        cell.nav = self.navigationController;
        if (self.goodsMarr.count) {
            [cell thn_setGoodsInfoData:self.goodsMarr[indexPath.section] withRid:@"" type:2];
        }
        return cell;

    } else if (indexPath.row == 2) {
        THNRefundTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundTimeCellId];
        cell = [[THNRefundTimeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:RefundTimeCellId];
        if (self.dataMarr.count) {
            [cell thn_setRefundPriceData:self.dataMarr[indexPath.section]];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        THNRefundInfoViewController *refundInfoVC = [[THNRefundInfoViewController alloc] init];
        refundInfoVC.refundId = self.idMarr[indexPath.section];
        refundInfoVC.type = [self.typeMarr[indexPath.row] integerValue];
        [self.navigationController pushViewController:refundInfoVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.baseTable = self.refundTable;
    self.navViewTitle.text = @"退款售后";
}

#pragma mark - 
- (NSMutableArray *)dataMarr {
    if (!_dataMarr) {
        _dataMarr = [NSMutableArray array];
    }
    return _dataMarr;
}

- (NSMutableArray *)goodsMarr {
    if (!_goodsMarr) {
        _goodsMarr = [NSMutableArray array];
    }
    return _goodsMarr;
}

- (NSMutableArray *)idMarr {
    if (!_idMarr) {
        _idMarr = [NSMutableArray array];
    }
    return _idMarr;
}

- (NSMutableArray *)typeMarr {
    if (!_typeMarr) {
        _typeMarr = [NSMutableArray array];
    }
    return _typeMarr;
}

@end
