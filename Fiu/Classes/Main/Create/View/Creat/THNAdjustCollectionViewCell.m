//
//  THNAdjustCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAdjustCollectionViewCell.h"

@implementation THNAdjustCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCellUI];
    }
    return self;
}

- (void)thn_getAdjustIconImage:(NSString *)image {
    _adjustImage.image = [UIImage imageNamed:image];
}

- (void)thn_getAdjustTitle:(NSString *)title {
    self.adjustTitle.text = title;
}

- (void)setCellUI {
    [self addSubview:self.adjustImage];
    [_adjustImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.bottom.equalTo(self.mas_centerY).with.offset(0);
        make.centerX.equalTo(self);
    }];

    [self addSubview:self.adjustTitle];
    [_adjustTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.top.equalTo(_adjustImage.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];

}

- (UIImageView *)adjustImage {
    if (!_adjustImage) {
        _adjustImage = [[UIImageView alloc] init];
        _adjustImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _adjustImage;
}

- (UILabel *)adjustTitle {
    if (!_adjustTitle) {
        _adjustTitle = [[UILabel alloc] init];
        _adjustTitle.textColor = [UIColor whiteColor];
        _adjustTitle.font = [UIFont systemFontOfSize:12];
        _adjustTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _adjustTitle;
}


@end
