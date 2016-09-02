//
//  THNHotUserCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHotUserCollectionViewCell.h"

@interface THNHotUserCollectionViewCell () {
    NSString *_userId;
}

@end

@implementation THNHotUserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)setHotUserListData:(HotUserListUser *)model {
    _userId = [NSString stringWithFormat:@"%zi", model.idField];
    [self.header downloadImage:model.mediumAvatarUrl place:[UIImage imageNamed:@""]];
    self.name.text = model.nickname;
    self.info.text = model.summary;
    
    if (model.isFollow == 0) {
        self.follow.selected = NO;
        self.follow.backgroundColor = [UIColor whiteColor];
        
    } else if (model.isFollow == 1) {
        self.follow.selected = YES;
        self.follow.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
    }
}

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.close];
    [_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.right.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(self.mas_top).with.offset(25);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@13);
        make.top.equalTo(_header.mas_bottom).with.offset(7);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-5);
    }];
    
    [self addSubview:self.info];
    [_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.top.equalTo(_name.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-5);
    }];
    
    [self addSubview:self.follow];
    [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 28));
        make.bottom.equalTo(self.mas_bottom).with.offset(-12);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - init
- (UIButton *)close {
    if (!_close) {
        _close = [[UIButton alloc] init];
        [_close setImage:[UIImage imageNamed:@"icon_close_gray"] forState:(UIControlStateNormal)];
        [_close addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _close;
}

- (void)closeBtnClick {
    self.colseTheHotUserBlock(_userId);
}

- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc] init];
        _header.layer.cornerRadius = 60/2;
        _header.layer.masksToBounds = YES;
        _header.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _header;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:12];
        _name.textColor = [UIColor colorWithHexString:@"#222222"];
        _name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}

- (UILabel *)info {
    if (!_info) {
        _info = [[UILabel alloc] init];
        _info.font = [UIFont systemFontOfSize:10];
        _info.textColor = [UIColor colorWithHexString:@"#666666"];
        _info.textAlignment = NSTextAlignmentCenter;
        _info.numberOfLines = 2;
    }
    return _info;
}

- (UIButton *)follow {
    if (!_follow) {
        _follow = [[UIButton alloc] init];
        _follow.layer.cornerRadius = 5.0f;
        _follow.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:1].CGColor;
        _follow.layer.borderWidth = 0.5f;
        _follow.backgroundColor = [UIColor whiteColor];
        _follow.titleLabel.font = [UIFont systemFontOfSize:12];
        [_follow setTitle:NSLocalizedString(@"User_follow", nil) forState:(UIControlStateNormal)];
        [_follow setTitle:NSLocalizedString(@"User_followDone", nil) forState:(UIControlStateSelected)];
        [_follow setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:(UIControlStateNormal)];
        [_follow setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateSelected)];
        [_follow setImage:[UIImage imageNamed:@"icon_success"] forState:(UIControlStateSelected)];
        [_follow setImageEdgeInsets:(UIEdgeInsetsMake(0, -6, 0, 0))];
        
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
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"followTheUser" object:_userId];
        
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        
        button.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:1].CGColor;
        button.backgroundColor = [UIColor colorWithHexString:WHITE_COLOR];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelFollowTheUser" object:_userId];
    }
}

@end
