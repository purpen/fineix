//
//  THNOrderOperationView.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNOrderOperationView.h"

static NSString *const Delete       = @"删除订单";
static NSString *const GoPay        = @"立即支付";
static NSString *const Cancel       = @"取消订单";
static NSString *const Refund       = @"申请退款";
static NSString *const Remind       = @"提醒发货";
static NSString *const Sure         = @"确认收货";
static NSString *const Comment      = @"发表评价";

@interface THNOrderOperationView () {
    THNOrderState _orderState;
}

@end

@implementation THNOrderOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_viewUI];
    }
    return self;
}

- (void)set_orderStateForOperationButton:(THNOrderState)state {
    _orderState = state;
    switch (state) {
        case OrderCancel:
            [self set_mainButtonTitle:Delete subButtonTitle:nil];
            break;
            
        case OrderWaitPay:
            [self set_mainButtonTitle:GoPay subButtonTitle:Cancel];
            break;
            
        case OrderWaitDeliver:
            [self set_mainButtonTitle:Remind subButtonTitle:nil];
            break;
            
        case OrderWaitTakeDelivery:
            [self set_mainButtonTitle:Sure subButtonTitle:nil];
            break;
            
        case OrderWaitComment:
            [self set_mainButtonTitle:Comment subButtonTitle:nil];
            break;
        
        default:
            break;
    }
}

- (void)set_mainButtonTitle:(NSString *)title subButtonTitle:(NSString *)subTitle {
    //  主功能按钮
    if (title.length > 0) {
        self.mainBtn.hidden = NO;
        [self.mainBtn setTitle:title forState:(UIControlStateNormal)];
    }
    
    if (subTitle.length > 0) {
        self.subBtn.hidden = NO;
        [self.subBtn setTitle:subTitle forState:(UIControlStateNormal)];
    }
}

- (void)set_viewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self addSubview:line];
    
    [self addSubview:self.mainBtn];
    [_mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 25));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.subBtn];
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 25));
        make.right.equalTo(_mainBtn.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
}

- (UIButton *)mainBtn {
    if (!_mainBtn) {
        _mainBtn = [[UIButton alloc] init];
        _mainBtn.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
        _mainBtn.layer.borderWidth = 0.5f;
        _mainBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_mainBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:(UIControlStateNormal)];
        _mainBtn.hidden = YES;
        [_mainBtn addTarget:self action:@selector(mainBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _mainBtn;
}

- (void)mainBtnClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_mainButtonSelected:)]) {
        [self.delegate thn_mainButtonSelected:_orderState];
    }
}

- (UIButton *)subBtn {
    if (!_subBtn) {
        _subBtn = [[UIButton alloc] init];
        _subBtn.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
        _subBtn.layer.borderWidth = 0.5f;
        _subBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_subBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:(UIControlStateNormal)];
        [_subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _subBtn.hidden = YES;
    }
    return _subBtn;
}

- (void)subBtnClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_subButtonSelected:)]) {
        [self.delegate thn_subButtonSelected:_orderState];
    }
}

@end
