//
//  NewGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NewGoodsCollectionViewCell.h"

@implementation NewGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)setGoodsData:(GoodsRow *)model {
    [self.image downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.name.text = model.title;
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
        make.left.bottom.equalTo(self).with.offset(0);
        make.top.equalTo(_image.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.brandImage];
    [_brandImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.left.equalTo(self.mas_left).with.offset(8);
        make.centerY.equalTo(_blackView);
    }];
    
    [self addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.left.equalTo(_brandImage.mas_right).with.offset(5);
        make.centerY.equalTo(_blackView);
        make.right.equalTo(self.mas_right).with.offset(-40);
    }];
    
    [self addSubview:self.price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.left.equalTo(_name.mas_right).with.offset(3);
        make.centerY.equalTo(_blackView);
        make.right.equalTo(self.mas_right).with.offset(-4);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
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

- (UIImageView *)brandImage {
    if (!_brandImage) {
        _brandImage = [[UIImageView alloc] init];
        _brandImage.backgroundColor = [UIColor whiteColor];
        _brandImage.layer.cornerRadius = 21/2;
        _brandImage.layer.masksToBounds = YES;
    }
    return _brandImage;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:10];
        _name.textColor = [UIColor whiteColor];
    }
    return _name;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:10];
        _price.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _price.textAlignment = NSTextAlignmentRight;
    }
    return _price;
}

@end
