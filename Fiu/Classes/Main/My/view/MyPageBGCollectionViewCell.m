//
//  MyPageBGCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyPageBGCollectionViewCell.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MyPageBGCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 344/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(self.mas_top).with.offset(0);
            make.left.mas_equalTo(self.mas_left).with.offset(0);
        }];
        
//        [self.contentView addSubview:self.certificationBtn];
//        [_certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 25/667.0*SCREEN_HEIGHT));
//            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-15/667.0*SCREEN_HEIGHT);
//            make.centerX.mas_equalTo(self.mas_centerX);
//        }];
        
        [self.contentView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-49/667.0*SCREEN_HEIGHT);
        }];
        
        
        [self.contentView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 12));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84/667.0*SCREEN_HEIGHT, 84/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-8/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nickName];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 19));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_headView.mas_top).with.offset(-15/667.0*SCREEN_HEIGHT);
        }];
        
        
        [self.contentView addSubview:self.idImageView];
        [_idImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(28, 12));
            make.right.mas_equalTo(_userLevelLabel.mas_left).with.offset(3);
            make.centerY.mas_equalTo(_userLevelLabel.mas_centerY);
        }];
        
    }
    return self;
}

-(UIImageView *)idImageView{
    if (!_idImageView) {
        _idImageView = [[UIImageView alloc] init];
        
    }
    return _idImageView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = 42/667.0*SCREEN_HEIGHT;
        
        [_headView addSubview:self.userHeadImageView];
        [_userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80/667.0*SCREEN_HEIGHT, 80/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(_headView.mas_centerX);
            make.centerY.mas_equalTo(_headView.mas_centerY);
        }];
    }
    return _headView;
}

//-(UIButton *)certificationBtn{
//    if (!_certificationBtn) {
//        _certificationBtn = [[UIButton alloc] init];
//        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){255 / 255, 255 / 255, 255 / 255, 1});
//        _certificationBtn.layer.borderWidth = 0.5;
//        _certificationBtn.layer.borderColor = color;
//        [_certificationBtn setTitle:@"我要认证" forState:UIControlStateNormal];
//        _certificationBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    }
//    return _certificationBtn;
//}

-(void)setUI{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    //更新头像
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:entity.head_pic_url] placeholderImage:[UIImage imageNamed:@"image"]];
    self.nickName.text = entity.nickname;
    self.userProfile.text = entity.summary;
    if ([entity.is_expert isEqualToString:@"0"]) {
        self.userLevelLabel.text = [NSString stringWithFormat:@"%@ | V%d",entity.label,[entity.level intValue]];
        self.idImageView.hidden = YES;
    }else if([entity.is_expert isEqualToString:@"1"]){
        self.userLevelLabel.text = [NSString stringWithFormat:@" | V%d",[entity.level intValue]];
        self.idImageView.hidden = NO;
        self.idImageView.image = [UIImage imageNamed:entity.label];
    }
    
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:entity.head_pic_url] placeholderImage:[UIImage imageNamed:@"image"]];
}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        shadow.locations = @[@(0.5f), @(1.5f)];
        shadow.frame = _bgImageView.bounds;
        [_bgImageView.layer addSublayer:shadow];
    }
    return _bgImageView;
}



-(UILabel *)userProfile{
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor whiteColor];
        _userProfile.font = [UIFont systemFontOfSize:11];
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
        _userLevelLabel.font = [UIFont systemFontOfSize:11];
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
        _nickName.font = [UIFont systemFontOfSize:15];
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
