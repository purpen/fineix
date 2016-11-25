//
//  OrderInfoCell.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/23.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "OrderInfoCell.h"

#import "OrderInfoModel.h"
#import "ProductInfoModel.h"
#import "Fiu.h"
#import "ProductInfoView.h"

@interface OrderInfoCell ()<ProductInfoViewDelegate> {
    NSString *_orderId;
    NSInteger _type;    //  1:正常订单 && 2:退款订单
}

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIButton *operation1stBtn;
@property (weak, nonatomic) IBOutlet UIButton *operation2ndBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *realPay;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)operation1stBtnAction:(UIButton *)sender;
- (IBAction)operation2ndBtnAction:(UIButton *)sender;

@end

@implementation OrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.operation1stBtn.layer.cornerRadius = 2;
    self.operation1stBtn.layer.masksToBounds = YES;
    self.operation1stBtn.layer.borderWidth = 0.5;
    self.operation1stBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.operation2ndBtn.layer.cornerRadius = 2;
    self.operation2ndBtn.layer.masksToBounds = YES;
    self.operation2ndBtn.layer.borderWidth = 0.5;
    self.operation2ndBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProductViewGestureAction:)];
    [self.productView addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - 退款商品列表
- (void)thn_setRefundGoodsListData:(RefundGoodsModel *)model {
    _type = 2;
    if (model) {
        _orderId = model.rid;
        
        self.dateLbl.text = [NSString stringWithFormat:@"退款编号：%@", model.idField];
        self.stateLbl.text = model.stageLabel;
        self.realPay.text = [NSString stringWithFormat:@"退款金额：￥%.2f", model.refundPrice];
        self.totalAmountLbl.hidden = YES;
        self.freightLabel.hidden = YES;
        self.totalPriceLbl.hidden = YES;
        self.allLabel.hidden = YES;
        self.bottomView.hidden = YES;
        
        [self.productView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.productViewHeight.constant = 95;
        ProductInfoView * productInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ProductInfoView" owner:self options:nil] firstObject];
        productInfoView.userInteractionEnabled = false;//
        [self.productView addSubview:productInfoView];
        __weak __typeof(self)weakSelf = self;
        [productInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(95);
            make.top.equalTo(weakSelf.productView.mas_top).with.offset(0);
            make.left.equalTo(weakSelf.productView.mas_left).with.offset(0);
            make.right.equalTo(weakSelf.productView.mas_right).with.offset(-0);
        }];
        [productInfoView thn_setProductData:model.product];

    }
}

- (void)setOrderInfo:(OrderInfoModel *)orderInfo
{
    _type = 1;
    if (_orderInfo != orderInfo) {
        _orderInfo = orderInfo;
    }
    
    self.totalAmountLbl.hidden = NO;
    self.freightLabel.hidden = NO;
    self.totalPriceLbl.hidden = NO;
    self.allLabel.hidden = NO;
    self.bottomView.hidden = NO;
    
    _orderId = orderInfo.rid;
    self.dateLbl.text = orderInfo.createdAt;
    self.stateLbl.text = orderInfo.statusLabel;
    self.totalAmountLbl.text = [NSString stringWithFormat:@"共 %ld 件商品", orderInfo.itemsCount];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%.2f", [orderInfo.totalMoney floatValue]];
    self.freightLabel.text = [NSString stringWithFormat:@"优惠:￥%.2f", [orderInfo.totalMoney floatValue]-[orderInfo.payMoney floatValue]];
    //支付价格
    self.realPay.text = [NSString stringWithFormat:@"实付:￥%.2f", [orderInfo.payMoney floatValue]];
    [self.productView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (orderInfo.productInfos.count > 0) {
        self.productViewHeight.constant = 95 * orderInfo.productInfos.count;
        for (ProductInfoModel * productInfo in orderInfo.productInfos) {
            NSInteger i = [orderInfo.productInfos indexOfObject:productInfo];
            ProductInfoView * productInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ProductInfoView" owner:self options:nil] firstObject];
            productInfoView.userInteractionEnabled = false;//
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
    
    switch (orderInfo.status) {
        case OrderInfoStateExpired:
        case OrderInfoStateCancled:
        case OrderInfoStateRefunded:
        case OrderInfoStateCompleted:
        {
            [self.operation1stBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            self.operation1stBtn.hidden = NO;
            self.operation2ndBtn.hidden = true;
        }
            break;
        case OrderInfoStateWaitPayment:
        {
            [self.operation1stBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [self.operation2ndBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.operation1stBtn.hidden = NO;
            self.operation2ndBtn.hidden = false;
        }
            break;
        case OrderInfoStateWaitDelivery:
        {
            [self.operation1stBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = YES;
        }
            break;
        case OrderInfoStateRefunding:
        {
            [self.operation1stBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            self.operation1stBtn.hidden = NO;
            self.operation2ndBtn.hidden = true;
        }
            break;
        case OrderInfoStateWaitReceive:
        {
            [self.operation1stBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.operation1stBtn.hidden = NO;
            self.operation2ndBtn.hidden = true;
        }
            break;
        case OrderInfoStateWaitComment:
        {
            [self.operation1stBtn setTitle:@"发表评价" forState:UIControlStateNormal];
            self.operation1stBtn.hidden = NO;
            self.operation2ndBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (IBAction)operation1stBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(operation1stBtnAction:withOrderInfoCell:)]) {
        [self.delegate operation1stBtnAction:sender withOrderInfoCell:self];
    }
}

- (IBAction)operation2ndBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(operation2ndBtnAction:withOrderInfoCell:)]) {
        [self.delegate operation2ndBtnAction:sender withOrderInfoCell:self];
    }
}

- (void)tapProductViewGestureAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(tapProductViewWithOrderInfoCell:orderId:type:)]) {
        [self.delegate tapProductViewWithOrderInfoCell:self orderId:_orderId type:_type];
    }
}

#pragma mark - ProductInfoViewDelegate
//- (void)tapProductInfoView:(ProductInfoView *)productInfoView withProductInfo:(ProductInfoModel *)productInfo
//{
//    if ([self.delegate respondsToSelector:@selector(tapProductInfoView:withProductInfo:)]) {
//        [self.delegate tapProductInfoView:productInfoView withProductInfo:productInfo];
//    }
//}

@end
