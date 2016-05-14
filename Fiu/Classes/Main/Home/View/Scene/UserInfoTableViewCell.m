//
//  UserInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "HomePageViewController.h"

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self addSubview:self.bgImage];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setFiuSceneInfoData:(FiuSceneInfoData *)model {
    [self.bgImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self.userHeader downloadImage:model.userInfo.avatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = model.userInfo.nickname;
    self.userProfile.text = model.userInfo.summary;
    
    UIColor * fsceneColor = [UIColor blackColor];
    [self titleTextStyle:[NSString stringWithFormat:@"%@", model.title] withBgColor:fsceneColor];
    
    CGFloat cityLength = [model.address boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    self.city.text = model.address;
    [self.whereScene removeFromSuperview];
    [self.city mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cityLength * 1.1, 15));
        make.left.equalTo(self.mas_left).with.offset(40);
    }];
    
    self.time.text = [NSString stringWithFormat:@"| %@", model.createdAt];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.city.mas_right).with.offset(10);
        make.bottom.equalTo(self.city.mas_bottom).with.offset(0);
        make.top.equalTo(self.city.mas_top).with.offset(0);
    }];
    
    //  订阅的数量
    [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"User_Su"] forState:(UIControlStateNormal)];
    if (model.subscriptionCount/1000 > 1) {
        self.goodNum.text = [NSString stringWithFormat:@"%zik人订阅", model.subscriptionCount/1000 ];
    } else {
        self.goodNum.text = [NSString stringWithFormat:@"%zi人订阅", model.subscriptionCount];
    }

}

#pragma mark -
- (void)setSceneInfoData:(SceneInfoData *)model {
    [self.bgImage downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self titleTextStyle:[NSString stringWithFormat:@"%@", model.title] withBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]];
    self.whereScene.text = [self abouText:self.whereScene withText:model.sceneTitle];
    self.city.text = [self abouText:self.city withText:model.address];
    [self.userHeader downloadImage:model.userInfo.avatarUrl place:[UIImage imageNamed:@""]];
    self.userName.text = model.userInfo.nickname;
    //  是否是达人
    if (model.userInfo.isExpert == 1) {
        self.userProfile.text = [NSString stringWithFormat:@"达人｜%@",model.userInfo.summary];
    } else if (model.userInfo.isExpert == 0) {
        self.userProfile.text = model.userInfo.summary;
    }

    self.time.text = [NSString stringWithFormat:@"| %@", model.createdAt];
    
    if (model.loveCount/1000 > 1) {
        self.goodNum.text = [NSString stringWithFormat:@"%zik人赞过", model.loveCount/1000];
    } else {
        self.goodNum.text = [NSString stringWithFormat:@"%zi人赞过", model.loveCount];
    }
    
}

#pragma mark - 场景图
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        shadow.locations = @[@(0.5f), @(1.5f)];
        shadow.frame = _bgImage.bounds;
        [_bgImage.layer addSublayer:shadow];
        
        [_bgImage addSubview:self.userView];
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
        
        [_userView addSubview:self.goodBtn];
        [_goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(89.5 ,46));
            make.bottom.equalTo(_userLeftView.mas_bottom).with.offset(0);
            make.left.equalTo(_userLeftView.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.city];
        [_city mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 15));
            make.bottom.equalTo(_userLeftView.mas_top).with.offset(-10);
            make.left.equalTo(_userView.mas_left).with.offset(40);
        }];
        
        [_userView addSubview:self.whereScene];
        [_whereScene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130, 15));
            make.bottom.equalTo(_city.mas_top).with.offset(-5);
            make.left.equalTo(_userView.mas_left).with.offset(40);
        }];
        
        [_userView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.bottom.equalTo(_city.mas_top).with.offset(-5);
            make.left.equalTo(_whereScene.mas_right).with.offset(0);
        }];
        
        [_userView addSubview:self.titleText];
        [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
            make.bottom.equalTo(_time.mas_top).with.offset(-5);
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
        
        [_userLeftView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(_userLeftView);
            make.left.equalTo(_userLeftView.mas_left).with.offset(15);
        }];
        
        [_userLeftView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.top.equalTo(_userHeader.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(10);
        }];
        
        [_userLeftView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(10);
        }];

    }
    return _userLeftView;
}

#pragma mark - 点赞的按钮
- (UIButton *)goodBtn {
    if (!_goodBtn) {
        _goodBtn = [[UIButton alloc] init];
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"User_like"] forState:(UIControlStateNormal)];

        [_goodBtn addSubview:self.goodNum];
        [_goodNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(89 ,13));
            make.bottom.equalTo(_goodBtn.mas_bottom).with.offset(-10);
            make.centerX.equalTo(_goodBtn);
        }];
    }
    return _goodBtn;
}

#pragma mark - 点赞的数量
- (UILabel *)goodNum {
    if (!_goodNum) {
        _goodNum = [[UILabel alloc] init];
        _goodNum.textColor = [UIColor whiteColor];
        _goodNum.textAlignment = NSTextAlignmentCenter;
        _goodNum.font = [UIFont systemFontOfSize:Font_Number];
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
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.cornerRadius = 15;
    }
    return _userHeader;
}

#pragma mark - 用户昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        _userName.font = [UIFont systemFontOfSize:Font_UserName];
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _userProfile.font = [UIFont systemFontOfSize:Font_UserProfile];
    }
    return _userProfile;
}

#pragma mark - 观看数量
- (UILabel *)lookNum {
    if (!_lookNum) {
        _lookNum = [[UILabel alloc] init];
        [self addIcon:_lookNum withImage:@"look"];
        _lookNum.font = [UIFont systemFontOfSize:Font_UserProfile];
        _lookNum.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
    }
    return _lookNum;
}

#pragma mark - 喜欢数量
- (UILabel *)likeNum {
    if (!_likeNum) {
        _likeNum = [[UILabel alloc] init];
        [self addIcon:_likeNum withImage:@"like"];
        _likeNum.font = [UIFont systemFontOfSize:Font_UserProfile];
        _likeNum.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
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
- (void)titleTextStyle:(NSString *)title withBgColor:(UIColor *)color {
    if ([title length] < 8) {
        _titleText.font = [UIFont systemFontOfSize:40];
    } else if ([title length] >= 8 && [title length] < 13) {
        _titleText.font = [UIFont systemFontOfSize:30];
    } else if ([title length] > 13) {
        _titleText.font = [UIFont systemFontOfSize:20];
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

//  数量样式
- (NSString *)aboutCount:(UILabel *)lable withCount:(NSInteger)count {
    NSString * num = [NSString stringWithFormat:@"%zi", count];
    CGFloat numLength = [num boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(numLength, 15));
    }];
    return num;
}

//  文字情景
- (NSString *)abouText:(UILabel *)lable withText:(NSString *)fiuScene {
    NSString * whereText = fiuScene;
    CGFloat textLength = [fiuScene boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [lable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(textLength * 1.1, 15));
    }];
    return whereText;
}

#pragma mark - 所属情景
- (UILabel *)whereScene {
    if (!_whereScene) {
        _whereScene = [[UILabel alloc] init];
        [self addIcon:_whereScene withImage:@"icon_star"];
        _whereScene.font = [UIFont systemFontOfSize:Font_Number];
        _whereScene.textColor = [UIColor whiteColor];
    }
    return _whereScene;
}

#pragma mark - 城市
- (UILabel *)city {
    if (!_city) {
        _city = [[UILabel alloc] init];
        [self addIcon:_city withImage:@"icon_city"];
        _city.font = [UIFont systemFontOfSize:Font_Number];
        _city.textColor = [UIColor whiteColor];
    }
    return _city;
}



#pragma mark - 时间
- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor blackColor];
        _time.font = [UIFont systemFontOfSize:Font_Number];
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