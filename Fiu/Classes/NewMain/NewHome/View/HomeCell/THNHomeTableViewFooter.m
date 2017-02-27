//
//  THNHomeTableViewFooter.m
//  Fiu
//
//  Created by FLYang on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNHomeTableViewFooter.h"

@implementation THNHomeTableViewFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self addSubview:self.bottomImage];
        [_bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
    }
    return self;
}


- (UIImageView *)bottomImage {
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc] init];
        _bottomImage.image = [UIImage imageNamed:@"icon_logo_bottom"];
        _bottomImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomImage;
}

@end
