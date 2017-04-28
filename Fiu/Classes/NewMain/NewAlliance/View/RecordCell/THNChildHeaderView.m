//
//  THNChildHeaderView.m
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNChildHeaderView.h"

@implementation THNChildHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self thn_setViewUI];
    }
    return self;
}

- (void)thn_setChildUserEarningsMoney:(NSString *)money {
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", money];
}

#pragma mark - 
- (void)thn_setViewUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftLabel];
    [self addSubview:self.moneyLabel];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 44)];
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _leftLabel.text = @"子账号总收益";
    }
    return _leftLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 185, 0, 150, 44)];
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        _moneyLabel.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

@end
