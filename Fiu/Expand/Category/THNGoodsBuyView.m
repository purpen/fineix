//
//  THNGoodsBuyView.m
//  Fiu
//
//  Created by FLYang on 16/9/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNGoodsBuyView.h"

static const NSInteger GoodsBuyViewBtnTag = 833;

@implementation THNGoodsBuyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)isCollectTheGoods:(NSInteger)collect {
    switch (collect) {
        case 0:
            self.collect.selected = NO;
            break;
        
        case 1:
            self.collect.selected = YES;
            break;
            
        default:
            break;
    }
}

- (void)changeCollectBtnState:(BOOL)selected {
    self.collect.selected = selected;
}

- (void)setViewUI {
    [self addSubview:self.collect];
    [_collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3/2, 44));
        make.left.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.share];
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3/2, 44));
        make.left.equalTo(_collect.mas_right).with.offset(0);
        make.centerY.equalTo(_collect);
    }];
    
    [self addSubview:self.nowBuy];
    [_nowBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 44));
        make.right.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.addCar];
    [_addCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 44));
        make.right.equalTo(_nowBuy.mas_left).with.offset(0);
        make.centerY.equalTo(_nowBuy);
    }];
    
    [self addSubview:self.topLine];
}

- (UILabel *)topLine {
    if (!_topLine) {
        _topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, 1)];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    }
    return _topLine;
}

- (UIButton *)collect {
    if (!_collect) {
        _collect = [[UIButton alloc] init];
        _collect.backgroundColor = [UIColor whiteColor];
        _collect.titleLabel.font = [UIFont systemFontOfSize:10];
        [_collect setTitle:NSLocalizedString(@"likeTheGoods", nil) forState:(UIControlStateNormal)];
        [_collect setTitle:NSLocalizedString(@"likeTheGoods", nil) forState:(UIControlStateSelected)];
        [_collect setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [_collect setImage:[UIImage imageNamed:@"goods_star"] forState:(UIControlStateNormal)];
        [_collect setImage:[UIImage imageNamed:@"goods_star_seleted"] forState:(UIControlStateSelected)];
        if (IS_PHONE5) {
            [_collect setTitleEdgeInsets:(UIEdgeInsetsMake(30, -17, 0, 0))];
        } else {
            [_collect setTitleEdgeInsets:(UIEdgeInsetsMake(30, -29, 0, 0))];
        }
        [_collect setImageEdgeInsets:(UIEdgeInsetsMake(-10, 13.5, 0, 0))];
        _collect.tag = GoodsBuyViewBtnTag;
        [_collect addTarget:self action:@selector(goodsBuyViewBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collect;
}

- (UIButton *)share {
    if (!_share) {
        _share = [[UIButton alloc] init];
        _share.backgroundColor = [UIColor whiteColor];
        _share.titleLabel.font = [UIFont systemFontOfSize:10];
        [_share setTitle:NSLocalizedString(@"ShareBtn", nil) forState:(UIControlStateNormal)];
        [_share setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        [_share setImage:[UIImage imageNamed:@"goods_share"] forState:(UIControlStateNormal)];
        [_share setTitleEdgeInsets:(UIEdgeInsetsMake(30, -29, 0, 0))];
        [_share setImageEdgeInsets:(UIEdgeInsetsMake(-10, 13.5, 0, 0))];
        _share.tag = GoodsBuyViewBtnTag +1;
        [_share addTarget:self action:@selector(goodsBuyViewBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _share;
}

- (UIButton *)addCar {
    if (!_addCar) {
        _addCar = [[UIButton alloc] init];
        [_addCar setTitle:NSLocalizedString(@"addGoodsCar", nil) forState:(UIControlStateNormal)];
        [_addCar setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addCar.titleLabel.font = [UIFont systemFontOfSize:14];
        _addCar.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        _addCar.tag = GoodsBuyViewBtnTag +2;
        [_addCar addTarget:self action:@selector(goodsBuyViewBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addCar;
}

- (UIButton *)nowBuy {
    if (!_nowBuy) {
        _nowBuy = [[UIButton alloc] init];
        [_nowBuy setTitle:NSLocalizedString(@"buyingGoods", nil) forState:(UIControlStateNormal)];
        [_nowBuy setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nowBuy.titleLabel.font = [UIFont systemFontOfSize:14];
        _nowBuy.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _nowBuy.tag = GoodsBuyViewBtnTag +3;
        [_nowBuy addTarget:self action:@selector(goodsBuyViewBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nowBuy;
}

- (void)goodsBuyViewBtnClick:(UIButton *)button {
    NSInteger index = button.tag - GoodsBuyViewBtnTag;
    if ([_delegate respondsToSelector:@selector(selectedGoodsBuyViewBtnIndex:selectedState:)]) {
        [_delegate selectedGoodsBuyViewBtnIndex:index selectedState:button.selected];
    }
}

@end
