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
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self setViewUI];
    }
    return self;
}

- (void)thn_setDefaultViewImage:(NSString *)imageName promptText:(NSString *)promptText showButton:(BOOL)isShowButton {
    self.defaultImg.image = [UIImage imageNamed:imageName];
    self.promptLab.text = promptText;
    self.defaultBtn.hidden = isShowButton;
}

- (void)setViewUI {
    [self addSubview:self.whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.7, SCREEN_WIDTH*0.7));
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY).with.offset(-(SCREEN_WIDTH/2));
    }];
    
    [self addSubview:self.defaultBtn];
    [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 44));
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.promptLab];
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 13));
        make.bottom.equalTo(_defaultBtn.mas_top).with.offset(-20);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.defaultImg];
    [_defaultImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72.5, 72.5));
        make.bottom.equalTo(_promptLab.mas_top).with.offset(-20);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView *)defaultImg {
    if (!_defaultImg) {
        _defaultImg = [[UIImageView alloc] init];
        _defaultImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _defaultImg;
}

- (UILabel *)promptLab {
    if (!_promptLab) {
        _promptLab = [[UILabel alloc] init];
        _promptLab.textColor = [UIColor colorWithHexString:titleColor];
        _promptLab.font = [UIFont systemFontOfSize:12];
        _promptLab.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLab;
}

- (UIButton *)defaultBtn {
    if (!_defaultBtn) {
        _defaultBtn = [[UIButton alloc] init];
        _defaultBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [_defaultBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _defaultBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _defaultBtn.layer.cornerRadius = 4;
    }
    return _defaultBtn;
}

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 10.0f;
        _whiteView.layer.masksToBounds = YES;
    }
    return _whiteView;
}

@end
