//
//  MallMenuCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallMenuCollectionViewCell.h"

@implementation MallMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setCellViewUI];
        
    }
    return self;
}

- (void)setCategoryData:(CategoryRow *)model {
    [self.menuImg downloadImage:model.appCoverUrl place:[UIImage imageNamed:@""]];
    self.menuTitle.text = model.title;
}

#pragma mark -
- (void)setCellViewUI {
    [self addSubview:self.menuImg];
    [_menuImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(self.mas_top).with.offset(15);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.menuTitle];
    [_menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 15));
        make.top.equalTo(_menuImg.mas_bottom).with.offset(15);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - 导航图
- (UIImageView *)menuImg {
    if (!_menuImg) {
        _menuImg = [[UIImageView alloc] init];
        _menuImg.layer.cornerRadius = 25;
        _menuImg.layer.masksToBounds = YES;
    }
    return _menuImg;
}

#pragma mark - 导航标题
- (UILabel *)menuTitle {
    if (!_menuTitle) {
        _menuTitle = [[UILabel alloc] init];
        _menuTitle.textColor = [UIColor colorWithHexString:titleColor alpha:1];
        if (IS_iOS9) {
            _menuTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _menuTitle.font = [UIFont systemFontOfSize:12];
        }
        _menuTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _menuTitle;
}

@end
