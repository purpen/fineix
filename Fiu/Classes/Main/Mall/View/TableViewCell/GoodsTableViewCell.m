
//
//  GoodsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        self.goodsImgMarr = [NSMutableArray array];
    }
    return self;
}

- (void)setGoodsData:(GoodsRow *)model {
    self.title.text = model.title;

    // 产品来源: 1.官网；2.淘宝；3.天猫；4.京东
    if (model.attrbute == 1) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_thn"];
    } else if (model.attrbute == 2) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_taobao"];
    } else if (model.attrbute == 3) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_tmall"];
    } else if (model.attrbute == 4) {
        self.typeImg.image = [UIImage imageNamed:@"Goods_JD"];
    }
    
    self.price.text = [NSString stringWithFormat:@"¥%.2f", model.marketPrice];
    
    if (model.banner.count > 0) {
        for (NSInteger idx = 0; idx < model.banner.count; ++ idx) {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 265, 150)];
            [image downloadImage:model.banner[idx] place:[UIImage imageNamed:@""]];
            [self.goodsImgMarr addObject:image];
        }
        
    } else {
        for (NSInteger idx = 0; idx < model.bannerAsset.count; ++ idx) {
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 265, 150)];
            [image downloadImage:model.bannerAsset[idx] place:[UIImage imageNamed:@""]];
            [self.goodsImgMarr addObject:image];
        }
    }
    
    [self setCellViewUI];
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.goodsImgRoll];
    [_goodsImgRoll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 150));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.titleBg];
    [_titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.654, 25));
        make.top.equalTo(self.goodsImgRoll.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(5);
    }];
    
    [self addSubview:self.typeImg];
    [_typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 14));
        make.centerY.equalTo(self.titleBg);
        make.left.equalTo(self.titleBg.mas_right).with.offset(0);
    }];
    
    [self addSubview:self.priceBg];
    [_priceBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH * 0.654) - 46, 25));
        make.bottom.equalTo(self.titleBg.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-5);
    }];
}

#pragma mark - 滚动
- (UIScrollView *)goodsImgRoll {
    if (!_goodsImgRoll) {
        _goodsImgRoll = [[UIScrollView alloc] init];
        _goodsImgRoll.showsHorizontalScrollIndicator = NO;
        _goodsImgRoll.delegate = self;
        [self setRollImgViewUI:self.goodsImgMarr];
    }
    return _goodsImgRoll;
}

- (void)setRollImgViewUI:(NSArray *)imgArr {
    CGFloat space = 0;
    CGFloat width = 0;
    CGFloat viewWidth = 0;
    
    for (UIView * view in imgArr) {
        NSInteger index = [imgArr indexOfObject:view];
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
        if (index % 2 != 0) {
            UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(-11, 0, 4, 150)];
            line.image = [UIImage imageNamed:@"Goods_image_bg"];
            [view addSubview:line];
        }
        space = SCREEN_WIDTH * 0.186;
        width = viewWidth + space/4;
        view.frame = CGRectMake(space / 2 + (view.frame.size.width + space / 4) * index, 0, viewWidth, view.frame.size.height);
        CGFloat y = index * width;
        CGFloat value = (0 - y) / width;
        CGFloat scale = fabs(cos(fabs(value) * M_PI/5));
        view.transform = CGAffineTransformMakeScale(1.0, scale);

        [self.goodsImgRoll addSubview:view];
    }
    self.goodsImgRoll.contentSize = CGSizeMake((space / 2 + width * imgArr.count) + space/4, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (offset < 0) {
        return;
    }
    CGFloat space = 0;
    CGFloat viewWidth = 0;
    for (UIView * view in self.goodsImgRoll.subviews) {
        NSInteger index = [self.goodsImgRoll.subviews indexOfObject:view];
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
        space = SCREEN_WIDTH * 0.186;
        CGFloat width = viewWidth + space/4;
        CGFloat y = index * width;
        CGFloat value = (offset - y)/width;
        CGFloat scale = fabs(cos(fabs(value) * M_PI/5));
        view.transform = CGAffineTransformMakeScale(1.0, scale);
    }
    CGFloat a = offset / (viewWidth + space/4);
    if (a - (int)a > 0.5) {
        _currentIndex = (int)a + 1;
    } else {
        _currentIndex = (int)a;
    }
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 225, 25)];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:Font_GoodsTitle];
    }
    return _title;
}

#pragma mark - 标题背景
- (UIImageView *)titleBg {
    if (!_titleBg) {
        _titleBg = [[UIImageView alloc] init];
        _titleBg.image = [UIImage imageNamed:@"Goods_title_bg"];
        
        [_titleBg addSubview:self.title];
        
    }
    return _titleBg;
}

#pragma mark - 来源
- (UIImageView *)typeImg {
    if (!_typeImg) {
        _typeImg = [[UIImageView alloc] init];
    }
    return _typeImg;
}

#pragma mark - 价格
- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - (SCREEN_WIDTH * 0.654) - 56, 25)];
        _price.textColor = [UIColor whiteColor];
        _price.font = [UIFont systemFontOfSize:Font_GoodsTitle];
        _price.textAlignment = NSTextAlignmentCenter;
    }
    return _price;
}

#pragma mark - 价格背景
- (UIImageView *)priceBg {
    if (!_priceBg) {
        _priceBg = [[UIImageView alloc] init];
        _priceBg.image = [UIImage imageNamed:@"Goods_price_bg"];
        
        [_priceBg addSubview:self.price];
    }
    return _priceBg;
}

@end
