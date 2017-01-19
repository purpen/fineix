//
//  THNRecordTableHeaderView.m
//  Fiu
//
//  Created by FLYang on 2017/1/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRecordTableHeaderView.h"

@implementation THNRecordTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setSettlementMoney:(NSString *)money {
    self.leftLable.text = @"总结算收益";
    self.rightLable.text = [NSString stringWithFormat:@"￥%@", money];
}

- (void)setCellViewUI {
    [self addSubview:self.leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 15));
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
        _leftLable.font = [UIFont systemFontOfSize:14];
    }
    return _leftLable;
}

- (UILabel *)rightLable {
    if (!_rightLable) {
        _rightLable = [[UILabel alloc] init];
        _rightLable.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _rightLable.font = [UIFont boldSystemFontOfSize:14];
        _rightLable.textAlignment = NSTextAlignmentRight;
    }
    return _rightLable;
}

@end
