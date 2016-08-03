//
//  ShareStyleTitleBottomView.m
//  Fiu
//
//  Created by FLYang on 16/5/24.
//  Copyright © 1516年 taihuoniao. All rights reserved.
//

#import "ShareStyleTitleBottomView.h"
#import "HomeSceneListRow.h"
#import "UILable+Frame.h"

static CGFloat const desFont = 9.0f;
static CGFloat const addressFont = 9.0f;
static CGFloat const slognFont = 8.0f;
static CGFloat const userNameFont = 10.0f;
static CGFloat const userAboutFont = 9.0f;
static CGFloat const userStarFont = 9.0f;

@interface ShareStyleTitleBottomView () {
    NSString    *   _titleText;
}

@end

@implementation ShareStyleTitleBottomView

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
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.7, 56));
    }];
    [self titleTextStyle:_titleText withBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]];
    [self changeContentLabStyle:des];
}

#pragma mark - 视图信息
- (void)setShareSceneData:(NSDictionary *)model {
    HomeSceneListRow * sceneModel = [[HomeSceneListRow alloc] initWithDictionary:model];
    [self.sceneImg downloadImage:sceneModel.coverUrl place:[UIImage imageNamed:@""]];
    [self.userHeader downloadImage:sceneModel.user.avatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = sceneModel.user.nickname;
    
    if (sceneModel.user.isExpert == 1) {
        self.userVimg.hidden = NO;
        self.userStar.text = sceneModel.user.expertLabel;
        self.userAbout.text = [NSString stringWithFormat:@"|  %@", sceneModel.user.expertInfo];
        CGSize size = [self.userStar boundingRectWithSize:CGSizeMake(100, 0)];
        CGFloat starSize = [sceneModel.user.expertLabel boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width);
        }];
        [self.userAbout mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(starSize * 1.6);
            make.left.equalTo(_userStar.mas_right).with.offset(5);
        }];
        
    } else {
        CGFloat aboutSize = [sceneModel.user.summary boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        self.userVimg.hidden = YES;
        self.userStar.text = @"";
        self.userAbout.text = sceneModel.user.summary;
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.userAbout mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(aboutSize * 0.8);
            make.left.equalTo(_userStar.mas_right).with.offset(0);
        }];
    }
    
    self.address.text = sceneModel.address;
    _titleText = sceneModel.title;
    [self titleTextStyle:sceneModel.title withBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]];
    [self changeContentLabStyle:sceneModel.des];
    self.fiuSlogan.text = NSLocalizedString(@"slognText", nil);
}

#pragma mark - 视图UI
- (void)setViewUI {
    
    [self addSubview:self.qrCode];
    [_qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];

    [self addSubview:self.fiuLogo];
    [_fiuLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    [self addSubview:self.describeView];
    [_describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.7, 50));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 30));
        make.bottom.equalTo(_describeView.mas_top).with.offset(-5);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.7, 56));
        make.bottom.equalTo(_userView.mas_top).with.offset(-3);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.sceneImg];
    [_sceneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.title.mas_centerY).with.offset(0);
    }];

    [self bringSubviewToFront:self.title];
    [self bringSubviewToFront:self.fiuLogo];
}

#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.centerY.equalTo(_userView);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.userVimg];
        [_userVimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(-9);
        }];
        
        [_userView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 13));
            make.top.equalTo(_userHeader.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(6);
        }];
        
        [_userView addSubview:self.userStar];
        [_userStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 10));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(6);
        }];
        
        [_userView addSubview:self.userAbout];
        [_userAbout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 10));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userStar.mas_right).with.offset(5);
        }];
        
        [_userView addSubview:self.addressIcon];
        [_addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 11));
            make.centerY.equalTo(_userAbout);
            make.left.equalTo(_userAbout.mas_right).with.offset(5);
        }];
        
        [_userView addSubview:self.address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(11);
            make.top.equalTo(_addressIcon.mas_top).with.offset(0);
            make.left.equalTo(_addressIcon.mas_right).with.offset(5);
            make.right.equalTo(_userView.mas_right).with.offset(0);
        }];
    }
    return _userView;
}

#pragma mark - 内容
- (UIView *)describeView {
    if (!_describeView) {
        _describeView = [[UIView alloc] init];
        
        [_describeView addSubview:self.sloganIcon];
        [_sloganIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(27, 15));
            make.bottom.equalTo(_describeView.mas_bottom).with.offset(0);
            make.left.equalTo(_describeView.mas_left).with.offset(-5);
        }];
        
        [_describeView addSubview:self.fiuSlogan];
        [_fiuSlogan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.top.equalTo(_sloganIcon.mas_top).with.offset(0);
            make.left.equalTo(_sloganIcon.mas_right).with.offset(0);
            make.right.equalTo(_describeView.mas_right).with.offset(0);
        }];
        
        [_describeView addSubview:self.describe];
        [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_fiuSlogan.mas_top).with.offset(-5);
            make.left.right.equalTo(_describeView).with.offset(0);
            make.height.mas_equalTo(@12);
        }];
    }
    return _describeView;
}

#pragma mark - 加V标志
- (UIImageView *)userVimg {
    if (!_userVimg) {
        _userVimg = [[UIImageView alloc] init];
        _userVimg.image = [UIImage imageNamed:@"talent"];
        _userVimg.contentMode = UIViewContentModeScaleToFill;
        _userVimg.hidden = YES;
    }
    return _userVimg;
}

#pragma mark - 认证标签
- (UILabel *)userStar {
    if (!_userStar) {
        _userStar = [[UILabel alloc] init];
        _userStar.font = [UIFont systemFontOfSize:userStarFont];
        _userStar.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
    }
    return _userStar;
}

- (UIImageView *)sceneImg {
    if (!_sceneImg) {
        _sceneImg = [[UIImageView alloc] init];
        _sceneImg.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImg.clipsToBounds = YES;
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
        _userName.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        _userName.font = [UIFont systemFontOfSize:userNameFont];
    }
    return _userName;
}

- (UILabel *)userAbout {
    if (!_userAbout) {
        _userAbout = [[UILabel alloc] init];
        _userAbout.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _userAbout.font = [UIFont systemFontOfSize:userAboutFont];
    }
    return _userAbout;
}

- (UILabel *)address {
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.font = [UIFont systemFontOfSize:addressFont];
        _address.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
    }
    return _address;
}

- (UIButton *)addressIcon {
    if (!_addressIcon) {
        _addressIcon = [[UIButton alloc] init];
        [_addressIcon setImage:[UIImage imageNamed:@"map_gray"] forState:(UIControlStateNormal)];
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
    if (title.length < 8) {
        _title.font = [UIFont systemFontOfSize:36];
    } else if (title.length >= 8 && [title length] < 12) {
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 30));
        }];
        _title.font = [UIFont systemFontOfSize:23];
    } else if ([title length] == 12){
        if (IS_PHONE6P) {
            [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 30));
            }];
        } else {
            [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 56));
            }];
        }
        _title.font = [UIFont systemFontOfSize:23];
    } else if ([title length] > 12){
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.68, 56));
        }];
        _title.font = [UIFont systemFontOfSize:23];
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
        _describe.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        _describe.font = [UIFont systemFontOfSize:desFont];
        _describe.numberOfLines = 2;
    }
    return _describe;
}

- (void)changeContentLabStyle:(NSString *)str {
    if (IS_PHONE6P) {
        if (str.length > 61) {
            str = [str substringToIndex:61];
            [_describeView addSubview:self.describeIcon];
            [_describeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(9, 9));
                make.bottom.equalTo(_describe.mas_bottom).with.offset(-1);
                make.right.equalTo(_describe.mas_right).with.offset(0);
            }];
            
            [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(26);
            }];
            
        } else if (str.length > 30) {
            [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(26);
            }];
        }
        
    } else {
        if (str.length > 56) {
            str = [str substringToIndex:56];
            [_describeView addSubview:self.describeIcon];
            [_describeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(9, 9));
                make.bottom.equalTo(_describe.mas_bottom).with.offset(-1);
                make.right.equalTo(_describe.mas_right).with.offset(0);
            }];
            
            [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(26);
            }];
            
        } else if (str.length > 28) {
            [self.describe mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(26);
            }];
        }
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
        [_sloganIcon setImage:[UIImage imageNamed:@"Share_slogan_black"] forState:(UIControlStateNormal)];
    }
    return _sloganIcon;
}

- (UILabel *)fiuSlogan {
    if (!_fiuSlogan) {
        _fiuSlogan = [[UILabel alloc] init];
        _fiuSlogan.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _fiuSlogan.font = [UIFont systemFontOfSize:slognFont];
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
