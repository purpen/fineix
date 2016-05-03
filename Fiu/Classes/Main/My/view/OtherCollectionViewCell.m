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
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.userInteractionEnabled = YES;
//        [self.contentView addSubview:self.bgImageView];
//        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 240/667.0*SCREEN_HEIGHT));
//            make.top.equalTo(self.mas_top).with.offset(0);
//            make.left.equalTo(self.mas_left).with.offset(0);
//        }];
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
                [self.contentView addSubview:self.bgImageView];
                [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 240/667.0*SCREEN_HEIGHT));
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
        
//        [self.contentView addSubview:self.backBtn];
//        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 18));
//            make.top.mas_equalTo(self.mas_top).with.offset(35);
//            make.left.mas_equalTo(self.mas_left).with.offset(16);
//        }];
        
        [self.contentView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 12));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
        }];
        
        
        [self.contentView addSubview:self.userHeadImageView];
        [_userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80/667.0*SCREEN_HEIGHT, 80/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-13/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nickName];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(_userHeadImageView.mas_top).with.offset(-22/667.0*SCREEN_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(200, 19));
            
        }];
        
//        [self.contentView addSubview:self.moreBtn];
//        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 20));
//            make.right.mas_equalTo(self.mas_right).with.offset(-16);
//            make.top.mas_equalTo(self.mas_top).with.offset(35);
//        }];

    }
    return self;
}

-(void)setUIWithModel:(UserInfo *)model{
    //这里要改成别人的信息
    
    //更新头像
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nickName.text = model.nickname;
    self.userProfile.text = model.summary;
    self.userLevelLabel.text = [NSString stringWithFormat:@"%@|V%d",model.levelDesc,[model.level intValue]];
    
    self.bgImageView.image = [UIImage imageNamed:@"image"];
}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        
//        [_bgImageView addSubview:self.focusOnBtn];
//        [_focusOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 50*0.5/667.0*SCREEN_HEIGHT));
//            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(103/667.0*SCREEN_HEIGHT);
//            make.bottom.mas_equalTo(_bgImageView.mas_bottom).with.offset(-10/667.0*SCREEN_HEIGHT);
//        }];
//        
//        [_bgImageView addSubview:self.directMessages];
//        [_directMessages mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 50*0.5/667.0*SCREEN_HEIGHT));
//            make.right.mas_equalTo(_bgImageView.mas_right).with.offset(-103/667.0*SCREEN_HEIGHT);
//            make.bottom.mas_equalTo(_bgImageView.mas_bottom).with.offset(-10/667.0*SCREEN_HEIGHT);
//        }];
//        
//        [_bgImageView addSubview:self.userLevelLabel];
//        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(200, 12));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_bgImageView.mas_bottom).with.offset(-44/667.0*SCREEN_HEIGHT);
//        }];
//        
        [_bgImageView addSubview:self.backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 18));
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(35);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(16);
        }];
//
//        [_bgImageView addSubview:self.userProfile];
//        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 12));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
//        }];
//        
//        
//        [_bgImageView addSubview:self.userHeadImageView];
//        [_userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(80/667.0*SCREEN_HEIGHT, 80/667.0*SCREEN_HEIGHT));
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-13/667.0*SCREEN_HEIGHT);
//        }];
//        
//        [_bgImageView addSubview:self.nickName];
//        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(_bgImageView.mas_centerX);
//            make.bottom.mas_equalTo(_userHeadImageView.mas_top).with.offset(-22/667.0*SCREEN_HEIGHT);
//            make.size.mas_equalTo(CGSizeMake(200, 19));
//            
//        }];
//        
        [_bgImageView addSubview:self.moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 20));
            make.right.mas_equalTo(_bgImageView.mas_right).with.offset(-16);
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(35);
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
