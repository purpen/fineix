//
//  UsedTagCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UsedTagCollectionViewCell.h"

@implementation UsedTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:.5].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tagLab];
        [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - 标签
- (UILabel *)tagLab {
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.textAlignment = NSTextAlignmentCenter;
        _tagLab.textColor = [UIColor colorWithHexString:titleColor];
        _tagLab.font = [UIFont systemFontOfSize:12];
    }
    return _tagLab;
}

- (void)setSelected:(BOOL)selected {
    if (selected == YES) {
        self.tagLab.textColor = [UIColor colorWithHexString:fineixColor];
        self.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
    } else if (selected == NO) {
        self.tagLab.textColor = [UIColor colorWithHexString:titleColor];
        self.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:.5].CGColor;
    }
}

@end
