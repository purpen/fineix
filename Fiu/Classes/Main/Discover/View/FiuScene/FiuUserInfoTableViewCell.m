//
//  FIiuUserInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuUserInfoTableViewCell.h"
#import "HomePageViewController.h"
#import "UIButton+WebCache.h"

@implementation FiuUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setCellUI];
        
    }
    return self;
}

- (void)setFiuSceneInfoData:(FiuSceneInfoData *)model {
    self.userId = [NSString stringWithFormat:@"%zi", model.userInfo.userId];
    [self.bgImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self.userHeader sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatarUrl] forState:(UIControlStateNormal)];
    self.userName.text = model.userInfo.nickname;

    //  是否是达人
    if (model.userInfo.isExpert == 1) {
        self.userVimg.hidden = NO;
        self.userStar.text = model.userInfo.expertLabel;
        self.userProfile.text = [NSString stringWithFormat:@"|  %@", model.userInfo.expertInfo];
        CGSize size = [self.userStar boundingRectWithSize:CGSizeMake(100, 0)];
        
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width);
        }];
        [self.userProfile mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userStar.mas_right).with.offset(5);
        }];
        
    } else if (model.userInfo.isExpert == 0) {
        self.userProfile.text = model.userInfo.summary;
    }
    
    UIColor * fsceneColor = [UIColor blackColor];
    [self titleTextStyle:[NSString stringWithFormat:@"%@", model.title] withBgColor:fsceneColor];
    
    CGFloat cityLength = [model.address boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    self.city.text = model.address;
    [self.city mas_updateConstraints:^(MASConstraintMaker *make) {
        if (cityLength > 280) {
            make.size.mas_equalTo(CGSizeMake(220, 15));
        } else {
            make.size.mas_equalTo(CGSizeMake(cityLength * 1.01, 15));
        }
        make.left.equalTo(self.mas_left).with.offset(40);
    }];
    
    self.time.text = [NSString stringWithFormat:@"|  %@", model.createdAt];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.city.mas_right).with.offset(10);
        make.bottom.equalTo(self.city.mas_bottom).with.offset(0);
        make.top.equalTo(self.city.mas_top).with.offset(0);
    }];
    
    //  订阅的数量
    if (model.subscriptionCount/1000 > 1) {
        self.goodNum.text = [NSString stringWithFormat:@"%zik人订阅", model.subscriptionCount/1000 ];
    } else {
        self.goodNum.text = [NSString stringWithFormat:@"%zi人订阅", model.subscriptionCount];
    }
    
    //  是否订阅
    if (model.isSubscript == 0) {
        self.goodBtn.selected = NO;
    } else if (model.isSubscript == 1) {
        self.goodBtn.selected = YES;
    }
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.bgImage];
    
    [self addSubview:self.userView];
}

#pragma mark - 场景图
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        _bgImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Defaul_Bg_750"]];
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        shadow.locations = @[@(0.5f), @(1.5f)];
        shadow.frame = _bgImage.bounds;
        [_bgImage.layer addSublayer:shadow];
    }
    return _bgImage;
}


#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 170)];
        
        [_userView addSubview:self.userLeftView];
        [_userLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 135.5 ,35));
            make.bottom.equalTo(_userView.mas_bottom).with.offset(-10);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.userRightView];
        [_userRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(46 ,35));
            make.centerY.equalTo(_userLeftView);
            make.right.equalTo(_userView.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(_userLeftView);
            make.left.equalTo(_userLeftView.mas_left).with.offset(20);
        }];
        
        [_userView addSubview:self.userVimg];
        [_userVimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(-9);
        }];
        
        [_userView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.top.equalTo(_userHeader.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(6);
        }];
        
        [_userView addSubview:self.userStar];
        [_userStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 14));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(self.userName.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(170, 14));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(self.userStar.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.goodBtn];
        [_goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(89.5 ,46));
            make.bottom.equalTo(_userLeftView.mas_bottom).with.offset(0);
            make.left.equalTo(_userLeftView.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.city];
        [_city mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 15));
            make.bottom.equalTo(_userLeftView.mas_top).with.offset(-15);
            make.left.equalTo(_userView.mas_left).with.offset(40);
        }];
        
        [_userView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGSizeMake(150, 15));
            make.left.equalTo(_city.mas_right).with.offset(0);
            make.right.equalTo(_userView.mas_right).with.offset(-20);
        }];
        
        [_userView addSubview:self.titleText];
        [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
            make.bottom.equalTo(_time.mas_top).with.offset(-8);
            make.left.equalTo(_userView.mas_left).with.offset(20);
        }];
    }
    return _userView;
}

#pragma mark - 用户信息左边背景
- (UIView *)userLeftView {
    if (!_userLeftView) {
        _userLeftView = [[UIView alloc] init];
        _userLeftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_bg_left"]];
    }
    return _userLeftView;
}

#pragma mark - 订阅的按钮
- (UIButton *)goodBtn {
    if (!_goodBtn) {
        _goodBtn = [[UIButton alloc] init];
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"icon_su"] forState:(UIControlStateNormal)];
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"icon_su_selected"] forState:(UIControlStateSelected)];
        
        [_goodBtn addSubview:self.goodNum];
        [_goodNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(89 ,13));
            make.bottom.equalTo(_goodBtn.mas_bottom).with.offset(-10);
            make.centerX.equalTo(_goodBtn);
        }];
    }
    return _goodBtn;
}

#pragma mark - 订阅的数量
- (UILabel *)goodNum {
    if (!_goodNum) {
        _goodNum = [[UILabel alloc] init];
        _goodNum.textColor = [UIColor whiteColor];
        _goodNum.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _goodNum.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _goodNum.font = [UIFont systemFontOfSize:12];
        }
    }
    return _goodNum;
}

#pragma mark - 用户信息左边背景
- (UIView *)userRightView {
    if (!_userRightView) {
        _userRightView = [[UIView alloc] init];
        _userRightView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"User_bg_right"]];
    }
    return _userRightView;
}

#pragma mark - 用户头像
- (UIButton *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIButton alloc] init];
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.cornerRadius = 15;
        [_userHeader addTarget:self action:@selector(lookUserHome) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _userHeader;
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
        if (IS_iOS9) {
            _userStar.font = [UIFont fontWithName:@"PingFangSC-Light" size:9];
        } else {
            _userStar.font = [UIFont systemFontOfSize:9];
        }
        _userStar.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
    }
    return _userStar;
}

- (void)lookUserHome {
    HomePageViewController * peopleHomeVC = [[HomePageViewController alloc] init];
    peopleHomeVC.isMySelf = NO;
    peopleHomeVC.type = @2;
    peopleHomeVC.userId = self.userId;
    [self.nav pushViewController:peopleHomeVC animated:YES];
}

#pragma mark - 用户昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        if (IS_iOS9) {
            _userName.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_UserName];
        } else {
            _userName.font = [UIFont systemFontOfSize:Font_UserName];
        }
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        if (IS_iOS9) {
            _userProfile.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_UserProfile];
        } else {
            _userProfile.font = [UIFont systemFontOfSize:Font_UserProfile];
        }
    }
    return _userProfile;
}

#pragma mark - 标题文字
- (UILabel *)titleText {
    if (!_titleText) {
        _titleText = [[UILabel alloc] init];
        _titleText.numberOfLines = 2;
        _titleText.textColor = [UIColor whiteColor];
    }
    return _titleText;
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title withBgColor:(UIColor *)color {
    if ([title length] < 8) {
        _titleText.font = [UIFont systemFontOfSize:40];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
        }];
    } else if ([title length] >= 8 && [title length] < 12) {
        _titleText.font = [UIFont systemFontOfSize:30];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 36));
        }];
    } else if ([title length] >= 12) {
        _titleText.font = [UIFont systemFontOfSize:22];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 56));
        }];
    }
    
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary * textDict = @{
                                NSBackgroundColorAttributeName:color ,
                                NSParagraphStyleAttributeName :paragraphStyle
                                };
    [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
    self.titleText.attributedText = titleText;
}

#pragma mark - 城市
- (UILabel *)city {
    if (!_city) {
        _city = [[UILabel alloc] init];
        [self addIcon:_city withImage:@"icon_city"];
        if (IS_iOS9) {
            _city.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _city.font = [UIFont systemFontOfSize:12];
        }
        _city.textColor = [UIColor whiteColor];
    }
    return _city;
}

#pragma mark - 时间
- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor blackColor];
        if (IS_iOS9) {
            _time.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _time.font = [UIFont systemFontOfSize:12];
        }
        _time.textColor = [UIColor whiteColor];
    }
    return _time;
}

#pragma mark - 添加icon
- (void)addIcon:(UILabel *)lable withImage:(NSString *)iconImage {
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(-20, 0, 15, 15)];
    icon.contentMode = UIViewContentModeCenter;
    icon.image = [UIImage imageNamed:iconImage];
    [lable addSubview:icon];
}


@end
