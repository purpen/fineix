//
//  ChooseCategoryCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChooseCategoryCollectionViewCell.h"

@implementation ChooseCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        
        [self addSubview:self.categoryImg];
        [self addSubview:self.categoryTitle];
    }
    return self;
}

- (void)setCategoryData:(CatagoryFiuSceneModel *)model {
    self.categoryTitle.text = model.categoryTitle;
}

- (UIImageView *)categoryImg {
    if (!_categoryImg) {
        _categoryImg = [[UIImageView alloc] initWithFrame:self.bounds];
        _categoryImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _categoryImg;
}

- (UILabel *)categoryTitle {
    if (!_categoryTitle) {
        _categoryTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _categoryTitle.font = [UIFont systemFontOfSize:16];
        _categoryTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _categoryTitle;
}

@end
