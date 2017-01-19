//
//  THNRecordStateTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/1/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRecordStateTableViewCell.h"

@implementation THNRecordStateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

#pragma mark - 交易明细
- (void)thn_setTradingRecordInfoDataTop:(THNTradingInfoData *)model {
    if (model) {
        self.leftLable.text = model.createdAt;
        self.rightLable.text = model.statusLabel;
    }
}

- (void)thn_setTradingRecordInfoDataBottom:(THNTradingInfoData *)model {
    self.leftLable.text = @"分成收益";
    self.rightLable.font = [UIFont boldSystemFontOfSize:14];
    self.rightLable.textColor = [UIColor colorWithHexString:MAIN_COLOR];
    self.rightLable.text = [NSString stringWithFormat:@"￥%.2f", model.totalPrice];
}

#pragma mark - 结算明细
- (void)thn_setSettlementRecordInfoData:(THNSettlementInfoRow *)model {
    self.leftLable.text = [NSString stringWithFormat:@"%@", model.createdAt];
    self.rightLable.text = @"";
}

- (void)thn_setSettlementRecordInfoDataBottom:(THNSettlementInfoRow *)model {
    self.leftLable.text = @"已结算收益";
    self.rightLable.font = [UIFont boldSystemFontOfSize:14];
    self.rightLable.textColor = [UIColor colorWithHexString:MAIN_COLOR];
    self.rightLable.text = [NSString stringWithFormat:@"￥%.2f", model.amount];
}

- (void)setCellViewUI {
    [self addSubview:self.leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 13));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.rightLable];
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)leftLable {
    if (!_leftLable) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _leftLable.font = [UIFont systemFontOfSize:12];
    }
    return _leftLable;
}

- (UILabel *)rightLable {
    if (!_rightLable) {
        _rightLable = [[UILabel alloc] init];
        _rightLable.textColor = [UIColor colorWithHexString:@"#222222"];
        _rightLable.font = [UIFont systemFontOfSize:12];
        _rightLable.textAlignment = NSTextAlignmentRight;
    }
    return _rightLable;
}

@end
