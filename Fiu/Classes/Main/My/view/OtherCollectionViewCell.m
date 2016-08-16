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
#import "TalentView.h"

@implementation OtherCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.frame.size);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
        }];
        
    }
    return self;
}


-(UIView *)userView{
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
        [_userView addSubview:self.focusOnBtn];
        [_focusOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 50*0.5/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_userView.mas_left).with.offset(113/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_userView.mas_bottom).with.offset(-10/667.0*SCREEN_HEIGHT);
        }];
        
        [_userView addSubview:self.directMessages];
        [_directMessages mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(138*0.5/667.0*SCREEN_HEIGHT, 50*0.5/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(_userView.mas_right).with.offset(-113/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_userView.mas_bottom).with.offset(-10/667.0*SCREEN_HEIGHT);
        }];
        
//        [_userView addSubview:self.lineView];
//        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(1, 12));
//            make.centerX.mas_equalTo(_userView.mas_centerX);
//            make.bottom.mas_equalTo(_userView.mas_bottom).with.offset(-49/667.0*SCREEN_HEIGHT);
//        }];
        
        [_userView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(SCREEN_WIDTH-60);
            make.centerX.mas_equalTo(_userView.mas_centerX).with.offset(-10/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_userView.mas_bottom).with.offset(-49/667.0*SCREEN_HEIGHT);
        }];
        
        
        [_userView addSubview:self.idTagsLabel];
        [_idTagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(_userView.mas_centerX).with.offset(-2/667.0*SCREEN_HEIGHT);
        }];
        
//        [_userView addSubview:self.idImageView];
//        [_idImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-5/667.0*SCREEN_HEIGHT);
//            make.right.mas_equalTo(_userView.mas_centerX).with.offset(-2/667.0*SCREEN_HEIGHT);
//        }];
        
        [_userView addSubview:self.userProfile];
        [_userProfile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_idTagsLabel.mas_centerY);
            make.left.mas_equalTo(_idTagsLabel.mas_right).with.offset(3/667.0*SCREEN_HEIGHT);
        }];
        
        
//        [_userView addSubview:self.nickName];
//        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 19));
//            make.centerX.mas_equalTo(_userView.mas_centerX);
//            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-9/667.0*SCREEN_HEIGHT);
//        }];
        
        
        [_userView addSubview:self.headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84/667.0*SCREEN_HEIGHT, 84/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(_userView.mas_centerX);
            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-20/667.0*SCREEN_HEIGHT);
        }];
        
        
        [_userView addSubview:self.talentView];
        [_talentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_headView.mas_right).with.offset(-3/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_headView.mas_bottom).with.offset(-3/667.0*SCREEN_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(17/667.0*SCREEN_HEIGHT, 17/667.0*SCREEN_HEIGHT));
        }];
    }
    return _userView;
}

-(TalentView *)talentView{
    if (!_talentView) {
        _talentView = [TalentView getTalentView];
    }
    return _talentView;
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
    
    if (model.is_love == 0) {
        self.focusOnBtn.selected = NO;
    }else if(model.is_love == 1){
        self.focusOnBtn.selected = YES;
    }
    //这里要改成别人的信息
    
    //更新头像
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nickName.text = model.nickname;
//    NSArray *tagsAry = [NSArray arrayWithObjects:@"大拿",@"行家",@"行摄家",@"艺术范",@"手艺人",@"人来疯",@"赎回自由身",@"职业buyer", nil];
    if ([(NSNumber*)model.is_expert isEqualToNumber:@1]) {
        self.talentView.hidden = NO;
        self.userProfile.hidden = NO;
        self.userProfile.text = model.expert_info;
        self.idTagsLabel.text = [NSString stringWithFormat:@"%@ |",model.expert_label];
//        self.idImageView.hidden = NO; 
//        int n = (int)[tagsAry indexOfObject:model.expert_label];
//        self.idImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tags%d",n+1]];
//        [self layoutIfNeeded];
//        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(_idTagsLabel.mas_top).with.offset(-20/667.0*SCREEN_HEIGHT);
//        }];
    }else {
        self.talentView.hidden = YES;
        self.userProfile.hidden = YES;
//        self.idImageView.hidden = YES;
//        [self layoutIfNeeded];
//        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
//           make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-10/667.0*SCREEN_HEIGHT);
//        }];
    }
    if (model.summary.length == 0) {
        self.userLevelLabel.text = [NSString stringWithFormat:@"Lv%zi %@ | %@",[model.level intValue],model.label,@"这人好神秘，什么都不说"];
    }else{
        self.userLevelLabel.text = [NSString stringWithFormat:@"Lv%zi %@ | %@",[model.level intValue],model.label,model.summary];
    }
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.head_pic_url] placeholderImage:[UIImage imageNamed:@"personalDefaultBg"]];
}

//-(UIImageView *)idImageView{
//    if (!_idImageView) {
//        _idImageView = [[UIImageView alloc] init];
//    }
//    return _idImageView;
//}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        //_bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"headBg"];
    
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        shadow.opacity = 0;
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
        shadow.locations = @[@0.1,@0.4,@0.8,@1];
        [_bgImageView.layer addSublayer:shadow];
        
        [_bgImageView addSubview:self.userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.frame.size);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(0);
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(0);
        }];
//        
//        [_bgImageView addSubview:self.backBtn];
//        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30/667.0*SCREEN_HEIGHT, 20/667.0*SCREEN_HEIGHT));
//            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(79);
//            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(16);
//        }];
//
////        
//        [_bgImageView addSubview:self.moreBtn];
//        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 20));
//            make.right.mas_equalTo(_bgImageView.mas_right).with.offset(-16);
//            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(79);
//        }];
    }
    return _bgImageView;
}

//-(UIButton *)moreBtn{
//    if (!_moreBtn) {
//        _moreBtn = [[UIButton alloc] init];
//        [_moreBtn setImage:[UIImage imageNamed:@"more_filled"] forState:UIControlStateNormal];
//    }
//    return _moreBtn;
//}

-(UIButton *)focusOnBtn{
    if (!_focusOnBtn) {
        _focusOnBtn = [[UIButton alloc] init];
        [_focusOnBtn setImage:[UIImage imageNamed:@"my_fucos_w"] forState:UIControlStateNormal];
        [_focusOnBtn setImage:[UIImage imageNamed:@"l_fucos_r"] forState:UIControlStateSelected];
        _focusOnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _focusOnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        [_focusOnBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_focusOnBtn setTitle:@"已关注" forState:UIControlStateSelected];
        _focusOnBtn.layer.masksToBounds = YES;
        _focusOnBtn.layer.cornerRadius = 3;
        _focusOnBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _focusOnBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
        [_focusOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_focusOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _focusOnBtn;
}

-(UIButton *)directMessages{
    if (!_directMessages) {
        _directMessages = [[UIButton alloc] init];
        [_directMessages setImage:[UIImage imageNamed:@"my_edit"] forState:UIControlStateNormal];
        _directMessages.layer.masksToBounds = YES;
        _directMessages.layer.cornerRadius = 3;
        [_directMessages setTitle:@"私信" forState:UIControlStateNormal];
        _directMessages.titleLabel.font = [UIFont systemFontOfSize:13];
        _directMessages.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _directMessages.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        _directMessages.backgroundColor = [UIColor blackColor];
    }
    return _directMessages;
}

//-(UIButton *)backBtn{
//    if (!_backBtn) {
//        _backBtn = [[UIButton alloc] init];
//        _backBtn.userInteractionEnabled = YES;
//        _backBtn.clipsToBounds = YES;
//        _backBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//        [_backBtn setImage:[UIImage imageNamed:@"Fill 1"] forState:UIControlStateNormal];
//    }
//    return _backBtn;
//}



-(UILabel *)idTagsLabel{
    if (!_idTagsLabel) {
        _idTagsLabel = [[UILabel alloc] init];
        _idTagsLabel = [[UILabel alloc] init];
        _idTagsLabel.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _idTagsLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _idTagsLabel.font = [UIFont systemFontOfSize:13];
        }
        _idTagsLabel.textAlignment = NSTextAlignmentCenter;
        _idTagsLabel.clipsToBounds = YES;
        _idTagsLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _idTagsLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

-(UILabel *)userProfile{
    if (!_userProfile) {
        _userProfile = [[UILabel alloc] init];
        _userProfile.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _userProfile.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _userProfile.font = [UIFont systemFontOfSize:13];
        }
        _userProfile.textAlignment = NSTextAlignmentCenter;
        _userProfile.clipsToBounds = YES;
        _userProfile.numberOfLines = 0;
        _userProfile.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _userProfile;
}

-(UILabel *)userLevelLabel{
    if (!_userLevelLabel) {
        _userLevelLabel = [[UILabel alloc] init];
        _userLevelLabel.numberOfLines = 0;
        _userLevelLabel.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _userLevelLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _userLevelLabel.font = [UIFont systemFontOfSize:13];
        }
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
        if (IS_iOS9) {
            _nickName.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _nickName.font = [UIFont systemFontOfSize:14];
        }
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
