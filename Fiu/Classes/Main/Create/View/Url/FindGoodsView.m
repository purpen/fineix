//
//  FindGoodsView.m
//  Fiu
//
//  Created by FLYang on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FindGoodsView.h"

@implementation FindGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        [self setViewUI];
    }
    return self;
}

#pragma mark -
- (void)setFindGoodsViewData:(FindGoodsModelRow *)model {
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.title;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.salePrice];
}

- (void)setJDGoodsViewData:(FindGoodsModelRow *)model {
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.title;
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.salePrice];
}

#pragma mark -
- (void)setViewUI {
    [self addSubview:self.findView];
    [_findView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.9));
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self.findView addSubview:self.sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 48));
        make.bottom.equalTo(self.findView.mas_bottom).with.offset(-20);
        make.left.equalTo(self.findView.mas_left).with.offset(15);
    }];
    
    [self.findView addSubview:self.goodsPrice];
    [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, 48));
        make.bottom.equalTo(self.sureBtn.mas_top).with.offset(-20);
        make.left.equalTo(self.findView.mas_left).with.offset(40);
    }];
    
    [self.findView addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, 48));
        make.bottom.equalTo(self.goodsPrice.mas_top).with.offset(-10);
        make.left.equalTo(self.findView.mas_left).with.offset(40);
    }];
    
    [self.findView addSubview:self.goodsImg];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.equalTo(self.goodsTitle.mas_top).with.offset(-15);
        make.centerX.equalTo(self.findView);
    }];
}

#pragma mark -
- (UIView *)findView {
    if (!_findView) {
        _findView = [[UIView alloc] init];
        _findView.backgroundColor = [UIColor colorWithHexString:@"#FAFBFD"];
    }
    return _findView;
}

#pragma mark - 确认找到
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.layer.borderWidth = 1;
        _sureBtn.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        _sureBtn.backgroundColor = [UIColor whiteColor];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        [_sureBtn setTitle:@"确认添加" forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _sureBtn;
}

#pragma mark - 商品价格
- (UITextField *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UITextField alloc] init];
        _goodsPrice.borderStyle = UITextBorderStyleRoundedRect;
        _goodsPrice.font = [UIFont systemFontOfSize:14];
        _goodsPrice.textColor = [UIColor colorWithHexString:titleColor];
    }
    return _goodsPrice;
}

#pragma mark - 商品标题
- (UITextField *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UITextField alloc] init];
        _goodsTitle.borderStyle = UITextBorderStyleRoundedRect;
        _goodsTitle.font = [UIFont systemFontOfSize:14];
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
