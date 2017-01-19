//
//  THNRecordHintView.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRecordHintView.h"

@implementation THNRecordHintView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    [self addSubview:self.leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 15));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.rightLable];
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (void)setTradingRecord {
    self.leftLable.text = @"佣金／时间";
    self.rightLable.text = @"状态";
}

- (void)setSettlementRecord {
    self.leftLable.text = @"时间";
    self.centerLable.text = @"数量";
    self.rightLable.text = @"佣金";
    
    [self addSubview:self.centerLable];
    [_centerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.centerY.centerX.equalTo(self);
    }];
}

- (UILabel *)leftLable {
    if (!_leftLable) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _leftLable.font = [UIFont systemFontOfSize:14];
        _leftLable.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLable;
}

- (UILabel *)centerLable {
    if (!_centerLable) {
        _centerLable = [[UILabel alloc] init];
        _centerLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _centerLable.font = [UIFont systemFontOfSize:14];
        _centerLable.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLable;
}

- (UILabel *)rightLable {
    if (!_rightLable) {
        _rightLable = [[UILabel alloc] init];
        _rightLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _rightLable.font = [UIFont systemFontOfSize:14];
        _rightLable.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLable;
}

@end
