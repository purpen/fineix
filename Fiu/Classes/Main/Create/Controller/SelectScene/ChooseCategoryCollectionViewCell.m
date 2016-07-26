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
        
        [self addSubview:self.categoryImg];
        [self addSubview:self.categoryTitle];
    }
    return self;
}

- (void)setCategoryData:(CatagoryFiuSceneModel *)model {
    if (model.appCoverUrl.length > 0) {
        [self.categoryImg downloadImage:model.appCoverUrl place:[UIImage imageNamed:@""]];
    }
    self.categoryTitle.text = model.categoryTitle;
}

- (UIImageView *)categoryImg {
    if (!_categoryImg) {
        _categoryImg = [[UIImageView alloc] initWithFrame:self.bounds];
        _categoryImg.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1" alpha:1];
        _categoryImg.contentMode = UIViewContentModeScaleAspectFill;
        _categoryImg.clipsToBounds = YES;
        
        UIView * shadowView = [[UIView alloc] initWithFrame:_categoryImg.bounds];
        shadowView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        [_categoryImg addSubview:shadowView];
    }
    return _categoryImg;
}

- (UILabel *)categoryTitle {
    if (!_categoryTitle) {
        _categoryTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _categoryTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _categoryTitle.textAlignment = NSTextAlignmentCenter;
        _categoryTitle.textColor = [UIColor whiteColor];
    }
    return _categoryTitle;
}

@end
