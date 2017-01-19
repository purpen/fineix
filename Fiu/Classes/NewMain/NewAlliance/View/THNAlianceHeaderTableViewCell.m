//
//  THNAlianceHeaderTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAlianceHeaderTableViewCell.h"

@implementation THNAlianceHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_showAllianceData:(THNAllinaceData *)model {
    if (model) {
        self.withdrawMoney.text = [NSString stringWithFormat:@"￥%.2f", model.waitCashAmount];
        self.totalMoney.text = [NSString stringWithFormat:@"￥%.2f", model.totalBalanceAmount];
        self.oldMoney.text = [NSString stringWithFormat:@"￥%.2f", model.totalCashAmount];
    }
}

- (void)setCellViewUI {
    [self addSubview:self.withdrawMoney];
    [_withdrawMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@35);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [self addSubview:self.withdrawMoneyHint];
    [_withdrawMoneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@12);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(_withdrawMoney.mas_top).with.offset(-10);
    }];
    
    [self addSubview:self.totalMoneyHint];
    [_totalMoneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH/2, 13));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [self addSubview:self.totalMoney];
    [_totalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH/2, 15));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_totalMoneyHint.mas_top).with.offset(-5);
    }];
    
    [self addSubview:self.oldMoneyHint];
    [_oldMoneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH/2, 13));
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [self addSubview:self.oldMoney];
    [_oldMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH/2, 15));
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(_oldMoneyHint.mas_top).with.offset(-5);
    }];
    
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(_withdrawMoney.mas_top).with.offset(5);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_totalMoney.mas_top).with.offset(-10);
    }];
    
    UILabel *verLine = [[UILabel alloc] init];
    verLine.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    [self addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 30));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
}

- (UILabel *)withdrawMoneyHint {
    if (!_withdrawMoneyHint) {
        _withdrawMoneyHint = [[UILabel alloc] init];
        _withdrawMoneyHint.font = [UIFont systemFontOfSize:11];
        _withdrawMoneyHint.textColor = [UIColor colorWithHexString:@"#888888"];
        _withdrawMoneyHint.textAlignment = NSTextAlignmentCenter;
        _withdrawMoneyHint.text = @"可提现金额";
    }
    return _withdrawMoneyHint;
}

- (UILabel *)withdrawMoney {
    if (!_withdrawMoney) {
        _withdrawMoney = [[UILabel alloc] init];
        _withdrawMoney.font = [UIFont systemFontOfSize:34];
        _withdrawMoney.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _withdrawMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _withdrawMoney;
}


- (UILabel *)totalMoney {
    if (!_totalMoney) {
        _totalMoney = [[UILabel alloc] init];
        _totalMoney.textColor = [UIColor colorWithHexString:@"#222222"];
        _totalMoney.font = [UIFont systemFontOfSize:14];
        _totalMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _totalMoney;
}

- (UILabel *)totalMoneyHint {
    if (!_totalMoneyHint) {
        _totalMoneyHint = [[UILabel alloc] init];
        _totalMoneyHint.textColor = [UIColor colorWithHexString:@"#888888"];
        _totalMoneyHint.font = [UIFont systemFontOfSize:12];
        _totalMoneyHint.textAlignment = NSTextAlignmentCenter;
        _totalMoneyHint.text = @"我的收益";
    }
    return _totalMoneyHint;
}

- (UILabel *)oldMoney {
    if (!_oldMoney) {
        _oldMoney = [[UILabel alloc] init];
        _oldMoney.textColor = [UIColor colorWithHexString:@"#222222"];
        _oldMoney.font = [UIFont systemFontOfSize:14];
        _oldMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _oldMoney;
}

- (UILabel *)oldMoneyHint {
    if (!_oldMoneyHint) {
        _oldMoneyHint = [[UILabel alloc] init];
        _oldMoneyHint.textColor = [UIColor colorWithHexString:@"#888888"];
        _oldMoneyHint.font = [UIFont systemFontOfSize:12];
        _oldMoneyHint.textAlignment = NSTextAlignmentCenter;
        _oldMoneyHint.text = @"已提现金额";
    }
    return _oldMoneyHint;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"thn_icon_back"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}



@end
