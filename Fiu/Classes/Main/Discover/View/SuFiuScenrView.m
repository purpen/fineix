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
        [_suFiuBtn setTitle:@"＋订阅此情景 " forState:(UIControlStateNormal)];
        [_suFiuBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        _suFiuBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_suFiuBtn setImage:[UIImage imageNamed:@"Su_FScene"] forState:(UIControlStateNormal)];
        [_suFiuBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        [_suFiuBtn addTarget:self action:@selector(suFiuBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
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

//  订阅情景
- (void)suFiuBtnClick {
    NSLog(@"－－－－－＝＝＝＝＝＝－－－－订阅此情景");
}

@end
