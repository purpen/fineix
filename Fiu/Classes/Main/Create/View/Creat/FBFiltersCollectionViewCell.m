//
//  FBFiltersCollectionViewCell.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBFiltersCollectionViewCell.h"

@implementation FBFiltersCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.filtersImageView];
        
        [self addSubview:self.filtersTitle];
        [_filtersTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 15));
            make.top.equalTo(self.filtersImageView.mas_bottom).with.offset(10);
            make.centerX.equalTo(self.filtersImageView);
        }];
        
    }
    return self;
}

//- (void)thn_getFilterImage:(UIImage *)image {
//    self.filtersImageView.alpha = 0.0f;
//    self.filtersImageView.image = image;
//    [UIView animateWithDuration:.5 animations:^{
//        self.filtersImageView.alpha = 1.0f;
//    }];
//}

#pragma mark - 滤镜图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 15, 70, 70)];
        _filtersImageView.layer.borderColor = [UIColor colorWithHexString:fineixColor alpha:1].CGColor;
    }
    return _filtersImageView;
}

#pragma mark 选中的状态
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.filtersImageView.layer.borderWidth = selected ? 2 : 0;
    self.filtersTitle.textColor = [UIColor colorWithHexString:fineixColor alpha:1];
    
    if (selected == NO) {
        self.filtersTitle.textColor = [UIColor whiteColor];
    }
}

#pragma mark - 滤镜标题
- (UILabel *)filtersTitle {
    if (!_filtersTitle) {
        _filtersTitle = [[UILabel alloc] init];
        _filtersTitle.font = [UIFont systemFontOfSize:12];
        _filtersTitle.textColor = [UIColor whiteColor];
        _filtersTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    return _filtersTitle;
}

@end
