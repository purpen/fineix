//
//  FBKeyboradToolbar.m
//  Fiu
//
//  Created by FLYang on 16/8/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBKeyboradToolbar.h"

@implementation FBKeyboradToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.leftBarItem];
        [self addSubview:self.rightBarItem];
    }
    return self;
}

- (void)thn_setRightBarItemContent:(NSString *)content {
    [self.rightBarItem setTitle:[NSString stringWithFormat:@"#%@ ", content] forState:(UIControlStateNormal)];
}

- (UIButton *)leftBarItem {
    if (!_leftBarItem) {
        _leftBarItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_leftBarItem setTitle:@"#" forState:(UIControlStateNormal)];
        [_leftBarItem setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _leftBarItem.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftBarItem addTarget:self action:@selector(leftBarItemClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBarItem;
}

- (void)leftBarItemClick {
    if ([self.thn_delegate respondsToSelector:@selector(thn_keyboardLeftBarItemAction)]) {
        [self.thn_delegate thn_keyboardLeftBarItemAction];
    }
}

- (UIButton *)rightBarItem {
    if (!_rightBarItem) {
        _rightBarItem = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 0, 200, 44)];
        [_rightBarItem setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _rightBarItem.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBarItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightBarItem addTarget:self action:@selector(rightBarItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBarItem;
}

- (void)rightBarItemClick:(UIButton *)button {
    if ([self.thn_delegate respondsToSelector:@selector(thn_keyboardRightBarItemAction:)]) {
        [self.thn_delegate thn_keyboardRightBarItemAction:button.titleLabel.text];
    }
}

@end
