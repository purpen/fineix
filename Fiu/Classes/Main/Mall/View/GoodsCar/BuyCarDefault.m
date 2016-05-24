//
//  BuyCarDefault.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BuyCarDefault.h"

@implementation BuyCarDefault

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        
        [self addSubview:self.goHomeBtn];
        [_goHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 44));
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.promptLab];
        [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 13));
            make.bottom.equalTo(_goHomeBtn.mas_top).with.offset(-20);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.carImg];
        [_carImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72.5, 72.5));
            make.bottom.equalTo(_promptLab.mas_top).with.offset(-20);
            make.centerX.equalTo(self);
        }];
    
    }
    return self;
}

- (UIImageView *)carImg {
    if (!_carImg) {
        _carImg = [[UIImageView alloc] init];
        _carImg.image = [UIImage imageNamed:@"shopcarbig"];
        _carImg.layer.masksToBounds = YES;
        _carImg.layer.cornerRadius = 72.5 /2;
        
    }
    return _carImg;
}

- (UILabel *)promptLab {
    if (!_promptLab) {
        _promptLab = [[UILabel alloc] init];
        _promptLab.text = @"购物车又空啦，回“品”入点新货吧";
        _promptLab.textColor = [UIColor colorWithHexString:titleColor];
        _promptLab.font = [UIFont systemFontOfSize:12];
        _promptLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _promptLab;
}

- (UIButton *)goHomeBtn {
    if (!_goHomeBtn) {
        _goHomeBtn = [[UIButton alloc] init];
        _goHomeBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_goHomeBtn setTitle:@"去逛逛" forState:(UIControlStateNormal)];
        [_goHomeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _goHomeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _goHomeBtn.layer.cornerRadius = 4;
        [_goHomeBtn addTarget:self action:@selector(goHomeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _goHomeBtn;
}

//
- (void)goHomeBtnClick {
    [self.nav popViewControllerAnimated:YES];
}


@end
