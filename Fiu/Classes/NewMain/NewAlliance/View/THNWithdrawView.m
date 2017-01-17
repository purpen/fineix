//
//  THNWithdrawView.m
//  Fiu
//
//  Created by FLYang on 2017/1/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawView.h"

@interface THNWithdrawView () {
    CGFloat _maxMoney;
}

@end

@implementation THNWithdrawView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)thn_setCanWithdrawMoneyData:(CGFloat)money {
    _maxMoney = money;
    NSString *maxMoney = [NSString stringWithFormat:@"可提现金额：￥%.2f", money];
    CGFloat width = [maxMoney boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 20)
                                           options:(NSStringDrawingUsesDeviceMetrics)
                                        attributes:nil
                                           context:nil].size.width *1.2;
    [self.maxMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
    }];
    self.maxMoneyLabel.text = maxMoney;
}

- (void)setViewUI {
    [self addSubview:self.hintLabel];
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 12));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(15);
    }];
    
    [self addSubview:self.rmbLabel];
    [_rmbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 20));
        make.left.equalTo(self.mas_left).with.offset(12);
        make.top.equalTo(_hintLabel.mas_bottom).with.offset(15);
    }];
    
    [self addSubview:self.moneyTextField];
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.left.equalTo(_rmbLabel.mas_right).with.offset(5);
        make.centerY.equalTo(_rmbLabel);
    }];
    
    [self addSubview:self.errorLabel];
    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 12));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_rmbLabel.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 1));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_rmbLabel.mas_bottom).with.offset(30);
    }];
    
    [self addSubview:self.maxMoneyLabel];
    [_maxMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_lineLabel.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.allMoneyBtn];
    [_allMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 13));
        make.left.equalTo(_maxMoneyLabel.mas_right).with.offset(10);
        make.bottom.equalTo(_maxMoneyLabel.mas_bottom).with.offset(0);
    }];
}

- (UITextField *)moneyTextField {
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.font = [UIFont systemFontOfSize:18];
        _moneyTextField.textColor = [UIColor colorWithHexString:@"#222222"];
        _moneyTextField.delegate = self;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.placeholder = @"100元";
        [_moneyTextField addTarget:self action:@selector(setRefreshMoney:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _moneyTextField;
}

- (void)setRefreshMoney:(UITextField *)textField {
    [self isWithdrawalMonryLessThanMin];
    
    CGFloat nowMoney = [textField.text floatValue];
    if (nowMoney >= _maxMoney) {
        [self isWithdrawalMonryGreaterThanMax];
    }
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _hintLabel.text = @"提现金额";
    }
    return _hintLabel;
}

- (UILabel *)rmbLabel {
    if (!_rmbLabel) {
        _rmbLabel = [[UILabel alloc] init];
        _rmbLabel.font = [UIFont systemFontOfSize:18];
        _rmbLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _rmbLabel.text = @"￥";
    }
    return _rmbLabel;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    return _lineLabel;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.font = [UIFont systemFontOfSize:11];
        _errorLabel.textColor = [UIColor colorWithHexString:@"#F76260"];
        _errorLabel.text = @"* 每次提现金额不得少于100元";
    }
    return _errorLabel;
}

- (UILabel *)maxMoneyLabel {
    if (!_maxMoneyLabel) {
        _maxMoneyLabel = [[UILabel alloc] init];
        _maxMoneyLabel.font = [UIFont systemFontOfSize:14];
        _maxMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _maxMoneyLabel;
}

- (UIButton *)allMoneyBtn {
    if (!_allMoneyBtn) {
        _allMoneyBtn = [[UIButton alloc] init];
        [_allMoneyBtn setTitle:@"全部提现" forState:(UIControlStateNormal)];
        [_allMoneyBtn setTitleColor:[UIColor colorWithHexString:@"0070C9"] forState:(UIControlStateNormal)];
        _allMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_allMoneyBtn addTarget:self action:@selector(allMoneyBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _allMoneyBtn;
}

- (void)allMoneyBtnClick:(UIButton *)button {
    [self.moneyTextField resignFirstResponder];
    self.moneyTextField.text = [NSString stringWithFormat:@"%.2f", _maxMoney];
    [self isWithdrawalMonryLessThanMin];
}

#pragma mark - 小于最低提现金额
- (void)isWithdrawalMonryLessThanMin {
    self.errorLabel.text = @"* 每次提现金额不得少于100元";
    if ([self.moneyTextField.text floatValue] >= 100.00) {
        self.errorLabel.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"canWithdrawalMoney" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"canNotWithdrawalMoney" object:nil];
        self.errorLabel.hidden = NO;
    }
}

#pragma mark - 大于最高提现金额
- (void)isWithdrawalMonryGreaterThanMax {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"canNotWithdrawalMoney" object:nil];
    self.errorLabel.text = @"* 可提现金额不足";
    self.errorLabel.hidden = NO;
}

@end
