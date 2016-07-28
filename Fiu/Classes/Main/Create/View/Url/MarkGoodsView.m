//
//  MarkGoodsView.m
//  Fiu
//
//  Created by FLYang on 16/7/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MarkGoodsView.h"

@implementation MarkGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        [self setViewUI];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)closeView:(UIGestureRecognizer *)tap {
    [self removeFromSuperview];
}

#pragma mark -
- (void)setViewUI {
    [self addSubview:self.goodsBtn];
    [_goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 90));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX).with.offset(-5);
    }];
    
    [self addSubview:self.urlBtn];
    [_urlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 90));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_centerX).with.offset(5);
    }];
}

- (UIButton *)goodsBtn {
    if (!_goodsBtn) {
        _goodsBtn = [[UIButton alloc] init];
        [_goodsBtn setImage:[UIImage imageNamed:@"icon_markGoods"] forState:(UIControlStateNormal)];
        [_goodsBtn setTitle:NSLocalizedString(@"marker", nil) forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _goodsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [_goodsBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_goodsBtn setImageEdgeInsets:(UIEdgeInsetsMake(-20, 7, 0, 0))];
        [_goodsBtn setTitleEdgeInsets:(UIEdgeInsetsMake(70, -55, 0, 0))];
    }
    return _goodsBtn;
}

- (UIButton *)urlBtn {
    if (!_urlBtn) {
        _urlBtn = [[UIButton alloc] init];
        [_urlBtn setImage:[UIImage imageNamed:@"icon_markUrl"] forState:(UIControlStateNormal)];
        [_urlBtn setTitle:NSLocalizedString(@"addUrl", nil) forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _urlBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _urlBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [_urlBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_urlBtn setImageEdgeInsets:(UIEdgeInsetsMake(-20, 7, 0, 0))];
        [_urlBtn setTitleEdgeInsets:(UIEdgeInsetsMake(70, -55, 0, 0))];
    }
    return _urlBtn;
}

@end
