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
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        [self addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(662*0.5/667.0*SCREEN_HEIGHT, 819*0.5/667.0*SCREEN_HEIGHT));
            make.top.mas_equalTo(self.mas_top).with.offset(91/667.0*SCREEN_HEIGHT);
        }];
    }
    return self;
}

-(void)setUI{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    self.nameLabel.text = entity.nickname;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    switch ([entity.sex intValue]) {
        case 0:
            break;
        case 1:
            self.sexImageView.image = [UIImage imageNamed:@"man"];
            break;
        case 2:
            self.sexImageView.image = [UIImage imageNamed:@"woman"];
            break;
        default:
            break;
    }
    if (entity.prin) {
        self.adressLabel.text = [NSString stringWithFormat:@"%@ %@",entity.prin,entity.city];
    }
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
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(11/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_bgView.mas_top).with.offset(25/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.sexImageView];
        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.left.mas_equalTo(_nameLabel.mas_right).with.offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        }];
        
        [_bgView addSubview:self.adressLabel];
        [_adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 12));
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(11/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(8);
        }];
        
        [_bgView addSubview:self.qrCodeImageView];
        [_qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(584*0.5/667.0*SCREEN_HEIGHT, 584*0.5/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_bgView.mas_left).with.offset(22/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [_bgView addSubview:self.tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_qrCodeImageView.mas_bottom).with.offset(15/667.0*SCREEN_WIDTH);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
    }
    return _bgView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = [UIColor colorWithHexString:fineixColor];
        _tipLabel.text = @"扫描我的二维码关注我的Fiu";
    }
    return _tipLabel;
}

-(UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
    }
    return _sexImageView;
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
        _adressLabel.font = [UIFont systemFontOfSize:11];
        _adressLabel.textColor = [UIColor grayColor];
    }
    return _adressLabel;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
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
