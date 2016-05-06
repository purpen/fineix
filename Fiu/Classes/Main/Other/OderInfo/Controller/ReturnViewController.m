//
//  ReturnViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReturnViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "OrderInfoModel.h"
#import "OrderInfoCell.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"

@interface ReturnViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,OrderInfoCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic, strong) NSMutableArray * orderListAry;
@end
static NSString *const OrderInfoCellIdentifier = @"orderInfoCell";
static NSString *const OrderListURL = @"/shopping/orders";
@implementation ReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"退款/售后";
    
    self.myTableview.delegate = self;
    self.myTableview.dataSource = self;
    
    [self.myTableview registerNib:[UINib nibWithNibName:@"OrderInfoCell" bundle:nil] forCellReuseIdentifier:OrderInfoCellIdentifier];
    self.myTableview.estimatedRowHeight = 212.f;
    self.myTableview.rowHeight = UITableViewAutomaticDimension;
    
    [self requestDataForOderList];
    
    // 下拉刷新
    self.myTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataForOderList];
        
        // 结束刷新
        [self.myTableview.mj_header endRefreshing];
    }];
}

#pragma mark - Network
//请求订单列表信息
- (void)requestDataForOderList
{
    NSDictionary * params = @{@"page": @1, @"size": @30, @"status": @8};
    FBRequest * request = [FBAPI postWithUrlString:OrderListURL requestDictionary:params delegate:self];
    request.flag = OrderListURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - FBRequest Delegate
- (void)requestSucess:(FBRequest *)request result:(id)result
{
    NSLog(@"%@", result);
    NSString * message = result[@"message"];
    if ([request.flag isEqualToString:OrderListURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            self.orderListAry = [NSMutableArray array];
            NSDictionary * dataDic = [result objectForKey:@"data"];
            NSArray * rowsAry = [dataDic objectForKey:@"rows"];
            
            for (NSDictionary * orderInfoDic in rowsAry) {
                OrderInfoModel * orderInfo = [[OrderInfoModel alloc] initWithDictionary:orderInfoDic];
                [self.orderListAry addObject:orderInfo];
            }
            [self.myTableview reloadData];
            
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    request = nil;
}

- (void)requestFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)userCanceledFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListAry.count ? self.orderListAry.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoCell * orderInfoCell = [tableView dequeueReusableCellWithIdentifier:OrderInfoCellIdentifier forIndexPath:indexPath];
    if (![orderInfoCell.delegate isEqual:self]) {
        orderInfoCell.delegate = self;
    }
    if (self.orderListAry.count) {
        orderInfoCell.orderInfo = self.orderListAry[indexPath.row];
    }
    return orderInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - OrderInfoCellDelegate
- (void)tapProductViewWithOrderInfoCell:(OrderInfoCell *)orderInfoCell
{
//    OrderInfoDetailViewController * orderInfoDetailVC = [[OrderInfoDetailViewController alloc] initWithNibName:@"OrderInfoDetailViewController" bundle:nil];
//    orderInfoDetailVC.orderInfoCell = orderInfoCell;
//    orderInfoDetailVC.delegate = self;
//    [self.navigationController pushViewController:orderInfoDetailVC animated:YES];
}

- (void)operation1stBtnAction:(UIButton *)button withOrderInfoCell:(OrderInfoCell *)orderInfoCell
{
    switch (orderInfoCell.orderInfo.status) {
        case OrderInfoStateRefunding:
        {
//            OrderInfoDetailViewController * orderInfoDetailVC = [[OrderInfoDetailViewController alloc] initWithNibName:@"OrderInfoDetailViewController" bundle:nil];
//            orderInfoDetailVC.orderInfoCell = orderInfoCell;
//            orderInfoDetailVC.delegate = self;
//            [self.navigationController pushViewController:orderInfoDetailVC animated:YES];
        }
            break;
        case OrderInfoStateRefunded:
        {
            [self deleteOrderWithCell:orderInfoCell];
        }
            break;
        default:
            break;
    }
}

//请求删除订单
- (void)deleteOrderWithCell:(OrderInfoCell *)cell
{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认删除订单？" message:nil];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/my/delete_order" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [self operationActionWithCell:cell];
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}


#pragma mark - OrderInfoDetailVCDelegate
- (void)operationActionWithCell:(OrderInfoCell *)cell
{
    NSIndexPath * indexPath = [self.myTableview indexPathForCell:cell];
    [self.orderListAry removeObjectAtIndex:indexPath.row];
    [self.myTableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
