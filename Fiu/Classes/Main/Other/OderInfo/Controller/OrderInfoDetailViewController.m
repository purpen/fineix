//
//  OrderInfoDetailViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "OrderInfoDetailViewController.h"
#import "OrderInfoModel.h"
#import "OrderInfoCell.h"
#import "SVProgressHUD.h"
#import "ExpressInfoModel.h"
#import "ProductInfoView.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"
#import "CommenttwoViewController.h"
#import "RefundmentViewController.h"
#import "FBPayTheWayViewController.h"
#import "GoodsInfoViewController.h"

@interface OrderInfoDetailViewController ()<ProductInfoViewDelegate,FBNavigationBarItemsDelegate>

@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLbl;
@property (weak, nonatomic) IBOutlet UILabel *freightLbl;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLbl;
@property (weak, nonatomic) IBOutlet UIButton *operation1stBtn;
@property (weak, nonatomic) IBOutlet UIButton *operation2ndBtn;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (nonatomic, copy) NSArray * productInfoAry;
@property (nonatomic, strong) ExpressInfoModel * expressInfo;
@end
static NSString *const OrderDetailURL = @"/shopping/detail";
@implementation OrderInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"订单详情";
    // Do any additional setup after loading the view from its nib.
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){190 / 255, 137 / 255, 20 / 255, 1});
    self.operation1stBtn.layer.cornerRadius = 2;
    self.operation1stBtn.layer.masksToBounds = YES;
    self.operation1stBtn.layer.borderWidth = 0.5;
    self.operation1stBtn.layer.borderColor = color;
    self.operation2ndBtn.layer.cornerRadius = 2;
    self.operation2ndBtn.layer.masksToBounds = YES;
    self.operation2ndBtn.layer.borderWidth = 0.5;
    self.operation2ndBtn.layer.borderColor = color;
    
    if (self.orderInfo == nil) {
        self.orderInfo = self.orderInfoCell.orderInfo;
    }
    
    [self requestDataForOderDetail];
}

#pragma mark - Network
//请求订单详情
- (void)requestDataForOderDetail
{
    NSDictionary * params = @{@"rid": self.orderInfo.rid};
    FBRequest * request = [FBAPI postWithUrlString:OrderDetailURL requestDictionary:params delegate:self];
    request.flag = OrderDetailURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - FBRequest Delegate
- (void)requestSucess:(FBRequest *)request result:(id)result
{
    NSLog(@"%@", result);
    NSString * message = result[@"message"];
    if ([request.flag isEqualToString:OrderDetailURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            NSDictionary * dataDic = [result objectForKey:@"data"];
            self.orderInfo = [[OrderInfoModel alloc] initWithDictionary:dataDic];
            self.productInfoAry = self.orderInfo.productInfos;
            self.expressInfo = self.orderInfo.expressInfo;
            [self configureUI];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    request = nil;
}


- (void)configureUI
{
    self.operationView.hidden = false;
    switch (self.orderInfo.status) {
        case OrderInfoStateExpired:
        case OrderInfoStateCancled:
        case OrderInfoStateRefunded:
        case OrderInfoStateCompleted:
        {
            [self.operation1stBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = true;
        }
            break;
        case OrderInfoStateWaitPayment:
        {
            [self.operation1stBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [self.operation2ndBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = false;
        }
            break;
        case OrderInfoStateWaitDelivery:
        {
            [self.operation1stBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = true;
        }
            break;
        case OrderInfoStateRefunding:
        {
            self.operationView.hidden = true;
        }
            break;
        case OrderInfoStateWaitReceive:
        {
            [self.operation1stBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = true;
        }
            break;
        case OrderInfoStateWaitComment:
        {
            [self.operation1stBtn setTitle:@"发表评价" forState:UIControlStateNormal];
            [self.operation2ndBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = false;
        }
            break;
        default:
            break;
    }
    
    self.nameLbl.text = [NSString stringWithFormat:@"收货人：%@", self.expressInfo.name];
    self.areaLbl.text = [NSString stringWithFormat:@"%@ %@", self.expressInfo.province, self.expressInfo.city];
    self.addressLbl.text = self.expressInfo.address;
    self.phoneLbl.text = self.expressInfo.phone;
    
    self.orderCodeLbl.text = self.orderInfo.rid;
    self.paymentMethodLbl.text = @"在线支付";
    self.totalMoneyLbl.text = [NSString stringWithFormat:@"￥%.2f", [self.orderInfo.totalMoney floatValue]];
    self.freightLbl.text = [NSString stringWithFormat:@"￥%.2f", [self.orderInfo.freight floatValue]];
    self.payMoneyLbl.text = [NSString stringWithFormat:@"￥%.2f", [self.orderInfo.payMoney floatValue]];
    
    [self.productView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.orderInfo.productInfos.count > 0) {
        self.productViewHeight.constant = 95 * self.orderInfo.productInfos.count;
        for (ProductInfoModel * productInfo in self.orderInfo.productInfos) {
            NSInteger i = [self.orderInfo.productInfos indexOfObject:productInfo];
            ProductInfoView * productInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ProductInfoView" owner:self options:nil] firstObject];
            productInfoView.delegate = self;
            [self.productView addSubview:productInfoView];
            __weak __typeof(self)weakSelf = self;
            [productInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(95);
                make.top.equalTo(weakSelf.productView.mas_top).with.offset(95 * i);
                make.left.equalTo(weakSelf.productView.mas_left).with.offset(0);
                make.right.equalTo(weakSelf.productView.mas_right).with.offset(-0);
            }];
            productInfoView.productInfo = productInfo;
        }
    }
}

-(void)leftBarItemSelected{
    if (self.isFromPayment) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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


- (IBAction)operation1stBtnAction:(UIButton *)sender {
    switch (self.orderInfo.status) {
        case OrderInfoStateExpired:
        case OrderInfoStateCancled:
        case OrderInfoStateRefunded:
        case OrderInfoStateCompleted:
        {
            [self deleteOrderWithCell:self.orderInfoCell];
        }
            break;
        case OrderInfoStateWaitPayment://立即支付
        {
            FBPayTheWayViewController * payWayVC = [[FBPayTheWayViewController alloc] init];
            payWayVC.orderInfo = self.orderInfo;
            [self.navigationController pushViewController:payWayVC animated:YES];
        }
            break;
        case OrderInfoStateWaitDelivery://申请退款
        {
            RefundmentViewController * refundmentVC = [[RefundmentViewController alloc] initWithNibName:@"RefundmentViewController" bundle:nil];
            refundmentVC.orderInfoCell = self.orderInfoCell;
            refundmentVC.orderInfo = self.orderInfo;
            refundmentVC.isFromOrderDetail = true;
            [self.navigationController pushViewController:refundmentVC animated:YES];
        }
            break;
        case OrderInfoStateWaitReceive://确认收货
        {
            [self confirmReceiptWithCell:self.orderInfoCell];
        }
            break;
        case OrderInfoStateWaitComment://去评价
        {
            CommenttwoViewController * commentVC = [[CommenttwoViewController alloc] initWithNibName:@"CommenttwoViewController" bundle:nil];
            commentVC.orderInfoCell = self.orderInfoCell;
            commentVC.delegate = self;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//请求确认收货
- (void)confirmReceiptWithCell:(OrderInfoCell *)cell
{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认收货？" message:nil];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/shopping/take_delivery" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([self.delegate1 respondsToSelector:@selector(operationActionWithCell:)]) {
                [self.delegate1 operationActionWithCell:cell];
            }
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
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
            if ([self.delegate1 respondsToSelector:@selector(operationActionWithCell:)]) {
                [self.delegate1 operationActionWithCell:cell];
            }
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}


- (IBAction)operation2ndBtnAction:(UIButton *)sender {
    switch (self.orderInfo.status) {
        case OrderInfoStateWaitPayment:
        {
            [self cancleOrderWithCell:self.orderInfoCell];
        }
            break;
        case OrderInfoStateWaitComment:
        {
            [self deleteOrderWithCell:self.orderInfoCell];
        }
            break;
        default:
            break;
    }
}

//请求取消订单
- (void)cancleOrderWithCell:(OrderInfoCell *)cell
{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认取消订单？" message:nil];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/my/cancel_order" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([self.delegate1 respondsToSelector:@selector(operationActionWithCell:)]) {
                [self.delegate1 operationActionWithCell:cell];
            }
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"取消订单成功"];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}


- (IBAction)serviceBtnAction:(UIButton *)sender {
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"拨打 400-879-8751" message:nil];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-879-8751"]];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}

#pragma mark - ProductInfoViewDelegate
- (void)tapProductInfoView:(ProductInfoView *)productInfoView withProductInfo:(ProductInfoModel *)productInfo
{
    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = self.orderInfo.idField;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
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
