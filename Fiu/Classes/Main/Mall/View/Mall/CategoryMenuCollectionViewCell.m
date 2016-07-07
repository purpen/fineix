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
    [self.categoryImg downloadImage:model.appCoverUrl place:[UIImage imageNamed:@""]];
    self.categoryLab.text = model.title;
}

- (UIImageView *)categoryImg {
    if (!_categoryImg) {
        _categoryImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 50)];
        _categoryImg.layer.cornerRadius = 25;
        _categoryImg.layer.masksToBounds = YES;
    }
    return _categoryImg;
}

- (UILabel *)categoryLab {
    if (!_categoryLab) {
        _categoryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 50, 12)];
        _categoryLab.textAlignment = NSTextAlignmentCenter;
        _categoryLab.font = [UIFont systemFontOfSize:12];
    }
    return _categoryLab;
}

@end
