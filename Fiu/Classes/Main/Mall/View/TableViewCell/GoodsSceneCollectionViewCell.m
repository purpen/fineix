//
//  GoodsSceneCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsSceneCollectionViewCell.h"

@implementation GoodsSceneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithHexString:titleColor].CGColor;
        
        [self addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@29);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:titleColor];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.title.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithHexString:fineixColor];
        self.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor colorWithHexString:titleColor].CGColor;
        self.title.textColor = [UIColor colorWithHexString:titleColor];
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
