//
//  UserHeaderTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserHeaderTableViewCell.h"

@interface UserHeaderTableViewCell () {
    NSString *_userId;
}

@end

@implementation UserHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setCellViewUI];
    }
    return self;
}

- (void)setUserListData:(UserModelRow *)model nowUserId:(NSString *)userId {
    [self.userHeader sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] forState:(UIControlStateNormal)];
    self.userName.text = model.nickname;
    self.userProfile.text = model.summary;
    _userId = model.userId;
    if ([_userId isEqualToString:userId]) {
        self.concernBtn.hidden = YES;
    } else {
        self.concernBtn.hidden = NO;
    }
    
    if (model.isFollow == 0) {
        self.concernBtn.selected = NO;
    } else if (model.isFollow == 1) {
        self.concernBtn.selected = YES;
    }
}

#pragma mark - 
- (void)setCellViewUI {
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.top.equalTo(_userHeader.mas_top).with.offset(0);
        make.left.equalTo(_userHeader.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.userProfile];
    [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.bottom.equalTo(_userHeader.mas_bottom).with.offset(0);
        make.left.equalTo(_userHeader.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.concernBtn];
    [_concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 24));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self addSubview:self.line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(self.mas_bottom).with.offset(-1);
        make.left.equalTo(_userName.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
}

#pragma mark - 用户头像
- (UIButton *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIButton alloc] init];
        _userHeader.layer.cornerRadius = 32/2;
        _userHeader.layer.masksToBounds = YES;
    }
    return _userHeader;
}

#pragma mark - 用户昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#888888"];
        _userName.font = [UIFont systemFontOfSize:12];
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor colorWithHexString:titleColor];
        _userProfile.font = [UIFont systemFontOfSize:9];
    }
    return _userProfile;
}

#pragma mark - 关注按钮
- (UIButton *)concernBtn {
    if (!_concernBtn) {
        _concernBtn = [[UIButton alloc] init];
        _concernBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _concernBtn.layer.borderWidth = 0.5;
        _concernBtn.layer.cornerRadius = 4;
        [_concernBtn setTitle:NSLocalizedString(@"User_follow", nil) forState:(UIControlStateNormal)];
        [_concernBtn setTitle:NSLocalizedString(@"User_followDone", nil) forState:(UIControlStateSelected)];
        [_concernBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:(UIControlStateNormal)];
        _concernBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_concernBtn addTarget:self action:@selector(concernBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _concernBtn;
}

- (void)concernBtnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        _concernBtn.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        _concernBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_concernBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchFollowUser" object:_userId];
 
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        _concernBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _concernBtn.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCancelFollowUser" object:_userId];
    }
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

@end
