//
//  THNUserInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNUserInfoTableViewCell.h"
#import "THNHotUserCollectionViewCell.h"
#import "HotUserListUser.h"
#import "HomePageViewController.h"
#import "THNLoginRegisterViewController.h"
#import "THNUserData.h"

static NSString *const hotUserCellId = @"HotUserCellId";

@interface THNUserInfoTableViewCell () {
    NSString *_userId;
    BOOL _isLogin;
    BOOL _isUserSelf;
}

@end

@implementation THNUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        self.clipsToBounds = YES;
        [self setCellUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSceneListData:) name:@"refreshSceneData" object:nil];
    }
    return self;
}

#pragma mark - 刷新用户状态
- (void)refreshSceneListData:(NSNotification *)notification {
    if (_isLogin == YES) {
        _isLogin = NO;
    } else if (_isLogin == NO) {
        _isLogin = YES;
    }
}

-(void)setModel:(HomeSceneListRow *)userModel{
    _userModel = userModel;
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    _isLogin = userdata.isLogin;
    [self.head downloadImage:userModel.user.avatarUrl place:[UIImage imageNamed:@""]];
    self.name.text = userModel.user.nickname;
    
    [self.address setTitle:[NSString stringWithFormat:@"%@ %@", userModel.city, userModel.address]
                                             forState:(UIControlStateNormal)];
    if (userModel.user.isExpert == 1) {
        self.certificate.hidden = NO;
    } else {
        self.certificate.hidden = YES;
    }

    _userId = userModel.user._id;
}

#pragma mark - setModel
- (void)thn_setHomeSceneUserInfoData:(HomeSceneListRow *)userModel userId:(NSString *)userID isLogin:(BOOL)login {
    _isLogin = login;
    self.name.text = userModel.user.nickname;
    [self.head downloadImage:userModel.user.avatarUrl place:[UIImage imageNamed:@""]];
    [self.address setTitle:[NSString stringWithFormat:@"%@ %@", userModel.city, userModel.address]
                  forState:(UIControlStateNormal)];

    if (userModel.address.length == 0) {
        self.address.hidden = YES;
    } else {
        self.address.hidden = NO;
    }
    
    if (userModel.user.isExpert == 1) {
        self.certificate.hidden = NO;
    } else {
        self.certificate.hidden = YES;
    }

    _userId = [NSString stringWithFormat:@"%zi", userModel.userId];
    if ([_userId isEqualToString:@"0"]) {
        _userId = userModel.user._id;
    }
}

- (CGSize)getTextSizeWidth:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.top.bottom.equalTo(self).with.offset(0);
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        
        [_bottomView addSubview:self.head];
        [_head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(_bottomView.mas_left).with.offset(15);
            make.centerY.equalTo(_bottomView);
        }];
        
        [_bottomView addSubview:self.certificate];
        [_certificate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.right.equalTo(_head.mas_right).with.offset(2);
            make.bottom.equalTo(_head.mas_bottom).with.offset(0);
        }];
        
        [_bottomView addSubview:self.name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 15));
            make.top.equalTo(_head.mas_top).with.offset(0);
            make.left.equalTo(_head.mas_right).with.offset(10);
        }];
        
//        [_bottomView addSubview:self.follow];
//        [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(70, 26));
//            make.right.equalTo(_bottomView.mas_right).with.offset(-15);
//            make.centerY.equalTo(_bottomView);
//        }];
//        
//        [_bottomView addSubview:self.time];
//        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(80, 12));
//            make.left.equalTo(_name.mas_left).with.offset(0);
//            make.bottom.equalTo(_head.mas_bottom).with.offset(0);
//        }];
        
        [_bottomView addSubview:self.address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.equalTo(_name.mas_left).with.offset(0);
            make.bottom.equalTo(_head.mas_bottom).with.offset(0);
            make.right.equalTo(_bottomView.mas_right).with.offset(-90);
        }];
    }
    return _bottomView;
}

- (UIImageView *)head {
    if (!_head) {
        _head = [[UIImageView alloc] init];
        _head.layer.cornerRadius = 30/2;
        _head.layer.masksToBounds = YES;
        _head.contentMode = UIViewContentModeScaleAspectFill;
        _head.userInteractionEnabled = YES;
        UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
        [_head addGestureRecognizer:headTap];
    }
    return _head;
}

- (void)headClick:(UITapGestureRecognizer *)tap {
    if (_userId.length) {
        HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
        userHomeVC.userId = _userId;
        userHomeVC.type = @2;
        userHomeVC.isMySelf = _isUserSelf;
        [self.nav pushViewController:userHomeVC animated:YES];
    }
}

- (UIImageView *)certificate {
    if (!_certificate) {
        _certificate = [[UIImageView alloc] init];
        _certificate.image = [UIImage imageNamed:@"user_jiaV"];
    }
    return _certificate;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _name.font = [UIFont systemFontOfSize:12];
    }
    return _name;
}

- (UIButton *)address {
    if (!_address) {
        _address = [[UIButton alloc] init];
        [_address setImage:[UIImage imageNamed:@"icon_location"] forState:(UIControlStateNormal)];
        [_address setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _address.titleLabel.font = [UIFont systemFontOfSize:10];
        [_address setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
         _address.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_address addTarget:self action:@selector(addressClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _address;
}

- (void)addressClick:(UIButton *)button {
//    [SVProgressHUD showSuccessWithStatus:@"打开情景地图"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSceneData" object:nil];
}

@end
