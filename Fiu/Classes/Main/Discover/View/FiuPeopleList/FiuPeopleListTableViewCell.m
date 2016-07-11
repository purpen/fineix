//
//  FiuPeopleListTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuPeopleListTableViewCell.h"
#import "UILable+Frame.h"

@implementation FiuPeopleListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
    }
    return self;
}

- (void)setFiuPeopleListData:(NSInteger)num withData:(FiuPeopleListRow *)model {
    self.userName.text = model.nickname;
    [self.userHeader downloadImage:model.avatarUrl place:[UIImage imageNamed:@""]];
    self.userLevel.text = [NSString stringWithFormat:@"LV%zi",model.userRank];
    if (model.isExpert == 1) {
        self.userVimg.hidden = NO;
        self.userStar.text = model.expertLabel;
        self.userProfile.text = [NSString stringWithFormat:@"|  %@", model.expertInfo];
        
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
        self.userProfile.text = model.summary;
        
        [self.userStar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.userProfile mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userStar.mas_right).with.offset(0);
        }];
    }

    //  显示奖牌图像
    self.numLab.text = [NSString stringWithFormat:@"%zi", num];
    NSArray * winArr = @[@"jiang1", @"jiang2", @"jiang3"];
    if (num < 4) {
        self.numLab.hidden = YES;
        self.firstImg.hidden = NO;
        [self.firstImg setImage:[UIImage imageNamed:winArr[num - 1]] forState:(UIControlStateNormal)];
        
    } else {
        self.numLab.hidden = NO;
        self.firstImg.hidden = YES;
    }
}

#pragma mark - UI
- (void)setCellUI {
    
    [self addSubview:self.numLab];
    [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 65));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.firstImg];
    [_firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 65));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(60);
    }];
    
    [self addSubview:self.userVimg];
    [_userVimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
        make.left.equalTo(_userHeader.mas_right).with.offset(-9);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 14));
        make.top.equalTo(_userHeader.mas_top).with.offset(5);
        make.left.equalTo(_userHeader.mas_right).with.offset(10);
    }];

    [self addSubview:self.userLevel];
    [_userLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30,14));
        make.top.equalTo(_userName.mas_bottom).with.offset(5);
        make.left.equalTo(_userName.mas_left).with.offset(0);
    }];

    [self addSubview:self.userStar];
    [_userStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0, 14));
        make.bottom.equalTo(_userLevel.mas_bottom).with.offset(0);
        make.left.equalTo(_userLevel.mas_right).with.offset(0);
    }];

    [self addSubview:self.userProfile];
    [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(220, 14));
        make.bottom.equalTo(_userLevel.mas_bottom).with.offset(0);
        make.left.equalTo(_userLevel.mas_right).with.offset(0);
    }];
    
}

#pragma mark - 排名
- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont boldSystemFontOfSize:22];
        _numLab.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
        _numLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
}

#pragma mark - 奖牌
- (UIButton *)firstImg {
    if (!_firstImg) {
        _firstImg = [[UIButton alloc] init];
    }
    return _firstImg;
}

#pragma mark - 等级
- (UILabel *)userLevel {
    if (!_userLevel) {
        _userLevel = [[UILabel alloc] init];
        _userLevel.textColor = [UIColor colorWithHexString:fineixColor];
        _userLevel.font = [UIFont systemFontOfSize:11];
    }
    return _userLevel;
}

#pragma mark - 用户头像
- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.borderColor = [UIColor colorWithHexString:@"#666666" alpha:.5].CGColor;
        _userHeader.layer.borderWidth = 0.5f;
        _userHeader.layer.masksToBounds = YES;
        _userHeader.layer.cornerRadius = 20;
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
        _userStar.font = [UIFont systemFontOfSize:11];
        _userStar.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _userStar;
}

#pragma mark - 用户昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor blackColor];
        _userName.font = [UIFont systemFontOfSize:14];
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor colorWithHexString:@"#666666"];
        _userProfile.font = [UIFont systemFontOfSize:11];
    }
    return _userProfile;
}


@end
