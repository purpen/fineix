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

- (void)setRecommendGoodsData:(GoodsInfoData *)model {
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    self.price.text = [NSString stringWithFormat:@"￥%.2f", model.salePrice];
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
        make.size.mas_equalTo(CGSizeMake(BOUNDS_WIDTH, 30));
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
        _goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImg.clipsToBounds = YES;
        _goodsImg.layer.borderWidth = 1.0f;
        _goodsImg.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1" alpha:1].CGColor;
        _goodsImg.backgroundColor = [UIColor whiteColor];
    }
    return _goodsImg;
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        if (IS_iOS9) {
            _title.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _title.font = [UIFont systemFontOfSize:10];
        }
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
        _price.textColor = [UIColor colorWithHexString:fineixColor];
        if (IS_iOS9) {
            _price.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _price.font = [UIFont systemFontOfSize:12];
        }
    }
    return _price;
}


@end
