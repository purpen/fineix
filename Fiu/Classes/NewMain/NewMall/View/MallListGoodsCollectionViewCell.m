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

- (void)setGoodsListData:(GoodsRow *)model {
    [self.image downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    self.price.text = [NSString stringWithFormat:@"¥%.0f", model.salePrice];
}

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.bounds.size.width));
        make.bottom.left.equalTo(self).with.offset(0);
        make.top.equalTo(_image.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 6, 15));
        make.top.left.equalTo(_blackView).with.offset(3);
        make.centerX.equalTo(_blackView);
    }];
    
    [self addSubview:self.price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, 15));
        make.bottom.left.equalTo(_blackView).with.offset(-3);
        make.centerX.equalTo(_blackView);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor whiteColor];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
    }
    return _image;
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
    }
    return _title;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:10];
        _price.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _price.textAlignment = NSTextAlignmentCenter;
    }
    return _price;
}

@end
