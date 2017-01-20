//
//  THNAllianceFootView.m
//  Fiu
//
//  Created by FLYang on 2017/1/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAllianceFootView.h"
#import "THNAllianceInfoViewController.h"

@implementation THNAllianceFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setViewUI];
    }
    return self;
}


- (void)setViewUI {
//    [self addSubview:self.topLabel];
//    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH -30, 13));
//        make.left.equalTo(self.mas_left).with.offset(15);
//        make.top.equalTo(self.mas_top).with.offset(10);
//    }];
    
    [self addSubview:self.checkButton];
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _topLabel.text = @"店铺销售收入将显示在这里，已结算收入可以随时申请提现";
        
    }
    return _topLabel;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        [_checkButton setTitle:@"收入结算规则" forState:(UIControlStateNormal)];
        [_checkButton setTitleColor:[UIColor colorWithHexString:@"006FFF"] forState:(UIControlStateNormal)];
        _checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _checkButton;
}

- (void)checkButtonClick:(UIButton *)button {
    THNAllianceInfoViewController *allianceInfoVC = [[THNAllianceInfoViewController alloc] init];
    [self.nav pushViewController:allianceInfoVC animated:YES];
}

@end
