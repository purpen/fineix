//
//  THNSettlementRecordTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNSettlementRecordTableViewCell.h"

@implementation THNSettlementRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setSettlementRecordData:(THNBalanceRow *)model {
    self.timeLable.text = model.createdAt;
    self.numLable.text = [NSString stringWithFormat:@"%zi", model.balanceCount];
    self.moneyLable.text = [NSString stringWithFormat:@"￥%.2f", model.amount];
}

- (void)setCellViewUI {
    [self addSubview:self.timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 15));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.numLable];
    [_numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 15));
        make.centerY.centerX.equalTo(self);
    }];
    
    [self addSubview:self.moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.right.equalTo(self.mas_right).with.offset(-35);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _timeLable;
}

- (UILabel *)numLable {
    if (!_numLable) {
        _numLable = [[UILabel alloc] init];
        _numLable.font = [UIFont systemFontOfSize:14];
        _numLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _numLable.textAlignment = NSTextAlignmentCenter;
    }
    return _numLable;
}

- (UILabel *)moneyLable {
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] init];
        _moneyLable.font = [UIFont systemFontOfSize:14];
        _moneyLable.textColor = [UIColor colorWithHexString:@"#222222"];
        _moneyLable.textAlignment = NSTextAlignmentRight;
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
