//
//  THNUserInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNUserInfoTableViewCell.h"

@implementation THNUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        [self setCellUI];
    }
    return self;
}

#pragma mark - setModel 
- (void)thn_setHomeSceneUserInfoData:(HomeSceneListRow *)userModel {
    [self.head sd_setImageWithURL:[NSURL URLWithString:userModel.user.avatarUrl]
                         forState:(UIControlStateNormal)
                 placeholderImage:[UIImage imageNamed:@""]];
    self.name.text = userModel.user.nickname;
    [self.time setTitle:userModel.createdAt forState:(UIControlStateNormal)];
    [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([self getTextSizeWidth:userModel.createdAt].width * 1.3));
    }];
    [self.address setTitle:userModel.address forState:(UIControlStateNormal)];
    if (userModel.user.isExpert == 1) {
        self.certificate.hidden = NO;
    } else {
        self.certificate.hidden = YES;
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
    [self addSubview:self.head];
    [_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.certificate];
    [_certificate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.right.equalTo(_head.mas_right).with.offset(2);
        make.bottom.equalTo(_head.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.top.equalTo(_head.mas_top).with.offset(0);
        make.left.equalTo(_head.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.follow];
    [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 12));
        make.left.equalTo(_name.mas_left).with.offset(0);
        make.bottom.equalTo(_head.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.address];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.equalTo(_time.mas_right).with.offset(5);
        make.bottom.equalTo(_time.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-90);
    }];
}

#pragma mark - init
- (UIButton *)head {
    if (!_head) {
        _head = [[UIButton alloc] init];
        _head.layer.cornerRadius = 30/2;
        _head.layer.masksToBounds = YES;
        [_head addTarget:self action:@selector(headClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _head;
}

- (void)headClick:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"打开个人中心"];
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

- (UIButton *)follow {
    if (!_follow) {
        _follow = [[UIButton alloc] init];
        _follow.layer.cornerRadius = 5.0f;
        _follow.layer.borderColor = [UIColor colorWithHexString:WHITE_COLOR alpha:0.6f].CGColor;
        _follow.layer.borderWidth = 0.5f;
        _follow.backgroundColor = [UIColor blackColor];
        [_follow setTitle:NSLocalizedString(@"User_follow", nil) forState:(UIControlStateNormal)];
        [_follow setTitle:NSLocalizedString(@"User_followDone", nil) forState:(UIControlStateSelected)];
        _follow.titleLabel.font = [UIFont systemFontOfSize:12];
        [_follow addTarget:self action:@selector(followClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _follow;
}

- (void)followClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        button.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
        button.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        button.layer.borderColor = [UIColor colorWithHexString:WHITE_COLOR alpha:0.6].CGColor;
        button.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
    }
}

- (UIButton *)time {
    if (!_time) {
        _time = [[UIButton alloc] init];
        [_time setImage:[UIImage imageNamed:@"icon_map_white"] forState:(UIControlStateNormal)];
        [_time setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _time.titleLabel.font = [UIFont systemFontOfSize:10];
        [_time setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        _time.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _time;
}

- (UIButton *)address {
    if (!_address) {
        _address = [[UIButton alloc] init];
        [_address setImage:[UIImage imageNamed:@"icon_map_white"] forState:(UIControlStateNormal)];
        [_address setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 0, 0))];
        _address.titleLabel.font = [UIFont systemFontOfSize:10];
        [_address setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
         _address.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_address addTarget:self action:@selector(addressClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _address;
}

- (void)addressClick:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"打开情景地图"];
}

@end
