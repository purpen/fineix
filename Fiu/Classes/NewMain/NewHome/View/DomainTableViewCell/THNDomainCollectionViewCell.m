//
//  THNDomainCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainCollectionViewCell.h"

@implementation THNDomainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        self.clipsToBounds = YES;
        [self setCellUI];
    }
    return self;
}

- (void)thn_setHelpUserDataModel:(HelpUserRow *)model {
    [self.image downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
}

- (void)thn_setDomainDataModel:(NiceDomainRow *)model {
    [self.image downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.title.text = model.title;
    
    [self.iconImage setImage:[UIImage imageNamed:@"icon_domain_tiyandian"] forState:(UIControlStateNormal)];
    self.subTitle.text = model.subTitle;
    [self setDomainRollView];
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.left.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self.mas_centerY).with.offset(0);
        make.centerX.equalTo(self);
    }];
}

- (void)setDomainRollView {
    [self addSubview:self.subTitle];
    [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@20);
        make.top.equalTo(self.mas_centerY).with.offset(5);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 16));
        make.left.top.equalTo(self).with.offset(10);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
    }
    return _image;
}

- (UIButton *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIButton alloc] init];
    }
    return _iconImage;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:22];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor whiteColor];
        _subTitle.font = [UIFont systemFontOfSize:16];
        _subTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitle;
}


@end
