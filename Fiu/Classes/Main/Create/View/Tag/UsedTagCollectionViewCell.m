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
        
        [self addSubview:self.tagLab];
        
    }
    return self;
}

#pragma mark - 标签
- (UILabel *)tagLab {
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] initWithFrame:self.bounds];
        _tagLab.textAlignment = NSTextAlignmentCenter;
        _tagLab.textColor = [UIColor colorWithHexString:titleColor];
        _tagLab.layer.cornerRadius = 4;
        _tagLab.layer.borderWidth = 1.0f;
        _tagLab.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:.5].CGColor;
        _tagLab.font = [UIFont systemFontOfSize:12];
    }
    return _tagLab;
}

- (void)setSelected:(BOOL)selected {
    if (selected == YES) {
        self.tagLab.textColor = [UIColor colorWithHexString:fineixColor];
        self.tagLab.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
    } else if (selected == NO) {
        self.tagLab.textColor = [UIColor colorWithHexString:titleColor];
        self.tagLab.layer.borderColor = [UIColor colorWithHexString:@"#979797" alpha:.5].CGColor;
    }
}

@end
