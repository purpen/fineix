//
//  UserHeaderTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserHeaderTableViewCell.h"

@implementation UserHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setCellViewUI];
        
    }
    return self;
}

- (void)setUI {
    [self.userHeader setBackgroundImage:[UIImage imageNamed:@"asdfsd"] forState:(UIControlStateNormal)];
    
    self.userName.text = @"哈哈哈";
    
    self.userProfile.text = @"人生真的是一场大设计啊";
}

#pragma mark - 
- (void)setCellViewUI {
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.5, 32.5));
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
        make.size.mas_equalTo(CGSizeMake(70, 26));
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
        
    }
    return _userHeader;
}

#pragma mark - 用户昵称
- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#888888"];
        if (IS_iOS9) {
            _userName.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _userName.font = [UIFont systemFontOfSize:12];
        }
    }
    return _userName;
}

#pragma mark - 用户简介
- (UILabel *)userProfile {
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _userProfile.font = [UIFont fontWithName:@"PingFangSC-Light" size:9];
        } else {
            _userProfile.font = [UIFont systemFontOfSize:9];
        }
    }
    return _userProfile;
}

#pragma mark - 关注按钮
- (UIButton *)concernBtn {
    if (!_concernBtn) {
        _concernBtn = [[UIButton alloc] init];
        _concernBtn.layer.borderColor = [UIColor colorWithHexString:titleColor].CGColor;
        _concernBtn.layer.borderWidth = 1;
        _concernBtn.layer.cornerRadius = 3;
        [_concernBtn setTitle:NSLocalizedString(@"concern", nil) forState:(UIControlStateNormal)];
        [_concernBtn setTitle:NSLocalizedString(@"concernDone", nil) forState:(UIControlStateSelected)];
        [_concernBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        [_concernBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [_concernBtn setBackgroundImage:[UIImage imageNamed:@"Button Background"] forState:(UIControlStateSelected)];
        if (IS_iOS9) {
            _concernBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _concernBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
    }
    return _concernBtn;
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
