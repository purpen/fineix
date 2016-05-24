//
//  ShareStyleCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShareStyleCollectionViewCell.h"

@implementation ShareStyleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.styleImg];
        [_styleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).with.offset(0);
            make.top.equalTo(self.mas_top).with.offset(15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        }];
        
        [self addSubview:self.bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@3);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.left.right.equalTo(self).with.offset(0);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.bottomLine.hidden = NO;
    } else {
        self.bottomLine.hidden = YES;
    }
}

- (UIImageView *)styleImg {
    if (!_styleImg) {
        _styleImg = [[UIImageView alloc] init];
    }
    return _styleImg;
}

- (UILabel *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:fineixColor];
        _bottomLine.hidden = YES;
    }
    return _bottomLine;
}

@end