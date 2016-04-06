//
//  GroupHeaderView.m
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GroupHeaderView.h"

@implementation GroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUI];
        
    }
    return self;
}

- (void)addGroupHeaderViewIcon:(NSString *)image withTitle:(NSString *)title withSubtitle:(NSString *)subTitle {
    self.icon.image = [UIImage imageNamed:image];
    self.Headertitle.text = title;
    self.Subtitle.text = subTitle;
}

- (void)setUI {
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 18));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.Headertitle];
    [_Headertitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 15));
        make.centerY.equalTo(self);
        make.left.equalTo(self.icon.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.Subtitle];
    [_Subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.Headertitle.mas_bottom).with.offset(0);
        make.left.equalTo(self.Headertitle.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}

- (UILabel *)Headertitle {
    if (!_Headertitle) {
        _Headertitle = [[UILabel alloc] init];
        _Headertitle.textColor = [UIColor colorWithHexString:titleColor alpha:1];
        _Headertitle.font = [UIFont systemFontOfSize:14];
    }
    return _Headertitle;
}

- (UILabel *)Subtitle {
    if (!_Subtitle) {
        _Subtitle = [[UILabel alloc] init];
        _Subtitle.textColor = [UIColor colorWithHexString:tabBarTitle alpha:1];
        _Subtitle.font = [UIFont systemFontOfSize:11];
    }
    return _Subtitle;
}

@end
