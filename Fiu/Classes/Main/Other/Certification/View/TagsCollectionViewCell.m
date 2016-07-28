//
//  TagsCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TagsCollectionViewCell.h"
#import "Fiu.h"
#import "UIImage+Helper.h"

@implementation TagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.tagBtn];
        [_tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@20);
            make.left.equalTo(self.mas_left).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        
    }
    return self;
}

#pragma mark - 标签
- (UIButton *)tagBtn {
    if (!_tagBtn) {
        _tagBtn = [[UIButton alloc] init];
        [_tagBtn setBackgroundImage:[UIImage resizedImage:@"tagBg_gray"] forState:(UIControlStateNormal)];
        [_tagBtn setBackgroundImage:[UIImage resizedImage:@"tagBg_yellow"] forState:UIControlStateHighlighted];
        [_tagBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _tagBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_tagBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
    }
    return _tagBtn;
}

@end
