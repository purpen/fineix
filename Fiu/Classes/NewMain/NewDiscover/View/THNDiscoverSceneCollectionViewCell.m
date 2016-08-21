//
//  THNDiscoverSceneCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverSceneCollectionViewCell.h"

@implementation THNDiscoverSceneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)thn_setSceneData:(NSString *)image {
    [self.image downloadImage:image place:[UIImage imageNamed:@""]];
}

#pragma mark - setUI 
- (void)setViewUI {
    [self addSubview:self.image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.top.left.right.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.userInfo];
    [_userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, 35));
        make.left.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.userHeader];
    [_userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(_userInfo);
    }];
    
    [self addSubview:self.likeBtn];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 35));
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.centerY.equalTo(_userInfo);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userHeader.mas_right).with.offset(5);
        make.right.equalTo(_likeBtn.mas_left).with.offset(-10);
        make.centerY.equalTo(_userInfo);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor orangeColor];
    }
    return _image;
}

- (UIView *)userInfo {
    if (!_userInfo) {
        _userInfo = [[UIView alloc] init];
        _userInfo.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
    }
    return _userInfo;
}

- (UIImageView *)userHeader {
    if (!_userHeader) {
        _userHeader = [[UIImageView alloc] init];
        _userHeader.layer.cornerRadius = 21/2;
        _userHeader.layer.masksToBounds = YES;
        _userHeader.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _userHeader;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _userName.font = [UIFont systemFontOfSize:10];
        _userName.text = @"Fynn的昵称";
    }
    return _userName;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_zan_white"] forState:(UIControlStateNormal)];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_yizan"] forState:(UIControlStateSelected)];
        [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _likeBtn;
}

- (void)likeClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
        
    } else if (button.selected == YES) {
        button.selected = NO;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        scaleAnimation.springBounciness = 10.f;
        scaleAnimation.springSpeed = 10.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    }
}

@end
