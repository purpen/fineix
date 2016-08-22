//
//  FBSegmentView.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSegmentView.h"

static NSInteger const menuBtnTag = 642;

@implementation FBSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)set_menuItemTitle:(NSArray *)titleArr {
    for (NSUInteger idx = 0; idx < titleArr.count; ++ idx) {
        UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4 - 25) + (SCREEN_WIDTH/2 * idx), 0, 50, 44)];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [menuBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        [menuBtn setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:(UIControlStateSelected)];
        [menuBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
        menuBtn.tag = menuBtnTag + idx;
        if (menuBtn.tag == menuBtnTag) {
            menuBtn.selected = YES;
            self.selectedBtn = menuBtn;
        }
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:menuBtn];
    }

}

- (void)menuBtnClick:(UIButton *)button {
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    NSInteger index = button.tag - menuBtnTag;
    if ([self.delegate respondsToSelector:@selector(menuItemSelected:)]) {
        [self.delegate menuItemSelected:index];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.bottomLine.frame = CGRectMake((SCREEN_WIDTH/4 - 25) + (SCREEN_WIDTH/2 * index), 42, 50, 2);
    }];
}

- (UILabel *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4 - 25), 42, 50, 2)];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
    }
    return _bottomLine;
}

- (void)set_showBottomLine:(BOOL)show {
    if (show == YES) {
        [self addSubview:self.bottomLine];
    }
}

@end
