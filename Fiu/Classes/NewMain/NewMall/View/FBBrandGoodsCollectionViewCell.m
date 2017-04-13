//
//  FBBrandGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBrandGoodsCollectionViewCell.h"
#import <ZYCornerRadius/ZYCornerRadius-umbrella.h>

@implementation FBBrandGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.0f];
        [self addSubview:self.brandImg];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)thn_setBrandData:(BrandListModel *)model {
    self.titleLabel.text = model.title;
    
    [self.brandImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    [self.brandImg zy_cornerRadiusRoundingRect];
    [self.brandImg zy_attachBorderWidth:0.5 color:[UIColor colorWithHexString:@"#666666" alpha:.3]];
}

/**
 品牌logo
 */
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 0, self.bounds.size.width - 15, self.bounds.size.width - 15)];
        _brandImg.contentMode = UIViewContentModeScaleAspectFit;
        _brandImg.clipsToBounds = YES;
    }
    return _brandImg;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width - 10, self.bounds.size.width, 15)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

@end
