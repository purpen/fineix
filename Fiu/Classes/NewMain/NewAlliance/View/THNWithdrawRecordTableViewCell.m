//
//  THNWithdrawRecordTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawRecordTableViewCell.h"
#import "NSString+TimeDate.h"

@implementation THNWithdrawRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

#pragma mark - 提现记录
- (void)thn_setWithdrawRecordData:(THNWithdrawRow *)model {
    if (model) {
        if (model.status == 5) {
            model.status = 3;
        }
        NSArray *stateArr = @[@"提现失败", @"提现申请中", @"提现审核中", @"提现成功"];
        if (model.status == 0) {
            self.stateLable.textColor = [UIColor redColor];
        }
        self.stateLable.text = stateArr[model.status];
        self.moneyLable.text = [NSString stringWithFormat:@"- ￥%.2f", model.amount];
        self.timeLable.text = [NSString getTimesTamp:model.createdOn];
    }
}

- (void)thn_showTotalMoney {
    self.stateLable.text = @"已提现的总金额";
    [self.stateLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
    
    self.moneyLable.text = @"￥390.12";
    self.moneyLable.textColor = [UIColor colorWithHexString:MAIN_COLOR];
    self.moneyLable.font = [UIFont systemFontOfSize:17];
}

#pragma mark - 交易记录
- (void)thn_setTradingRecordData:(THNTradingRow *)model {
    self.stateLable.text = [NSString stringWithFormat:@"￥%.2f", model.totalPrice];
    self.moneyLable.text = model.statusLabel;
    self.timeLable.text = model.createdAt;
    [self showNextIcon];
}

#pragma mark - 添加UI控件
- (void)setCellViewUI {
    [self addSubview:self.stateLable];
    [_stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(10);
    }];
    
    [self addSubview:self.timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 13));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [self addSubview:self.moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (void)showNextIcon {
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self.moneyLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-30);
    }];
}

- (UILabel *)stateLable {
    if (!_stateLable) {
        _stateLable = [[UILabel alloc] init];
        _stateLable.font = [UIFont boldSystemFontOfSize:14];
        _stateLable.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _stateLable;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont systemFontOfSize:12];
        _timeLable.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _timeLable;
}

- (UILabel *)moneyLable {
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] init];
        _moneyLable.font = [UIFont systemFontOfSize:14];
        _moneyLable.textAlignment = NSTextAlignmentRight;
        _moneyLable.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _moneyLable;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"icon_Next"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}

@end
