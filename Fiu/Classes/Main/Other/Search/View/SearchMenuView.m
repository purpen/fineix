//
//  SearchMenuView.m
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchMenuView.h"

@implementation SearchMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.line];
    }
    return self;
}

#pragma mark - 创建导航按钮
- (void)setSearchMenuView:(NSArray *)title {
    self.selectBtnTag = menuBtnTag;
    
    for (NSUInteger idx = 0; idx < title.count; ++ idx) {
        UIButton * menuBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / title.count) * idx, 0, (SCREEN_WIDTH / title.count), 44)];
        [menuBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [menuBtn setTitleColor:[UIColor colorWithHexString:fineixColor alpha:1] forState:(UIControlStateSelected)];
        if (IS_iOS9) {
            menuBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_SceneTitle];
        } else {
            menuBtn.titleLabel.font = [UIFont systemFontOfSize:Font_SceneTitle];
        }
        menuBtn.tag = idx + menuBtnTag;
        if (menuBtn.tag == menuBtnTag) {
            menuBtn.selected = YES;
            self.selectedBtn = menuBtn;
        }
        [menuBtn setTitle:title[idx] forState:(UIControlStateNormal)];
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:menuBtn];
    }
    [self addSubview:self.menuBottomline];
}

- (void)menuBtnClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(SearchMenuSeleted:)]) {
        [self changeMenuBottomLinePosition:button withIndex:(button.tag - menuBtnTag)];

        [self.delegate SearchMenuSeleted:(button.tag - menuBtnTag)];
    }
}

#pragma mark - 导航底部条
- (UILabel *)menuBottomline {
    if (!_menuBottomline) {
        _menuBottomline = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 3 / 2) - 20, 41, 53, 3)];
        _menuBottomline.backgroundColor = [UIColor colorWithHexString:fineixColor alpha:1];
    }
    return _menuBottomline;
}

//  改变底部导航条的位置
- (void)changeMenuBottomLinePosition:(UIButton *)menuBtn withIndex:(NSInteger)index {
    self.selectedBtn.selected = NO;
    menuBtn.selected = YES;
    self.selectedBtn = menuBtn;
    
    CGRect bottomLineRect = _menuBottomline.frame;
    bottomLineRect.origin.x = ((SCREEN_WIDTH / 3) / 3.5) + ((SCREEN_WIDTH / 3) * index);
    [UIView animateWithDuration:.2 animations:^{
        _menuBottomline.frame = bottomLineRect;
    }];
}

#pragma mark - 视图分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    }
    return _line;
}


@end
