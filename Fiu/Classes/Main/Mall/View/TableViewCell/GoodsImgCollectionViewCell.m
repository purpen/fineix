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
    }
    return self;
}

#pragma mark - 商品图片
- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 265, 150)];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        _img.clipsToBounds  = YES;
    }
    return _img;
}

@end
