//
//  MyQrCodeView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyQrCodeView.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MyQrCodeView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(662*0.5/667.0*SCREEN_HEIGHT, 819*0.5/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(self.mas_top).with.offset(310*0.5/667.0*SCREEN_HEIGHT-64);
        }];
    }
    return self;
}

-(void)setUI{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    self.nameLabel.text = entity.nickname;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"Circle + User"]];
    switch ([entity.sex intValue]) {
        case 0:
            self.sexLabel.text = @"保密";
            break;
        case 1:
            self.sexLabel.text = @"男";
            break;
        case 2:
            self.sexLabel.text = @"女";
            break;
        default:
            break;
    }
    self.adressLabel.text = [NSString stringWithFormat:@"%@ %@",entity.city,entity.address];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        
        [_bgView addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42/667.0*SCREEN_HEIGHT, 42/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(_bgView.mas_top).with.offset(45*0.5/667.0*SCREEN_HEIGHT);
            make.left.mas_equalTo(_bgView.mas_left).with.offset(17/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130*0.5/667.0*SCREEN_HEIGHT, 16/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(11/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(25/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.sexLabel];
        [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 15));
            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(13/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(25/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.mapImageView];
        [_mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9, 14));
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(11/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(7/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.adressLabel];
        [_adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 12));
            make.left.mas_equalTo(_mapImageView.mas_right).with.offset(3);
            make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(7/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.qrCodeImageView];
        [_qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(594*0.5/667.0*SCREEN_HEIGHT, 594*0.5/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_bgView.mas_left).with.offset(17/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(24/667.0*SCREEN_HEIGHT);
        }];
    }
    return _bgView;
}

-(UIImageView *)qrCodeImageView{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    return _qrCodeImageView;
}

-(UILabel *)adressLabel{
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc] init];
        _adressLabel.font = [UIFont systemFontOfSize:9];
    }
    return _adressLabel;
}

-(UIImageView *)mapImageView{
    if (!_mapImageView) {
        _mapImageView = [[UIImageView alloc] init];
        _mapImageView.image = [UIImage imageNamed:@"icon_city"];
    }
    return _mapImageView;
}

-(UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc] init];
        _sexLabel.font = [UIFont systemFontOfSize:10];
    }
    return _sexLabel;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _nameLabel;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 21/667.0*SCREEN_HEIGHT;
    }
    return _headImageView;
}

@end
