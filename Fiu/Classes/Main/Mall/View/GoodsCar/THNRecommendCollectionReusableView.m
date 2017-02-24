//
//  THNRecommendCollectionReusableView.m
//  Fiu
//
//  Created by FLYang on 2017/2/21.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRecommendCollectionReusableView.h"

@implementation THNRecommendCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        [self addSubview:self.textlabel];
        [_textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(self).with.offset(0);
            make.top.equalTo(self.mas_top).with.offset(8);
        }];
        
        [self setLine];
    }
    return self;
}

- (UILabel *)textlabel {
    if (!_textlabel) {
        _textlabel = [[UILabel alloc] init];
        _textlabel.text = @"猜你喜欢";
        _textlabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _textlabel.font = [UIFont systemFontOfSize:14];
        _textlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textlabel;
}

- (void)setLine {
    for (NSInteger idx = 0; idx < 2; ++ idx) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 0.5));
            make.left.equalTo(self.mas_left).with.offset(30 + ((SCREEN_WIDTH - 160) * idx));
            make.centerY.equalTo(self).with.offset(4);
        }];
    }
}

@end
