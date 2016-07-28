//
//  ChildTagsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChildTagsCollectionViewCell.h"

@implementation ChildTagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:0.8].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - 标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _titleLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _titleLab.font = [UIFont systemFontOfSize:12];
        }
    }
    return _titleLab;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLab.textColor = [UIColor colorWithHexString:fineixColor];
        self.layer.borderColor = [UIColor colorWithHexString:fineixColor alpha:0.8].CGColor;
    } else {
        self.titleLab.textColor = [UIColor colorWithHexString:titleColor];
        self.layer.borderColor = [UIColor colorWithHexString:titleColor alpha:0.8].CGColor;
    }
}

@end
