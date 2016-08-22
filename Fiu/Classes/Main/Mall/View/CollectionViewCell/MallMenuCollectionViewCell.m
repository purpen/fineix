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
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.menuTitle];
    [_menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 15));
        make.centerX.centerY.equalTo(_menuImg);
    }];
    
    [self addSubview:self.botLine];
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 1));
        make.top.equalTo(_menuTitle.mas_bottom).with.offset(2);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - 导航图
- (UIImageView *)menuImg {
    if (!_menuImg) {
        _menuImg = [[UIImageView alloc] init];
        _menuImg.layer.cornerRadius = 60/2;
        _menuImg.layer.masksToBounds = YES;
        _menuImg.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    }
    return _menuImg;
}

#pragma mark - 导航标题
- (UILabel *)menuTitle {
    if (!_menuTitle) {
        _menuTitle = [[UILabel alloc] init];
        _menuTitle.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _menuTitle.font = [UIFont systemFontOfSize:12];
        _menuTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _menuTitle;
}

#pragma mark -
- (UILabel *)botLine {
    if (!_botLine) {
        _botLine = [[UILabel alloc] init];
        _botLine.backgroundColor = [UIColor whiteColor];
    }
    return _botLine;
}
@end
