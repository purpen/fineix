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
        make.centerX.centerY.equalTo(self);
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

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:22];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

@end
