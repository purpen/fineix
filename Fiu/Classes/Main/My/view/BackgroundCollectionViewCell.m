//
//  BackgroundCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BackgroundCollectionViewCell.h"
#import "Fiu.h"
#import "THNUserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TalentView.h"

@interface BackgroundCollectionViewCell ()

/**  */
@property (nonatomic, strong) CAGradientLayer *topShadowLayer;

@end

@implementation BackgroundCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.frame.size);
            make.top.mas_equalTo(self.mas_top).with.offset(0);
            make.left.mas_equalTo(self.mas_left).with.offset(0);
        }];
    }
    return self;
}

-(UIView *)userView{
    if (!_userView) {
        _userView = [[UIView alloc] init];
        
//        [_userView addSubview:self.lineView];
//        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(1, 12));
//            make.centerX.mas_equalTo(_userView.mas_centerX);
//            make.bottom.mas_equalTo(_userView.mas_bottom).with.offset(-49/667.0*SCREEN_HEIGHT);
//        }];
        
        [_userView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(SCREEN_WIDTH-60);
            make.centerX.mas_equalTo(_userView.mas_centerX).with.offset(0);
            make.bottom.mas_equalTo(_userView.mas_bottom).with.offset(-20/667.0*SCREEN_HEIGHT);
        }];
        
        [_userView addSubview:self.idTagsLabel];
        [_idTagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-12/667.0*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(_userView.mas_centerX).with.offset(0);
        }];
        
//        [_userView addSubview:self.idImageView];
//        [_idImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-12/667.0*SCREEN_HEIGHT);
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
        
        [_userView addSubview:self.userHeadBtn];
        [_userHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84/667.0*SCREEN_HEIGHT, 84/667.0*SCREEN_HEIGHT));
            make.centerX.mas_equalTo(_userView.mas_centerX);
            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-20/667.0*SCREEN_HEIGHT);
        }];
        
        [_userView addSubview:self.talentView];
        [_talentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_headView.mas_right).with.offset(-3/667.0*SCREEN_HEIGHT);
            make.bottom.mas_equalTo(_headView.mas_bottom).with.offset(-3/667.0*SCREEN_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(19/667.0*SCREEN_HEIGHT, 19/667.0*SCREEN_HEIGHT));
        }];
    }
    return _userView;
}

-(UIButton *)userHeadBtn{
    if (!_userHeadBtn) {
        _userHeadBtn = [[UIButton alloc] init];
    }
    return _userHeadBtn;
}

-(UILabel *)idTagsLabel{
    if (!_idTagsLabel) {
        _idTagsLabel = [[UILabel alloc] init];
        _idTagsLabel.textColor = [UIColor whiteColor];
        if (IS_iOS9) {
            _idTagsLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _idTagsLabel.font = [UIFont systemFontOfSize:13];
        }
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


-(void)setUI{
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    //更新头像
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userdata.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:userdata.head_pic_url] placeholderImage:[UIImage imageNamed:@"personalDefaultBg"]];
    self.nickName.text = userdata.nickname;
//    NSArray *tagsAry = [NSArray arrayWithObjects:@"大拿",@"行家",@"行摄家",@"艺术范",@"手艺人",@"人来疯",@"赎回自由身",@"职业buyer", nil];
    if ([userdata.is_expert isEqualToString:@"1"]) {
        self.talentView.hidden = NO;
//        self.userProfile.hidden = NO;
//        self.userProfile.text = entity.expert_info;
//        self.idImageView.hidden = YES;
        self.idTagsLabel.text = [NSString stringWithFormat:@"%@ | %@",userdata.expert_label,userdata.expert_info];
//        int n = (int)[tagsAry indexOfObject:entity.expert_label];
//        self.idImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tags%d",n+1]];
        [self layoutIfNeeded];
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_userProfile.mas_top).with.offset(-20/667.0*SCREEN_HEIGHT);
        }];
    }else {
        self.talentView.hidden = YES;
//        self.userProfile.hidden = YES;
//        self.idImageView.hidden = YES;
        [self layoutIfNeeded];
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.bottom.mas_equalTo(_userLevelLabel.mas_top).with.offset(-10/667.0*SCREEN_HEIGHT);
        }];
    }
    
    if (userdata.summary.length == 0) {
        self.userLevelLabel.text = [NSString stringWithFormat:@"Lv%zi %@ | %@",[userdata.level intValue],userdata.label,@"说说你是什么人，来自哪片山川湖海"];
    }else{
        self.userLevelLabel.text = [NSString stringWithFormat:@"Lv%zi %@ | %@",[userdata.level intValue],userdata.label,userdata.summary];
    }
    
    //self.userLevelLabel.text = [NSString stringWithFormat:@"%@ | V%d",entity.levelDesc,[entity.level intValue]];
}

//-(UIImageView *)idImageView{
//    if (!_idImageView) {
//        _idImageView = [[UIImageView alloc] init];
//    }
//    return _idImageView;
//}

-(CAGradientLayer *)topShadowLayer{
    if (!_topShadowLayer) {
        _topShadowLayer = [CAGradientLayer layer];
        _topShadowLayer.startPoint = CGPointMake(0, 0);
        _topShadowLayer.opacity = 0.5;
        _topShadowLayer.endPoint = CGPointMake(0, 1);
        _topShadowLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        _topShadowLayer.locations = @[@0];
        _topShadowLayer.frame = CGRectMake(0, SCREEN_WIDTH - 150, SCREEN_WIDTH, 150);
    }
    return _topShadowLayer;
}

#pragma mark - 个人信息背景图
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = [UIColor lightGrayColor];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"headBg"];
    
        //  添加渐变层
        [_bgImageView.layer addSublayer:self.topShadowLayer];
        
        
        [_bgImageView addSubview:self.userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.frame.size);
            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(0);
            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(0);
        }];
        
//        [_bgImageView addSubview:self.backBtn];
//        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//            make.top.mas_equalTo(_bgImageView.mas_top).with.offset(79);
//            make.left.mas_equalTo(_bgImageView.mas_left).with.offset(16);
//        }];
        
//        [_bgImageView addSubview:self.editBtn];
//        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//            //make.top.mas_equalTo(_bgImageView.mas_top).with.offset(35);
//            make.right.mas_equalTo(_bgImageView.mas_right).with.offset(-16);
//            make.centerY.mas_equalTo(_backBtn.mas_centerY);
//        }];
    }
    return _bgImageView;
}

//-(UIButton *)editBtn{
//    if (!_editBtn) {
//        _editBtn = [[UIButton alloc] init];
//        _editBtn.userInteractionEnabled = YES;
//        _editBtn.clipsToBounds = YES;
//        _editBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//        [_editBtn setImage:[UIImage imageNamed:@"SET"] forState:UIControlStateNormal];
//    }
//    return _editBtn;
//}

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
            _nickName.font = [UIFont systemFontOfSize:13];
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

-(TalentView *)talentView{
    if (!_talentView) {
        _talentView = [TalentView getTalentView];
    }
    return _talentView;
}

@end
