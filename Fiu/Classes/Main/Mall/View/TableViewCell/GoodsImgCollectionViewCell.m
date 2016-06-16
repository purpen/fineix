//
//  GoodsImgCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsImgCollectionViewCell.h"

@implementation GoodsImgCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.img];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@150);
            make.top.left.equalTo(self).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
        }];
        
    }
    return self;
}

#pragma mark - 商品图片
- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        _img.clipsToBounds  = YES;
        [_img setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    return _img;
}

@end
