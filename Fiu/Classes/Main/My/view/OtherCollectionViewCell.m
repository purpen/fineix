//
//  OtherCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "OtherCollectionViewCell.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfo.h"

@implementation OtherCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
                [self.contentView addSubview:self.bgImageView];
                [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 344/667.0*SCREEN_HEIGHT));
                    make.top.equalTo(self.mas_top).with.offset(0);
                    make.left.equalTo(self.mas_left).with.offset(0);
                }];
        
        [self.contentView addSubview:self.focusOnBtn];
        [_focusOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 50*0.5/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(self.mas_left).with.offset(103/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.directMessages];
        [_directMessages mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 50*0.5/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.mas_right).with.offset(-103/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 12));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-44/667.0*SCREEN_HEIGHT);
        }];
        
        
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
        
        
        [self.contentView addSubview:self.headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84/667.0*SCREEN_HEIGHT, 84/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_nickName.mas_top).with.offset(-8/667.0*SCREEN_HEIGHT);
        }];

    }
    return self;
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


-(void)setUIWithModel:(UserInfo *)model{
    
    if ([model.is_love isEqualToNumber:@0]) {
        self.focusOnBtn.selected = NO;
    }else if([model.is_love isEqualToNumber:@1]){
        self.focusOnBtn.selected = YES;
    }
    //这里要改成别人的信息
    
    //更新头像
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nickName.text = model.nickname;
    self.userProfile.text = model.summary;
    self.userLevelLabel.text = [NSString stringWithFormat:@"%@|V%d",model.levelDesc,[model.level intValue]];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.head_pic_url] placeholderImage:[UIImage imageNamed:@"image"]];
}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        //_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        
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
//        
        [_bgImageView addSubview:self.backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30/667.0*SCREEN_HEIGHT, 20/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(79);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(16);
        }];

//        
        [_bgImageView addSubview:self.moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 20));
            make.right.mas_equalTo(_bgImageView.mas_right).with.offset(-16);
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(79);
        }];
    }
    return _bgImageView;
}

-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"more_filled"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}

-(UIButton *)focusOnBtn{
    if (!_focusOnBtn) {
        _focusOnBtn = [[UIButton alloc] init];
        [_focusOnBtn setImage:[UIImage imageNamed:@"hfocusBtn"] forState:UIControlStateNormal];
        [_focusOnBtn setImage:[UIImage imageNamed:@"hasBeenFocusedOn"] forState:UIControlStateSelected];
    }
    return _focusOnBtn;
}

-(UIButton *)directMessages{
    if (!_directMessages) {
        _directMessages = [[UIButton alloc] init];
        [_directMessages setImage:[UIImage imageNamed:@"directMessages"] forState:UIControlStateNormal];
    }
    return _directMessages;
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
