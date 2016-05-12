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

@interface OrderInfoCell ()<ProductInfoViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIButton *operation1stBtn;
@property (weak, nonatomic) IBOutlet UIButton *operation2ndBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productViewHeight;

- (IBAction)operation1stBtnAction:(UIButton *)sender;
- (IBAction)operation2ndBtnAction:(UIButton *)sender;

@end

@implementation OrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProductViewGestureAction:)];
    [self.productView addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setOrderInfo:(OrderInfoModel *)orderInfo
{
    if (_orderInfo != orderInfo) {
        _orderInfo = orderInfo;
    }
    self.dateLbl.text = orderInfo.createdAt;
    self.stateLbl.text = orderInfo.statusLabel;
    self.totalAmountLbl.text = [NSString stringWithFormat:@"共 %ld 件商品", orderInfo.itemsCount];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%.2f", [orderInfo.totalMoney floatValue]];
    self.freightLabel.text = [NSString stringWithFormat:@"(含运费￥%.2f)",[orderInfo.freight floatValue]];
    [self.productView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (orderInfo.productInfos.count > 0) {
        self.productViewHeight.constant = 95 * orderInfo.productInfos.count;
        for (ProductInfoModel * productInfo in orderInfo.productInfos) {
            NSInteger i = [orderInfo.productInfos indexOfObject:productInfo];
            ProductInfoView * productInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ProductInfoView" owner:self options:nil] firstObject];
//            productInfoView.delegate = self;
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
            //[self.operation1stBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.operation1stBtn.hidden = YES;
            self.operation2ndBtn.hidden = YES;
        }
            break;
        case OrderInfoStateRefunding:
        {
            [self.operation1stBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            self.operation2ndBtn.hidden = true;
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
    if ([self.delegate respondsToSelector:@selector(tapProductViewWithOrderInfoCell:)]) {
        [self.delegate tapProductViewWithOrderInfoCell:self];
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
