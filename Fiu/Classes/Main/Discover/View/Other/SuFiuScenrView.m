//
//  SuFiuScenrView.m
//  Fiu
//
//  Created by FLYang on 16/4/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SuFiuScenrView.h"

@implementation SuFiuScenrView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.suFiuBtn];
        
        [self addSubview:self.line];
    }
    return self;
}

#pragma mark - 订阅情景按钮
- (UIButton *)suFiuBtn {
    if (!_suFiuBtn) {
        _suFiuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _suFiuBtn.backgroundColor = [UIColor whiteColor];
        [_suFiuBtn setTitle:@"＋订阅情景 " forState:(UIControlStateNormal)];
        [_suFiuBtn setTitle:@" 已订阅" forState:(UIControlStateSelected)];
        [_suFiuBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        _suFiuBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_suFiuBtn setImage:[UIImage imageNamed:@"Su_FScene"] forState:(UIControlStateNormal)];
        [_suFiuBtn setImage:[UIImage imageNamed:@"Su_FScene_Selected"] forState:(UIControlStateSelected)];
        [_suFiuBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
    }
    return _suFiuBtn;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}


@end
