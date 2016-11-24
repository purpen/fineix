//
//  THNOrderInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNOrderInfoViewController.h"
#import "FBUserAddressTableViewCell.h"
#import "THNOrderInfoTableViewCell.h"
#import "THNPaymentTableViewCell.h"
#import "THNServiceTableViewCell.h"
#import "THNGoodsInfoTableViewCell.h"
#import "THNOrderNumberTableViewCell.h"
#import "THNExpressInfoTableViewCell.h"
#import "THNHasSubOrdersTableViewCell.h"
#import "FBPayTheWayViewController.h"
#import "THNRefundViewController.h"

static NSString *const addressCellId        = @"FBUserAddressTableViewCellId";
static NSString *const hasSubOrderCellId    = @"THNHasSubOrdersTableViewCellId";
static NSString *const orderListCellId      = @"THNOrderInfoTableViewCellId";
static NSString *const paymentCellId        = @"THNPaymentTableViewCellId";
static NSString *const serviceCellId        = @"THNServiceTableViewCellId";
static NSString *const goodsCellId          = @"THNGoodsInfoTableViewCellId";
static NSString *const numberCellId         = @"THNOrderNumberTableViewCellId";
static NSString *const expressCellId        = @"THNExpressInfoTableViewCellId";

static NSString *const URLOrderInfo     = @"/shopping/detail";          //  订单详情
static NSString *const URLSureOrder     = @"/shopping/take_delivery";   //  确认收货
static NSString *const URLdeleteOrder   = @"/my/delete_order";          //  删除订单
static NSString *const URLRemind        = @"/shopping/alert_send_goods";//  提醒发货
static NSString *const URLCancel        = @"/my/cancel_order";          //  取消订单

@interface THNOrderInfoViewController () {
    BOOL            _isHasSubOrder; //  是否有子订单
    THNOrderState   _orderState;    //  订单状态
}

@end

@implementation THNOrderInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self set_viewUI];
}

#pragma mark - 设置界面视图
- (void)set_viewUI {
    [self.view addSubview:self.orderInfoTable];
    if (self.orderId) {
        [self get_networkWithOrderInfoData:self.orderId];
    }
}

#pragma mark - 进行订单的操作
- (void)post_networkOperationOrderWithState:(NSString *)networkURL {
    self.operationRequest = [FBAPI postWithUrlString:networkURL requestDictionary:@{@"rid":self.orderId} delegate:nil];
    [self.operationRequest startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - 网络请求订单详情数据
- (void)get_networkWithOrderInfoData:(NSString *)orderId {
    [SVProgressHUD show];
    self.orderRequest = [FBAPI getWithUrlString:URLOrderInfo requestDictionary:@{@"rid":orderId} delegate:nil];
    [self.orderRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"订单详情：==== %@", result);
        NSDictionary *data = [result valueForKey:@"data"];
        self.addressModel = [[DeliveryAddressModel alloc] initWithDictionary:[data valueForKey:@"express_info"]];
        self.orderModel = [[OrderInfoModel alloc] initWithDictionary:data];
        
        //  是否有子订单
        NSArray *subOrderArr = [data valueForKey:@"sub_orders"];
        if (![subOrderArr isKindOfClass:[NSNull class]] && subOrderArr.count == 0) {
            _isHasSubOrder = NO;
            //  获取订单商品列表
            NSArray *itemsArr = [data valueForKey:@"items"];
            for (NSDictionary *dict in itemsArr) {
                ProductInfoModel *model = [[ProductInfoModel alloc] initWithDictionary:dict];
                [self.orderDataMarr addObject:model];
            }
            
        } else {
            _isHasSubOrder = YES;
        }
        
        //  订单状态
        _orderState = (THNOrderState)[[data valueForKey:@"status"] integerValue];
        [self thn_showBottomView:_orderState];
        
        [self.orderInfoTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - 底部功能操作视图
- (THNOrderOperationView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[THNOrderOperationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)thn_showBottomView:(THNOrderState)state {
    [self.bottomView set_orderStateForOperationButton:state];
    [self.view addSubview:self.bottomView];
}

- (void)thn_mainButtonSelected:(THNOrderState)state {
    switch (state) {
        case OrderCancel:
            [self post_networkOperationOrderWithState:URLdeleteOrder];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case OrderWaitPay:
            [self thn_goToPay];
            break;
            
        case OrderWaitTakeDelivery:
            [self post_networkOperationOrderWithState:URLSureOrder];
            break;
            
        case OrderWaitDeliver:
            [self post_networkOperationOrderWithState:URLRemind];
            break;
            
        default:
            break;
    }
}

- (void)thn_subButtonSelected:(THNOrderState)state {
    switch (state) {
        case OrderWaitPay:
            [self.navigationController popViewControllerAnimated:YES];
            [self post_networkOperationOrderWithState:URLCancel];
            break;
            
        default:
            break;
    }
}

//  去支付
- (void)thn_goToPay {
    FBPayTheWayViewController * payWayVC = [[FBPayTheWayViewController alloc] init];
    payWayVC.orderInfo = self.orderModel;
    [self.navigationController pushViewController:payWayVC animated:YES];
}

//  去评价
- (void)thn_goToComment {

}

//  申请退款
- (void)thn_goToRefund {
//    THNRefundViewController *refundVC = [[THNRefundViewController alloc] init];
//
//    [self.navigationController pushViewController:refundVC animated:YES];
}

#pragma mark - 详情列表视图
- (UITableView *)orderInfoTable {
    if (!_orderInfoTable) {
        _orderInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -108) style:(UITableViewStyleGrouped)];
        _orderInfoTable.delegate = self;
        _orderInfoTable.dataSource = self;
        _orderInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderInfoTable.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _orderInfoTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isHasSubOrder) {
        return 4;
    } else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (_isHasSubOrder) {
            return 2;
            
        } else {
            return 2 + self.orderDataMarr.count;
        }
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
        
    } else if (indexPath.section == 1) {
        if (_isHasSubOrder) {
            return 84;
        } else {
            return 0.01;
        }
        
    } else if (indexPath.section == 2) {
        if (_isHasSubOrder) {
            return 100;
            
        } else {
            if (indexPath.row == 0) {
                return 40;
            } else if (indexPath.row == self.orderDataMarr.count +1) {
                return 40;
            } else {
                return 96;
            }
        }
        
    } else if (indexPath.section == 3) {
        return 140;
        
    } else if (indexPath.section == 4) {
        return 44;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (_isHasSubOrder) {
            return 10;
        } else {
            return 0.01;
        }
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //  收货信息
        FBUserAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellId];
        cell = [[FBUserAddressTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:addressCellId];
        [cell thn_setOrderAddressModel:self.addressModel];
        return cell;
        
    } else if (indexPath.section == 1) {
        //  有子订单时的拆单提示
        if (_isHasSubOrder) {
            THNHasSubOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hasSubOrderCellId];
            cell = [[THNHasSubOrdersTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hasSubOrderCellId];
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellId"];
            return cell;
        }
    
    } else if (indexPath.section == 2) {
        //  订单中的商品列表
        if (_isHasSubOrder) {
            //  子订单的商品列表
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subcellId"];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"subcellId"];
            return cell;
            
        } else {
            //  没有子订单时的商品列表
            if (indexPath.row == 0) {
                THNOrderNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:numberCellId];
                cell = [[THNOrderNumberTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:numberCellId];
                if (self.orderModel) {
                    [cell thn_setOrederNumberData:self.orderModel];
                }
                return cell;
                
            } else if (indexPath.row == self.orderDataMarr.count + 1) {
                THNExpressInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expressCellId];
                cell = [[THNExpressInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:expressCellId];
                if (self.orderModel) {
                    [cell thn_setOrederExpressData:self.orderModel];
                }
                return cell;
                
            } else {
                THNGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
                cell = [[THNGoodsInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsCellId];
                if (self.orderDataMarr.count) {
                    [cell thn_setGoodsInfoData:self.orderDataMarr[indexPath.row - 1]];
                }
                return cell;

            }
        }
        
    } else if (indexPath.section == 3) {
        //  支付信息
        THNPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentCellId];
        cell = [[THNPaymentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:paymentCellId];
        if (self.orderModel) {
            [cell thn_setOrderPaymentData:self.orderModel];
        }
        return cell;
        
    } else if (indexPath.section == 4) {
        //  联系客服
        THNServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceCellId];
        cell = [[THNServiceTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:serviceCellId];
        return cell;

    }
    
    return nil;
}

#pragma mark - 点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"拨打 400-879-8751" message:nil];
        alertView.layer.cornerRadius = 10;
        alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
        alertView.buttonCancleBgColor = [UIColor colorWithHexString:@"#999999"];
        TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
        TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-879-8751"]];
        }];
        [alertView addAction:cancel];
        [alertView addAction:confirm];
        [alertView showInController:self];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.baseTable = self.orderInfoTable;
    self.navViewTitle.text = @"订单详情";
}

#pragma mark - 
- (NSMutableArray *)orderDataMarr {
    if (!_orderDataMarr) {
        _orderDataMarr = [NSMutableArray array];
    }
    return _orderDataMarr;
}

@end
