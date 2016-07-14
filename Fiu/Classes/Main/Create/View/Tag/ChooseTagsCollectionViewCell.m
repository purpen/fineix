//
//  ChooseTagsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChooseTagsCollectionViewCell.h"

@implementation ChooseTagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tagBtn];
        [_tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        [_tagBtn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        _tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_tagBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
        _tagBtn.userInteractionEnabled = NO;
    }
    return _tagBtn;
}

@end
