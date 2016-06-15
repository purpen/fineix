//
//  UserInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "HomePageViewController.h"
#import "UIButton+WebCache.h"
#import "GoodsInfoViewController.h"

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setCellUI];
        
    }
    return self;
}

#pragma mark -
- (void)setSceneInfoData:(SceneInfoData *)model {
    //  商品标签
    self.tagDataMarr = [NSMutableArray arrayWithArray:model.product];
//    [self setUserTagBtn];
    
    self.goodsIds = [NSMutableArray arrayWithArray:[model.product valueForKey:@"idField"]];
    self.userId = [NSString stringWithFormat:@"%zi", model.userInfo.userId];
    
    [self.bgImage sd_setBackgroundImageWithURL:[NSURL URLWithString:model.coverUrl] forState:(UIControlStateNormal)];
    [self.bgImage sd_setBackgroundImageWithURL:[NSURL URLWithString:model.coverUrl] forState:(UIControlStateHighlighted)];
    
    [self titleTextStyle:[NSString stringWithFormat:@"%@", model.title] withBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titleBg"]]];
    self.whereScene.text = [self abouText:self.whereScene withText:model.sceneTitle];
    self.city.text = [self abouText:self.city withText:model.address];
    [self.userHeader sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatarUrl] forState:(UIControlStateNormal)];
    self.userName.text = model.userInfo.nickname;
    self.time.text = [NSString stringWithFormat:@"| %@", model.createdAt];
    
    //  是否是达人
    if (model.userInfo.isExpert == 1) {
        self.userVimg.hidden = NO;
        [self.userStar setUserTagInfo:model.userInfo.expertLabel];
        self.userProfile.text = [NSString stringWithFormat:@"%@", model.userInfo.expertInfo];
        CGSize size = [self.userStar boundingRectWithSize:CGSizeMake(100, 0)];
        
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width + 10);
        }];
        [self.userProfile mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userStar.mas_right).with.offset(5);
        }];
        
    } else if (model.userInfo.isExpert == 0) {
        self.userProfile.text = model.userInfo.summary;
    }

    //  是否点赞
    if (model.isLove == 0) {
        self.goodBtn.selected = NO;
    } else if (model.isLove == 1) {
        self.goodBtn.selected = YES;
    }
    //  点赞的人数
    if (model.loveCount/1000 > 1) {
        self.goodNum.text = [NSString stringWithFormat:@"%zik%@", model.loveCount/1000, NSLocalizedString(@"peopleLike", nil)];
    } else {
        self.goodNum.text = [NSString stringWithFormat:@"%zi%@", model.loveCount, NSLocalizedString(@"peopleLike", nil)];
    }
}

#pragma mark - 
- (void)setCellUI {
//    [self addSubview:self.bgImage];
    
    [self addSubview:self.userView];
}

#pragma mark - 创建用户添加商品按钮
- (void)setUserTagBtn {
    self.userTagMarr = [NSMutableArray array];
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UserGoodsTag class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger idx = 0; idx < self.tagDataMarr.count; ++ idx) {
        CGFloat btnX = [[self.tagDataMarr[idx] valueForKey:@"x"] floatValue];
        CGFloat btnY = [[self.tagDataMarr[idx] valueForKey:@"y"] floatValue];
        NSString * title = [self.tagDataMarr[idx] valueForKey:@"title"];
        NSString * price = [NSString stringWithFormat:@"￥%.2f", [[self.tagDataMarr[idx] valueForKey:@"price"] floatValue]];
        UserGoodsTag * userTag = [[UserGoodsTag alloc] initWithFrame:CGRectMake(btnX * SCREEN_WIDTH, (btnY * SCREEN_HEIGHT) * 0.873, 175, 32)];
        userTag.dele.hidden = YES;
        userTag.title.text = title;
        if (price.length > 6) {
            userTag.price.font = [UIFont systemFontOfSize:9];
        }
        userTag.price.text = price;
        userTag.title.hidden = YES;
        userTag.price.hidden = YES;
        userTag.isMove = NO;
        [userTag setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGoodsInfo:)];
        [userTag addGestureRecognizer:tapGesture];
        [self addSubview:userTag];
        [self.userTagMarr addObject:userTag];
    }
}

- (void)openGoodsInfo:(UIGestureRecognizer *)button {
    NSInteger index = [self.userTagMarr indexOfObject:button.view];
    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = self.goodsIds[index];
    [self.nav pushViewController:goodsInfoVC animated:YES];
    
}

#pragma mark - 场景图
- (UIButton *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_bgImage addTarget:self action:@selector(showUserTag:) forControlEvents:(UIControlEventTouchUpInside)];
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
        _bgImage.selected = NO;
    }
    return _bgImage;
}

#pragma mark 显示／隐藏标签
- (void)showUserTag:(UIButton *)button {
    CGRect userViewRect = self.userView.frame;
    
    if (button.selected == YES) {
        button.selected = NO;
        
        userViewRect = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, 170);
        [UIView animateWithDuration:.5 animations:^{
            self.userView.frame = userViewRect;
        } completion:^(BOOL finished) {
            self.userView.hidden = YES;
        }];
        
        for (UserGoodsTag * goodsTag in self.userTagMarr) {
            goodsTag.title.hidden = NO;
            goodsTag.price.hidden = NO;
            [goodsTag setImage:[UIImage imageNamed:@"user_goodsTag_left"] forState:(UIControlStateNormal)];
        }
        [self layoutIfNeeded];
        
    } else if (button.selected == NO) {
        button.selected = YES;
        
        userViewRect = CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 170);
        [UIView animateWithDuration:.3 animations:^{
            self.userView.hidden = NO;
            self.userView.frame = userViewRect;
        }];
        
        for (UserGoodsTag * goodsTag in self.userTagMarr) {
            goodsTag.title.hidden = YES;
            goodsTag.price.hidden = YES;
            [goodsTag setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        }
        [self layoutIfNeeded];
    }
}

#pragma mark - 用户信息
- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        
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
            make.size.mas_equalTo(CGSizeMake(220, 14));
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
            make.size.mas_equalTo(CGSizeMake(75, 15));
            make.bottom.equalTo(_userLeftView.mas_top).with.offset(-10);
            make.left.equalTo(_userView.mas_left).with.offset(40);
            make.right.equalTo(_userView.mas_right).with.offset(-20);
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
    }
    return _userLeftView;
}

#pragma mark - 点赞的按钮
- (UIButton *)goodBtn {
    if (!_goodBtn) {
        _goodBtn = [[UIButton alloc] init];
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:(UIControlStateNormal)];
        [_goodBtn setBackgroundImage:[UIImage imageNamed:@"icon_like_seleted"] forState:(UIControlStateSelected)];
        _goodBtn.selected = NO;
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
- (UIButton *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIButton alloc] init];
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.cornerRadius = 15;
        [_userHeader addTarget:self action:@selector(lookUserHome) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _userHeader;
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
        _userName.font = [UIFont systemFontOfSize:Font_UserName];
    }
    return _userName;
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
- (FBUserTagsLable *)userStar {
    if (!_userStar) {
        _userStar = [[FBUserTagsLable alloc] init];
        _userStar.font = [UIFont systemFontOfSize:10];
        _userStar.textAlignment = NSTextAlignmentCenter;
        _userStar.layer.cornerRadius = 3;
        _userStar.layer.masksToBounds = YES;
        _userStar.layer.borderWidth = 0.5f;
    }
    return _userStar;
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
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 56));
        }];
    } else if ([title length] >= 8 && [title length] < 13) {
        _titleText.font = [UIFont systemFontOfSize:26];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 36));
        }];
    } else if ([title length] >= 13) {
        _titleText.font = [UIFont systemFontOfSize:20];
        [_titleText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 30));
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
        make.size.mas_equalTo(CGSizeMake(textLength + 5, 15));
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
