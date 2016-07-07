//
//  CategoryMenuCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CategoryMenuCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"

@implementation CategoryMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.categoryImg];
        [self addSubview:self.categoryLab];
        
    }
    return self;
}

- (void)setCategoryData:(CategoryRow *)model {
    [self.categoryImg downloadImage:model.backUrl place:[UIImage imageNamed:@""]];
    self.categoryLab.text = model.title;
}

- (UIImageView *)categoryImg {
    if (!_categoryImg) {
        _categoryImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
        _categoryImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _categoryImg;
}

- (UILabel *)categoryLab {
    if (!_categoryLab) {
        _categoryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 50, 12)];
        _categoryLab.textAlignment = NSTextAlignmentCenter;
        _categoryLab.font = [UIFont systemFontOfSize:12];
    }
    return _categoryLab;
}

@end
