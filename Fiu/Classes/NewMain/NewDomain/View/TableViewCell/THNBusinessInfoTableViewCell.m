//
//  THNBusinessInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNBusinessInfoTableViewCell.h"

@implementation THNBusinessInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setBusinessInfoData:(NSString *)left right:(NSString *)right {
    self.leftLabel.text = left;
    self.rightLabel.text = right;
}

- (void)setCellViewUI {
    [self addSubview:self.line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 0.5));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 10));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@10);
        make.left.equalTo(_leftLabel.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    }
    return _line;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _rightLabel;
}

@end
