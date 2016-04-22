//
//  RecommendGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "RecommendGoodsCollectionViewCell.h"

@implementation RecommendGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setCellUI];
        
    }
    return self;
}

- (void)setUI {
    self.goodsImg.image = [UIImage imageNamed:@"baa"];
    self.title.text = @"Nut 智能寻物防丢贴片 一键寻物双向防丢 家居常备 出门无忧";
    self.price.text = @"￥69.00";
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(BOUNDS_WIDTH, 13));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(BOUNDS_WIDTH, 1));
        make.bottom.equalTo(self.price.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(BOUNDS_WIDTH, 25));
        make.bottom.equalTo(self.line.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.goodsImg];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(BOUNDS_WIDTH);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.title.mas_top).with.offset(-10);
        make.centerX.equalTo(self);
    }];

}

#pragma mark - 图片
- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
    }
    return _goodsImg;
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:10];
        _title.textColor = [UIColor colorWithHexString:titleColor];
        _title.numberOfLines = 2;
    }
    return _title;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

#pragma mark - 价格
- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.textColor = [UIColor colorWithHexString:fiuRedColor];
        _price.font = [UIFont systemFontOfSize:12];
    }
    return _price;
}


@end
