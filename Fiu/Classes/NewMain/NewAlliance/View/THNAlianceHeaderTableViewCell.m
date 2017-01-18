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
        self.moneyLable.text = [NSString stringWithFormat:@"%.2f", model.totalBalanceAmount];
//        self.oldMoneyLable.text = [NSString stringWithFormat:@"＋%.2f", ]
    }
}

- (void)setCellViewUI {
    [self addSubview:self.moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@40);
        make.left.right.equalTo(self).with.offset(0);
//        make.centerY.equalTo(self.mas_centerY).with.offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.hintLable];
    [_hintLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@12);
        make.left.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(_moneyLable.mas_top).with.offset(-10);
    }];
    
//    [self addSubview:self.oldHintLable];
//    [_oldHintLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@12);
//        make.left.right.equalTo(self).with.offset(0);
//        make.top.equalTo(_moneyLable.mas_bottom).with.offset(10);
//    }];
//    
//    [self addSubview:self.oldMoneyLable];
//    [_oldMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@12);
//        make.left.right.equalTo(self).with.offset(0);
//        make.top.equalTo(_oldHintLable.mas_bottom).with.offset(10);
//    }];
    
}

- (UILabel *)hintLable {
    if (!_hintLable) {
        _hintLable = [[UILabel alloc] init];
        _hintLable.font = [UIFont systemFontOfSize:11];
        _hintLable.textColor = [UIColor colorWithHexString:@"#888888"];
        _hintLable.textAlignment = NSTextAlignmentCenter;
        _hintLable.text = @"我的分成（元）";
    }
    return _hintLable;
}

- (UILabel *)moneyLable {
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] init];
        _moneyLable.font = [UIFont systemFontOfSize:34];
        _moneyLable.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _moneyLable.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLable;
}

- (UILabel *)oldHintLable {
    if (!_oldHintLable) {
        _oldHintLable = [[UILabel alloc] init];
        _oldHintLable.font = [UIFont systemFontOfSize:11];
        _oldHintLable.textColor = [UIColor colorWithHexString:@"#888888"];
        _oldHintLable.textAlignment = NSTextAlignmentCenter;
        _oldHintLable.text = @"昨日收益（元）";
    }
    return _oldHintLable;
}

- (UILabel *)oldMoneyLable {
    if (!_oldMoneyLable) {
        _oldMoneyLable = [[UILabel alloc] init];
        _oldMoneyLable.font = [UIFont systemFontOfSize:11];
        _oldMoneyLable.textColor = [UIColor colorWithHexString:@"#222222"];
        _oldMoneyLable.textAlignment = NSTextAlignmentCenter;
    }
    return _oldMoneyLable;
}

@end
