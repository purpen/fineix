//
//  NoSubscribeView.m
//  Fiu
//
//  Created by FLYang on 16/7/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NoSubscribeView.h"
#import "AllSceneViewController.h"

@implementation NoSubscribeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
        
    }
    return self;
}

- (void)setViewUI {
    [self addSubview:self.goSubscribeBtn];
    [_goSubscribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 44));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.noSubscribeLab];
    [_noSubscribeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 13));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_goSubscribeBtn.mas_top).with.offset(-20);
    }];
}

- (UILabel *)noSubscribeLab {
    if (!_noSubscribeLab) {
        _noSubscribeLab = [[UILabel alloc] init];
        _noSubscribeLab.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _noSubscribeLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _noSubscribeLab.font = [UIFont systemFontOfSize:13];
        }
        _noSubscribeLab.textAlignment = NSTextAlignmentCenter;
        _noSubscribeLab.text = NSLocalizedString(@"NoSubscribe", nil);
    }
    return _noSubscribeLab;
}

- (UIButton *)goSubscribeBtn {
    if (!_goSubscribeBtn) {
        _goSubscribeBtn = [[UIButton alloc] init];
        if (IS_iOS9) {
            _goSubscribeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _goSubscribeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        _goSubscribeBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_goSubscribeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_goSubscribeBtn setTitle:NSLocalizedString(@"suFiuBtn", nil) forState:(UIControlStateNormal)];
        _goSubscribeBtn.layer.cornerRadius = 3;
        
        [_goSubscribeBtn addTarget:self action:@selector(goSubscribeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _goSubscribeBtn;
}

- (void)goSubscribeBtnClick {
    AllSceneViewController * allsceneVC = [[AllSceneViewController alloc] init];
    [self.nav pushViewController:allsceneVC animated:YES];
}

@end
