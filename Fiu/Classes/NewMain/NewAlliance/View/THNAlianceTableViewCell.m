//
//  THNAlianceTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAlianceTableViewCell.h"

@implementation THNAlianceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

- (void)thn_setShowAlianceWithdrawData:(NSString *)data {
    self.leftLable.text = @"可提现金额";
    self.moneyLable.text = data;
    CGFloat moneyWidth = [data boundingRectWithSize:CGSizeMake(320, 0) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width *1.3;
    [self.moneyLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(moneyWidth));
    }];
    [self setCanWithdrawUI];
}

- (void)thn_setShowRecordCellData:(NSInteger)index {
    NSArray *leftArr = @[@"交易记录", @"结算记录"];
    self.leftLable.text = leftArr[index];
    if (index == 1) {
        [self showBottomLine];
    }
}

- (void)showBottomLine {
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self addSubview:lineLab];
}

- (void)setCellUI {
    [self addSubview:self.leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 14));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (void)setCanWithdrawUI {
    [self addSubview:self.moneyLable];
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.right.equalTo(_icon.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.moneyIcon];
    [_moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 15));
        make.right.equalTo(_moneyLable.mas_left).with.offset(-5);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)leftLable {
    if (!_leftLable) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _leftLable.text = @"提现记录";
        _leftLable.font = [UIFont systemFontOfSize:14];
    }
    return _leftLable;
}

- (UILabel *)moneyLable {
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] init];
        _moneyLable.textColor = [UIColor colorWithHexString:@"#222222"];
        _moneyLable.font = [UIFont systemFontOfSize:14];
    }
    return _moneyLable;
}

- (UIImageView *)moneyIcon {
    if (!_moneyIcon) {
        _moneyIcon = [[UIImageView alloc] init];
        _moneyIcon.image = [UIImage imageNamed:@"icon_tixian"];
        _moneyIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _moneyIcon;
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
