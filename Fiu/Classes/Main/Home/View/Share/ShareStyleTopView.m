//
//  ShareStyleTopView.m
//  Fiu
//
//  Created by FLYang on 16/5/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShareStyleTopView.h"

@interface ShareStyleTopView () {
    NSString    *   _titleText;
}

@end

@implementation ShareStyleTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)changeWithSearchText:(NSString *)title withDes:(NSString *)des {
    _titleText = title;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 56));
    }];
    [self titleTextStyle:_titleText withBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]];
    [self changeContentLabStyle:des];
}

#pragma mark - 视图信息
- (void)setShareSceneData:(NSDictionary *)model {
    [self.sceneImg downloadImage:[model valueForKey:@"cover_url"] place:[UIImage imageNamed:@""]];
    
    [self.userHeader downloadImage:[[model valueForKey:@"user_info"] valueForKey:@"avatar_url"] place:[UIImage imageNamed:@""]];
    self.userName.text = [[model valueForKey:@"user_info"] valueForKey:@"nickname"];
    NSString * aboutText;
    if ([[[model valueForKey:@"user_info"] valueForKey:@"summary"] isKindOfClass:[NSNull class]]) {
        aboutText = @"";
    } else {
        aboutText = [[model valueForKey:@"user_info"] valueForKey:@"summary"];
    }
    self.userAbout.text = aboutText;
    CGFloat aboutW = [aboutText boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [self.userAbout mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(aboutW);
    }];
    self.address.text = [model valueForKey:@"address"];
    
    _titleText = [model valueForKey:@"title"];
    [self titleTextStyle:[model valueForKey:@"title"] withBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]];
    
    [self changeContentLabStyle:[model valueForKey:@"des"]];
    
    self.fiuSlogan.text = @"|  创新产品情景式购物平台";
}

#pragma mark - 视图UI
- (void)setViewUI {
    [self addSubview:self.sceneImg];
    
    UIImageView * bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImg.image = [UIImage imageNamed:@"Share_BgTop_750"];
    [self addSubview:bgImg];
    
    [self addSubview:self.userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 30));
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 56));
        make.top.equalTo(_userView.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    [self addSubview:self.describeView];
    [_describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 65));
        make.top.equalTo(_title.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    [self addSubview:self.qrCode];
    [_qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.top.equalTo(_describeView.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];
    if (IS_PHONE5) {
        [_qrCode mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    
    [self addSubview:self.fiuLogo];
    [_fiuLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
}

#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(_userView);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 15));
            make.top.equalTo(_userHeader.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(5);
        }];
        
        [_userView addSubview:self.userAbout];
        [_userAbout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(5);
        }];
    }
    return _userView;
}

#pragma mark - 内容
- (UIView *)describeView {
    if (!_describeView) {
        _describeView = [[UIView alloc] init];
        
        [_describeView addSubview:self.addressIcon];
        [_addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 11));
            make.top.equalTo(_describeView.mas_top).with.offset(0);
            make.left.equalTo(_describeView.mas_left).with.offset(0);
        }];
        
        [_describeView addSubview:self.address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(11);
            make.top.equalTo(_addressIcon.mas_top).with.offset(0);
            make.left.equalTo(_addressIcon.mas_right).with.offset(5);
        }];
        
        [_describeView addSubview:self.describe];
        [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addressIcon.mas_bottom).with.offset(10);
            make.left.right.equalTo(_describeView).with.offset(0);
            make.height.mas_equalTo(@12);
        }];
        
        [_describeView addSubview:self.sloganIcon];
        [_sloganIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(27, 15));
            make.top.equalTo(_describe.mas_bottom).with.offset(7);
            make.left.equalTo(_describe.mas_left).with.offset(-5);
        }];
        
        [_describeView addSubview:self.fiuSlogan];
        [_fiuSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.top.equalTo(_sloganIcon.mas_top).with.offset(0);
            make.left.equalTo(_sloganIcon.mas_right).with.offset(0);
            make.right.equalTo(_describeView.mas_right).with.offset(0);
        }];
    }
    return _describeView;
}

- (UIImageView *)sceneImg {
    if (!_sceneImg) {
        _sceneImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //  添加渐变层
//        CAGradientLayer * shadow = [CAGradientLayer layer];
//        shadow.startPoint = CGPointMake(0, 1);
//        shadow.endPoint = CGPointMake(0, 0);
//        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
//                          (__bridge id)[UIColor blackColor].CGColor];
//        shadow.locations = @[@(0.5f), @(1.5f)];
//        shadow.frame = _sceneImg.bounds;
//        [_sceneImg.layer addSublayer:shadow];
    }
    return _sceneImg;
}

- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.cornerRadius = 15;
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
        _userHeader.layer.borderWidth = 1.0f;
    }
    return _userHeader;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _userName.font = [UIFont systemFontOfSize:13];
    }
    return _userName;
}

- (UILabel *)userAbout {
    if (!_userAbout) {
        _userAbout = [[UILabel alloc] init];
        _userAbout.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _userAbout.font = [UIFont systemFontOfSize:11];
    }
    return _userAbout;
}

- (UILabel *)address {
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.font = [UIFont systemFontOfSize:10];
        _address.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    }
    return _address;
}

- (UIButton *)addressIcon {
    if (!_addressIcon) {
        _addressIcon = [[UIButton alloc] init];
        [_addressIcon setImage:[UIImage imageNamed:@"icon_map_white"] forState:(UIControlStateNormal)];
    }
    return _addressIcon;
}

#pragma mark 标题文字
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.numberOfLines = 2;
        _title.textColor = [UIColor whiteColor];
    }
    return _title;
}

- (void)titleTextStyle:(NSString *)title withBgColor:(UIColor *)color {
    if (title.length < 7) {
        _title.font = [UIFont systemFontOfSize:40];
    } else if (title.length >= 7 && title.length <= 11) {
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 35));
        }];
        _title.font = [UIFont systemFontOfSize:20];
        
    } else if (title.length > 11) {
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 56));
        }];
        _title.font = [UIFont systemFontOfSize:20];
    }
    
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary * textDict = @{
                                NSBackgroundColorAttributeName:color ,
                                NSParagraphStyleAttributeName :paragraphStyle
                                };
    [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
    self.title.attributedText = titleText;
}

- (UIButton *)describeIcon {
    if (!_describeIcon) {
        _describeIcon = [[UIButton alloc] init];
        [_describeIcon setImage:[UIImage imageNamed:@"share_other"] forState:(UIControlStateNormal)];
    }
    return _describeIcon;
}

- (UILabel *)describe {
    if (!_describe) {
        _describe = [[UILabel alloc] init];
        _describe.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        
        _describe.font = [UIFont systemFontOfSize:13];
        if (IS_PHONE5) {
            _describe.font = [UIFont systemFontOfSize:9];
        } else if (IS_PHONE6P) {
            _describe.font = [UIFont systemFontOfSize:12];
        }
        
        _describe.numberOfLines = 2;
    }
    return _describe;
}

- (void)changeContentLabStyle:(NSString *)str {
    if (str.length > 46) {
        str = [str substringToIndex:44];
        [_describeView addSubview:self.describeIcon];
        [_describeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.bottom.equalTo(_describe.mas_bottom).with.offset(0);
            make.right.equalTo(_describe.mas_right).with.offset(-1);
        }];
        
        [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
        }];
    }
    
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    NSDictionary * textDict = @{NSParagraphStyleAttributeName :paragraphStyle};
    [contentText addAttributes:textDict range:NSMakeRange(0, contentText.length)];
    self.describe.attributedText = contentText;
}

- (UIButton *)sloganIcon {
    if (!_sloganIcon) {
        _sloganIcon = [[UIButton alloc] init];
        [_sloganIcon setImage:[UIImage imageNamed:@"Share_slogan"] forState:(UIControlStateNormal)];
    }
    return _sloganIcon;
}

- (UILabel *)fiuSlogan {
    if (!_fiuSlogan) {
        _fiuSlogan = [[UILabel alloc] init];
        _fiuSlogan.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _fiuSlogan.font = [UIFont systemFontOfSize:10];
    }
    return _fiuSlogan;
}

#pragma mark - Fiu
- (UIImageView *)qrCode {
    if (!_qrCode) {
        _qrCode = [[UIImageView alloc] init];
        _qrCode.image = [UIImage imageNamed:@"Share_QR_code"];
    }
    return _qrCode;
}

- (UIButton *)fiuLogo {
    if (!_fiuLogo) {
        _fiuLogo = [[UIButton alloc] init];
        [_fiuLogo setImage:[UIImage imageNamed:@"Share_logo"] forState:(UIControlStateNormal)];
    }
    return _fiuLogo;
}

@end
