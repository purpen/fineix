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

- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 15, 70, 70)];
        
    }
    return _filtersImageView;
}

- (UILabel *)filtersTitle {
    if (!_filtersTitle) {
        _filtersTitle = [[UILabel alloc] init];
        _filtersTitle.font = [UIFont systemFontOfSize:Font_filtersTitle];
        _filtersTitle.textColor = [UIColor whiteColor];
        _filtersTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    return _filtersTitle;
}

@end
