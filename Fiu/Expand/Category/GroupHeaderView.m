//
//  GroupHeaderView.m
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GroupHeaderView.h"
#import "AllSceneViewController.h"

@implementation GroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        
        [self setUI];
        
    }
    return self;
}

- (void)addGroupHeaderViewIcon:(NSString *)image withTitle:(NSString *)title withSubtitle:(NSString *)subTitle {
    [self.icon setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    
    CGFloat titleLength = [title boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
    [_headerTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(titleLength + 15, 15));
    }];
    self.headerTitle.text = title;
    
    self.subTitle.text = subTitle;
}

- (void)setUI {
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 18));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.headerTitle];
    [_headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 15));
        make.centerY.equalTo(self);
        make.left.equalTo(self.icon.mas_right).with.offset(7);
    }];
    
    [self addSubview:self.subTitle];
    [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerTitle.mas_bottom).with.offset(0);
        make.left.equalTo(self.headerTitle.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

- (void)addLookMoreBtn {
    [self addSubview:self.moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}

- (UIButton *)icon {
    if (!_icon) {
        _icon = [[UIButton alloc] init];
    }
    return _icon;
}

- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] init];
        _headerTitle.textColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        _headerTitle.font = [UIFont systemFontOfSize:14];
    }
    return _headerTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        _subTitle.font = [UIFont systemFontOfSize:11];
    }
    return _subTitle;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"查看全部" forState:(UIControlStateNormal)];
        [_moreBtn setTitleColor:[UIColor colorWithHexString:@"#666666" alpha:1] forState:(UIControlStateNormal)];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn addTarget:self action:@selector(moreFiuScene) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreBtn;
}

- (void)moreFiuScene {
    AllSceneViewController * allSceneVC = [[AllSceneViewController alloc] init];
    [self.nav pushViewController:allSceneVC animated:YES];
}

@end
