//
//  THNPaymentTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNPaymentTableViewCell.h"

@implementation THNPaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setOrderPaymentData:(OrderInfoModel *)model {
    self.freight.text = [NSString stringWithFormat:@"￥%.2f", [model.freight floatValue]];
    self.payWay.text = model.paymentMethod;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", [model.totalMoney floatValue]];
    self.payPrice.text = [NSString stringWithFormat:@"￥%.2f", [model.payMoney floatValue]];
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self set_cellLeftViewUI];
    
    [self addSubview:self.freight];
    [_freight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 35));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.payWay];
    [_payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 35));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(_freight.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.goodsPrice];
    [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 35));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(_payWay.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.payPrice];
    [_payPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 35));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(_goodsPrice.mas_bottom).with.offset(0);
    }];
}

- (UILabel *)payWay {
    if (!_payWay) {
        _payWay = [[UILabel alloc] init];
        _payWay.textColor = [UIColor colorWithHexString:@"#666666"];
        _payWay.font = [UIFont systemFontOfSize:14];
        _payWay.textAlignment = NSTextAlignmentRight;
    }
    return _payWay;
}

- (UILabel *)freight {
    if (!_freight) {
        _freight = [[UILabel alloc] init];
        _freight.textColor = [UIColor colorWithHexString:@"#666666"];
        _freight.font = [UIFont systemFontOfSize:14];
        _freight.textAlignment = NSTextAlignmentRight;
    }
    return _freight;
}

- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.textColor = [UIColor colorWithHexString:@"#666666"];
        _goodsPrice.font = [UIFont systemFontOfSize:14];
        _goodsPrice.textAlignment = NSTextAlignmentRight;
    }
    return _goodsPrice;
}

- (UILabel *)payPrice {
    if (!_payPrice) {
        _payPrice = [[UILabel alloc] init];
        _payPrice.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _payPrice.font = [UIFont systemFontOfSize:14];
        _payPrice.textAlignment = NSTextAlignmentRight;
    }
    return _payPrice;
}

- (void)set_cellLeftViewUI {
    NSArray *titleArr = @[@"运费：", @"支付方式：", @"商品总额：", @"实付金额："];
    for (NSUInteger idx = 0; idx < titleArr.count; ++ idx) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 35 *idx, 80, 35)];
        titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.text = titleArr[idx];
        [self addSubview:titleLab];
    }
}

@end
