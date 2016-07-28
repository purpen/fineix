//
//  DownSceneInfoView.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DownSceneInfoView.h"

@implementation DownSceneInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImage];
        
        [self addSubview:self.userView];
    }
    return self;
}

#pragma mark -
- (void)setHomeSceneListData:(HomeSceneListRow *)model {
    [self titleTextStyle:model.title];
    [self.bgImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self.userHeader downloadImage:model.user.avatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = model.user.nickname;
    self.lookNum.text = [self aboutCount:self.lookNum withCount:model.viewCount];
    self.likeNum.text = [self aboutCount:self.likeNum withCount:model.loveCount];
    self.whereScene.text = [self abouText:self.whereScene withText:model.sceneTitle];
    self.city.text = [self abouText:self.city withText:model.address];
    self.time.text = [NSString stringWithFormat:@"|  %@", model.createdAt];
    
    if (model.user.isExpert == 1) {
        self.userVimg.hidden = NO;
        self.userStar.text = model.user.expertLabel;
        self.userProfile.text = [NSString stringWithFormat:@"|  %@", model.user.expertInfo];
        CGSize size = [self.userStar boundingRectWithSize:CGSizeMake(100, 0)];
        
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width);
        }];
        [self.userProfile mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userStar.mas_right).with.offset(5);
        }];
        
    } else {
        self.userVimg.hidden = YES;
        self.userStar.text = @"";
        self.userProfile.text = model.user.summary;
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.userProfile mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userStar.mas_right).with.offset(0);
        }];
    }
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
        _userView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 170, SCREEN_WIDTH - 40, 160)];
        
        [_userView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(_userView.mas_top).with.offset(0);
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
            make.size.mas_equalTo(CGSizeMake(150, 14));
            make.top.equalTo(_userHeader.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(6);
        }];
        
        [_userView addSubview:self.userStar];
        [_userStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 14));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(6);
        }];
        
        [_userView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(220, 14));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(self.userStar.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.lookNum];
        [_lookNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 13));
            make.top.equalTo(_userHeader.mas_bottom).with.offset(5);
            make.left.equalTo(_userView.mas_left).with.offset(20);
        }];
        
        [_userView addSubview:self.likeNum];
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 13));
            make.top.equalTo(_lookNum.mas_top).with.offset(0);
            make.left.equalTo(_lookNum.mas_right).with.offset(30);
        }];
        
        [_userView addSubview:self.titleText];
        [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
            make.top.equalTo(_lookNum.mas_bottom).with.offset(5);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.whereScene];
        [_whereScene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130, 13));
            make.top.equalTo(_titleText.mas_bottom).with.offset(5);
            make.left.equalTo(_userView.mas_left).with.offset(20);
        }];
        
        [_userView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 13));
            make.top.equalTo(_whereScene.mas_top).with.offset(0);
            make.left.equalTo(_whereScene.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.city];
        [_city mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.top.equalTo(_time.mas_bottom).with.offset(5);
            make.left.equalTo(_userView.mas_left).with.offset(20);
            make.right.equalTo(_userView.mas_right).with.offset(-40);
        }];
    }
    return _userView;
}

#pragma mark - 用户头像
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.7].CGColor;
        _userHeader.layer.borderWidth = 1;
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.cornerRadius = 15;
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
            _userStar.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        } else {
            _userStar.font = [UIFont systemFontOfSize:11];
        }
        _userStar.textColor = [UIColor whiteColor];
    }
    return _userStar;
}

#pragma mark - 用户昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _userName.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _userName.font = [UIFont systemFontOfSize:14];
        }
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _userProfile.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        } else {
            _userProfile.font = [UIFont systemFontOfSize:11];
        }
    }
    return _userProfile;
}

#pragma mark - 观看数量
- (UILabel *)lookNum {
    if (!_lookNum) {
        _lookNum = [[UILabel alloc] init];
        [self addIcon:_lookNum withImage:@"look"];
        if (IS_iOS9) {
            _lookNum.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _lookNum.font = [UIFont systemFontOfSize:12];
        }
        _lookNum.textColor = [UIColor whiteColor];
    }
    return _lookNum;
}

#pragma mark - 喜欢数量
- (UILabel *)likeNum {
    if (!_likeNum) {
        _likeNum = [[UILabel alloc] init];
        [self addIcon:_likeNum withImage:@"like"];
        if (IS_iOS9) {
            _likeNum.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _likeNum.font = [UIFont systemFontOfSize:12];
        }
        _likeNum.textColor = [UIColor whiteColor];
    }
    return _likeNum;
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
- (void)titleTextStyle:(NSString *)title {
    if ([title length] < 8) {
        if (IS_iOS9) {
            _titleText.font = [UIFont fontWithName:@"PingFangSC-Light" size:40];
        } else {
            _titleText.font = [UIFont systemFontOfSize:40];
        }
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
        }];
    } else if ([title length] >= 8 && [title length] < 13) {
        if (IS_iOS9) {
            _titleText.font = [UIFont fontWithName:@"PingFangSC-Light" size:26];
        } else {
            _titleText.font = [UIFont systemFontOfSize:26];
        }
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
        }];
    } else if ([title length] >= 13) {
        if (IS_iOS9) {
            _titleText.font = [UIFont fontWithName:@"PingFangSC-Light" size:20];
        } else {
            _titleText.font = [UIFont systemFontOfSize:20];
        }
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 56));
        }];
    }
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary * textDict = @{
                                NSBackgroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]] ,
                                NSParagraphStyleAttributeName :paragraphStyle
                                };
    [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
    self.titleText.attributedText = titleText;
}

//  数量样式
- (NSString *)aboutCount:(UILabel *)lable withCount:(NSInteger)count {
    NSString * num = [NSString stringWithFormat:@"%zi", count];
    CGFloat numLength = [num boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(numLength * 1.2, 15));
    }];
    return num;
}

//  文字情景
- (NSString *)abouText:(UILabel *)lable withText:(NSString *)fiuScene {
    NSString * whereText = fiuScene;
    CGFloat textLength = [fiuScene boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    if (lable == self.whereScene) {
        [lable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(textLength + 5, 15));
        }];
    }
    return whereText;
}

#pragma mark - 所属情景
- (UILabel *)whereScene {
    if (!_whereScene) {
        _whereScene = [[UILabel alloc] init];
        [self addIcon:_whereScene withImage:@"icon_star"];
        if (IS_iOS9) {
            _whereScene.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _whereScene.font = [UIFont systemFontOfSize:12];
        }
        _whereScene.textColor = [UIColor whiteColor];
    }
    return _whereScene;
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
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(-22, -2, 20, 20)];
    icon.contentMode = UIViewContentModeCenter;
    icon.image = [UIImage imageNamed:iconImage];
    [lable addSubview:icon];
}

@end
