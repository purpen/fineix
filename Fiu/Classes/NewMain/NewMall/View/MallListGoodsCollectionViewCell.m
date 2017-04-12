//
//  MallListGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallListGoodsCollectionViewCell.h"

@implementation MallListGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)thn_setHomeGoodsData:(THNMallGoodsModelItem *)model {
    [self.goodsImageView downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    self.price.text = [NSString stringWithFormat:@"¥%.0f", model.salePrice];
}

- (void)setMallSubjectGoodsListData:(THNMallSubjectModelProduct *)model {
    [self.goodsImageView downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    self.price.text = [NSString stringWithFormat:@"¥%zi", model.salePrice];
}

- (void)setGoodsListData:(GoodsRow *)model {
    [self.goodsImageView downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    self.price.text = [NSString stringWithFormat:@"¥%.0f", model.salePrice];
}

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.goodsImageView];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.bounds.size.width));
        make.bottom.left.equalTo(self).with.offset(0);
        make.top.equalTo(_goodsImageView.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(self.bounds.size.width - 6));
        make.left.equalTo(_blackView.mas_left).with.offset(3);
        make.top.equalTo(_blackView.mas_top).with.offset(0);
        make.bottom.equalTo(_blackView.mas_centerY).with.offset(0);
    }];
    
    [self addSubview:self.price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(self.bounds.size.width - 6));
        make.top.equalTo(_title.mas_bottom).with.offset(0);
        make.bottom.equalTo(_blackView.mas_bottom).with.offset(0);
        make.left.equalTo(_blackView.mas_left).with.offset(3);
    }];
}

#pragma mark - init
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.backgroundColor = [UIColor whiteColor];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:10];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [_title sizeToFit];
    }
    return _title;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:10];
        _price.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _price.textAlignment = NSTextAlignmentCenter;
        [_price sizeToFit];
    }
    return _price;
}

@end
