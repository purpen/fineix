//
//  ChangeAddUrlView.m
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChangeAddUrlView.h"

@implementation ChangeAddUrlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        
        [self addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 419));
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

#pragma mark -
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"FAFBFD"];
    
        [_bgView addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
            make.top.equalTo(_bgView.mas_top).with.offset(0);
            make.left.equalTo(_bgView.mas_left ).with.offset(0);
        }];
        
        [_bgView addSubview:self.cancel];
        [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 44));
            make.bottom.equalTo(_bgView.mas_bottom).with.offset(0);
            make.left.equalTo(_bgView.mas_left).with.offset(0);
        }];
        
        [_bgView addSubview:self.sure];
        [_sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 44));
            make.bottom.equalTo(_bgView.mas_bottom).with.offset(0);
            make.left.equalTo(_cancel.mas_right).with.offset(0);
        }];
        
//        [_bgView addSubview:self.url];
//        [_url mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 90) / 2, 44));
//            make.bottom.equalTo(_cancel.mas_top).with.offset(-20);
//            make.left.equalTo(_bgView.mas_left).with.offset(40);
//        }];
        
        [_bgView addSubview:self.dele];
        [_dele mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 90) / 2, 44));
            make.bottom.equalTo(_cancel.mas_top).with.offset(-20);
            make.right.equalTo(_bgView.mas_right).with.offset(-40);
        }];
        
        [_bgView addSubview:self.goodsPrice];
        [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, 48));
            make.bottom.equalTo(_dele.mas_top).with.offset(-10);
            make.left.equalTo(_bgView.mas_left).with.offset(40);
        }];

        [_bgView addSubview:self.goodsTitle];
        [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, 48));
            make.bottom.equalTo(_goodsPrice.mas_top).with.offset(-10);
            make.left.equalTo(_bgView.mas_left).with.offset(40);
        }];

        [_bgView addSubview:self.goodsImg];
        [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.bottom.equalTo(self.goodsTitle.mas_top).with.offset(-15);
            make.centerX.equalTo(_bgView);
        }];
        
    }
    return _bgView;
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor whiteColor];
        _title.text = NSLocalizedString(@"editUserGoods", nil);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _title.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _title;
}

#pragma mark - 取消
- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [[UIButton alloc] init];
        _cancel.backgroundColor = [UIColor whiteColor];
        [_cancel setTitle:NSLocalizedString(@"cancel", nil) forState:(UIControlStateNormal)];
        [_cancel setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _cancel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [_cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancel;
}

//
- (void)cancelBtnClick {
    [self removeFromSuperview];
}

#pragma mark - 确定
- (UIButton *)sure {
    if (!_sure) {
        _sure = [[UIButton alloc] init];
        _sure.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_sure setTitle:NSLocalizedString(@"determine", nil) forState:(UIControlStateNormal)];
        [_sure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sure.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
    return _sure;
}

#pragma mark - 修改链接
- (UIButton *)url {
    if (!_url) {
        _url = [[UIButton alloc] init];
        _url.backgroundColor = [UIColor whiteColor];
        [_url setTitle:NSLocalizedString(@"changeUrl", nil) forState:(UIControlStateNormal)];
        [_url setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        _url.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _url.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        _url.layer.borderWidth = 1;
        _url.layer.cornerRadius = 3;
    }
    return _url;
}

#pragma mark - 删除商品
- (UIButton *)dele {
    if (!_dele) {
        _dele = [[UIButton alloc] init];
        _dele.backgroundColor = [UIColor whiteColor];
        [_dele setTitle:NSLocalizedString(@"deleteUserGoods", nil) forState:(UIControlStateNormal)];
        [_dele setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        _dele.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _dele.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        _dele.layer.borderWidth = 1;
        _dele.layer.cornerRadius = 3;
    }
    return _dele;
}

#pragma mark - 商品价格
- (UITextField *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UITextField alloc] init];
        _goodsPrice.borderStyle = UITextBorderStyleRoundedRect;
        _goodsPrice.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _goodsPrice.textColor = [UIColor colorWithHexString:titleColor];
        _goodsPrice.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _goodsPrice;
}

#pragma mark - 商品标题
- (UITextField *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UITextField alloc] init];
        _goodsTitle.borderStyle = UITextBorderStyleRoundedRect;
        _goodsTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _goodsTitle.textColor = [UIColor colorWithHexString:titleColor];
    }
    return _goodsTitle;
}

#pragma mark - 商品图片
- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        _goodsImg.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _goodsImg;
}

@end
