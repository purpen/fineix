//
//  FBBrandGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBrandGoodsCollectionViewCell.h"

@implementation FBBrandGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#666666" alpha:.3].CGColor;
        
        [self addSubview:self.brandImg];
        
    }
    return self;
}

- (void)thn_setBrandData:(BrandListModel *)model {
    [self.brandImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
}

#pragma mark - 品牌logo
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] initWithFrame:self.bounds];
        _brandImg.contentMode = UIViewContentModeScaleAspectFit;
        _brandImg.clipsToBounds = YES;
        _brandImg.backgroundColor = [UIColor whiteColor];
    }
    return _brandImg;
}

@end
