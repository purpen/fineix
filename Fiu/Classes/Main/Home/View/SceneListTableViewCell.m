//
//  SceneListTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneListTableViewCell.h"

@implementation SceneListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.bgImage];
        [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
        
    }
    return self;
}

#pragma mark -
- (void)setUI {
    //  场景图
    self.bgImage.image = [UIImage imageNamed:@"Bitmap"];
    
    //  用户头像
    self.userHeader.image = [UIImage imageNamed:@"user"];
    
    //  用户昵称
    self.userName.text = @"Haasda Fynn";
    
    //  用户简介
    self.userProfile.text = @"达人｜写剧本的文盲";
    
    //  观看数量
    NSString * lookNum = @"35433";
    CGFloat lookNumLength = [lookNum boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [_lookNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(lookNumLength, 15));
    }];
    self.lookNum.text = lookNum;
    
    //  喜欢数量
    NSString * likeNum = @"123225";
    CGFloat likeNumLength = [likeNum boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [_likeNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(likeNumLength, 15));
    }];
    self.likeNum.text = likeNum;

    //  标题
    NSString * titleStr = @"最美的不是下雨天，最美的不是下雨天";
    if ([titleStr length] < 14) {
        _titleText.font = [UIFont boldSystemFontOfSize:40];
    }
    NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSDictionary * dict1 = @{NSBackgroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]};
    [titleText addAttributes:dict1 range:NSMakeRange(0, titleText.length)];
    self.titleText.attributedText = titleText;
    
    //  所属情景
    NSString * whereText = @"最好的时光遇到你最好的时光遇到你";
    CGFloat whereLength = [whereText boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [_whereScene mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(whereLength * 0.8, 15));
    }];
    self.whereScene.text = whereText;
    
    //  城市
    NSString * cityText = @"北京市 朝阳区";
    CGFloat cityLength = [cityText boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [_city mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cityLength * 0.8, 15));
    }];
    self.city.text = cityText;
    
    //  时间
    self.time.text = @"｜ 2天前";
    
}


#pragma mark - 场景图
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [_bgImage addSubview:self.userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 130));
            make.bottom.equalTo(_bgImage.mas_bottom).with.offset(-75);
            make.left.equalTo(_bgImage.mas_left).with.offset(20);
        }];
    }
    return _bgImage;
}

#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.userHeader];
        [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(_userView.mas_top).with.offset(0);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.top.equalTo(_userView.mas_top).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(10);
        }];
        
        [_userView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
            make.left.equalTo(_userHeader.mas_right).with.offset(10);
        }];
        
        [_userView addSubview:self.lookNum];
        [_lookNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.top.equalTo(_userHeader.mas_bottom).with.offset(5);
            make.left.equalTo(_userView.mas_left).with.offset(20);
        }];
        
        [_userView addSubview:self.likeNum];
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 15));
            make.top.equalTo(_lookNum.mas_top).with.offset(0);
            make.left.equalTo(_lookNum.mas_right).with.offset(40);
        }];
        
        [_userView addSubview:self.titleText];
        [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
            make.top.equalTo(_lookNum.mas_bottom).with.offset(5);
            make.left.equalTo(_userView.mas_left).with.offset(0);
        }];
        
        [_userView addSubview:self.whereScene];
        [_whereScene mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130, 15));
            make.bottom.equalTo(_userView.mas_bottom).with.offset(0);
            make.left.equalTo(_userView.mas_left).with.offset(20);
        }];
        
        [_userView addSubview:self.city];
        [_city mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 15));
            make.top.equalTo(_whereScene.mas_top).with.offset(0);
            make.left.equalTo(_whereScene.mas_right).with.offset(30);
        }];
        
        [_userView addSubview:self.time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 15));
            make.top.equalTo(_whereScene.mas_top).with.offset(0);
            make.left.equalTo(_city.mas_right).with.offset(0);
        }];
    }
    return _userView;
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
        _userName.textColor = [UIColor blackColor];
        _userName.font = [UIFont systemFontOfSize:Font_UserName];
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor blackColor];
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
    }
    return _lookNum;
}

#pragma mark - 喜欢数量
- (UILabel *)likeNum {
    if (!_likeNum) {
        _likeNum = [[UILabel alloc] init];
        [self addIcon:_likeNum withImage:@"like"];
        _likeNum.font = [UIFont systemFontOfSize:Font_UserProfile];
    }
    return _likeNum;
}

#pragma mark - 标题文字
- (UILabel *)titleText {
    if (!_titleText) {
        _titleText = [[UILabel alloc] init];
        _titleText.numberOfLines = 2;
        _titleText.textColor = [UIColor whiteColor];
        _titleText.font = [UIFont systemFontOfSize:21];
        _titleText.textAlignment = NSTextAlignmentLeft;
    }
    return _titleText;
}

#pragma mark - 所属情景
- (UILabel *)whereScene {
    if (!_whereScene) {
        _whereScene = [[UILabel alloc] init];
        [self addIcon:_whereScene withImage:@"icon_star"];
        _whereScene.font = [UIFont systemFontOfSize:Font_UserProfile];
    }
    return _whereScene;
}

#pragma mark - 城市
- (UILabel *)city {
    if (!_city) {
        _city = [[UILabel alloc] init];
        [self addIcon:_city withImage:@"icon_city"];
        _city.font = [UIFont systemFontOfSize:Font_UserProfile];
    }
    return _city;
}

#pragma mark - 时间
- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor blackColor];
        _time.font = [UIFont systemFontOfSize:Font_UserProfile];
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

#pragma mark - 点击cell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
