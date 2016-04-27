//
//  BackgroundCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BackgroundCollectionViewCell.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BackgroundCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.frame.size);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
        
        [self.contentView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 12));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-14/667.0*SCREEN_HEIGHT);
        }];
        
//        [self.contentView addSubview:self.backBtn];
//        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 18));
//            make.top.mas_equalTo(self.mas_top).with.offset(35);
//            make.left.mas_equalTo(self.mas_left).with.offset(16);
//        }];
//        
//        [self.contentView addSubview:self.editBtn];
//        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//            //make.top.mas_equalTo(_bgImageView.mas_top).with.offset(35);
//            make.right.mas_equalTo(self.mas_right).with.offset(-16);
//            make.centerY.mas_equalTo(_backBtn.mas_centerY);
//        }];
        
        [self.contentView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 12));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nickName];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 19));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-9/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.userHeadImageView];
        [_userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80/667.0*SCREEN_HEIGHT, 80/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_nickName.mas_top).with.offset(-10/667.0*SCREEN_HEIGHT);
        }];
    }
    return self;
}

-(void)setUI{
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        //更新头像
        [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    self.bgImageView.image = [UIImage imageNamed:@"image"];
    self.nickName.text = entity.nickname;
    self.userProfile.text = entity.summary;
    self.userLevelLabel.text = [NSString stringWithFormat:@"%@|V%d",entity.levelDesc,[entity.level intValue]];
}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        
//        [_bgImageView addSubview:self.userLevelLabel];
//        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(200, 12));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_bgImageView.mas_bottom).with.offset(-14/667.0*SCREEN_HEIGHT);
//        }];
        
        [_bgImageView addSubview:self.backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 18));
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(35);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(16);
        }];
        
        [_bgImageView addSubview:self.editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            //make.top.mas_equalTo(_bgImageView.mas_top).with.offset(35);
            make.right.mas_equalTo(_bgImageView.mas_right).with.offset(-16);
            make.centerY.mas_equalTo(_backBtn.mas_centerY);
        }];
//
//        [_bgImageView addSubview:self.userProfile];
//        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 12));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
//        }];
//        
//        [_bgImageView addSubview:self.nickName];
//        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 19));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-9/667.0*SCREEN_HEIGHT);
//        }];
//        
//        [_bgImageView addSubview:self.userHeadImageView];
//        [_userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(80/667.0*SCREEN_HEIGHT, 80/667.0*SCREEN_HEIGHT));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_nickName.mas_top).with.offset(-10/667.0*SCREEN_HEIGHT);
//        }];
    }
    return _bgImageView;
}

-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        _editBtn.userInteractionEnabled = YES;
        _editBtn.clipsToBounds = YES;
        _editBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [_editBtn setImage:[UIImage imageNamed:@"editData"] forState:UIControlStateNormal];
    }
    return _editBtn;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.userInteractionEnabled = YES;
        _backBtn.clipsToBounds = YES;
        _backBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [_backBtn setImage:[UIImage imageNamed:@"Fill 1"] forState:UIControlStateNormal];
    }
    return _backBtn;
}



-(UILabel *)userProfile{
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor whiteColor];
        _userProfile.font = [UIFont systemFontOfSize:10];
        _userProfile.textAlignment = NSTextAlignmentCenter;
        _userProfile.clipsToBounds = YES;
        _userProfile.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _userProfile;
}

-(UILabel *)userLevelLabel{
    if (!_userLevelLabel) {
        _userLevelLabel = [[UILabel alloc] init];
        _userLevelLabel.textColor = [UIColor whiteColor];
        _userLevelLabel.font = [UIFont systemFontOfSize:10];
        _userLevelLabel.textAlignment = NSTextAlignmentCenter;
        _userLevelLabel.clipsToBounds = YES;
        _userLevelLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _userLevelLabel;
}

-(UILabel *)nickName{
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.font = [UIFont systemFontOfSize:14];
        _nickName.textAlignment = NSTextAlignmentCenter;
        _nickName.clipsToBounds = YES;
        _nickName.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _nickName;
}

-(UIImageView *)userHeadImageView{
    if (!_userHeadImageView) {
        _userHeadImageView = [[UIImageView alloc] init];
        _userHeadImageView.layer.masksToBounds = YES;
        _userHeadImageView.layer.cornerRadius = 40/667.0*SCREEN_HEIGHT;
        _userHeadImageView.clipsToBounds = YES;
        _userHeadImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _userHeadImageView;
}

@end
