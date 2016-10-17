//
//  FBTabBarItemBadgeBtn.m
//  Fiu
//
//  Created by FLYang on 2016/10/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBTabBarItemBadgeBtn.h"
#import "UIImage+Helper.h"

@implementation FBTabBarItemBadgeBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self thn_setViewUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self thn_setViewUI];
    }
    return self;
}

- (void)thn_showBadgeValue:(NSString *)value {
    self.likeNum.text = value;
}

- (void)thn_setViewUI {
    [self addSubview:self.backImage];
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.likeIcon];
    [_likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 13));
        make.left.equalTo(self.mas_left).with.offset(7);
        make.centerY.equalTo(self.mas_centerY).with.offset(-2);
    }];
    
    [self addSubview:self.likeNum];
    [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17);
        make.left.equalTo(_likeIcon.mas_right).with.offset(2);
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.centerY.equalTo(self.mas_centerY).with.offset(-2);
    }];
    
//    [self addSubview:self.fansIcon];
    
//    [self addSubview:self.fansNum];
}

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.image = [UIImage resizedImage:@"icon_badge" xPos:0.3 yPos:0];
    }
    return _backImage;
}

- (UIImageView *)likeIcon {
    if (!_likeIcon) {
        _likeIcon = [[UIImageView alloc] init];
        [_likeIcon setImage:[UIImage imageNamed:@"icon_badge_like"]];
    }
    return _likeIcon;
}

- (UILabel *)likeNum {
    if (!_likeNum) {
        _likeNum = [[UILabel alloc] init];
        _likeNum.textColor = [UIColor whiteColor];
        _likeNum.font = [UIFont systemFontOfSize:12];
        _likeNum.textAlignment = NSTextAlignmentCenter;
    }
    return _likeNum;
}

- (UIImageView *)fansIcon {
    if (!_fansIcon) {
        _fansIcon = [[UIImageView alloc] init];
        [_fansIcon setImage:[UIImage imageNamed:@"icon_badge_fans"]];
    }
    return _fansIcon;
}

- (UILabel *)fansNum {
    if (!_fansNum) {
        _fansNum = [[UILabel alloc] init];
    }
    return _fansNum;
}


@end
