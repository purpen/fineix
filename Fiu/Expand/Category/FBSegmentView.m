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

- (void)addViewBottomLine {
    UILabel *botLine = [[UILabel alloc] init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#666666" alpha:0.2];
    [self addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (void)set_menuItemTitle:(NSArray *)titleArr {
    self.title = titleArr;
    
    for (NSUInteger idx = 0; idx < titleArr.count; ++ idx) {
        UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/titleArr.count * idx, 0, SCREEN_WIDTH/titleArr.count, 44)];
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
        [self.btnMarr addObject:menuBtn];
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

#pragma mark - 更新导航栏的状态
- (void)updateMenuBtnState:(NSInteger)index {
    self.selectedBtn.selected = NO;
    UIButton * btn = self.btnMarr[index];
    btn.selected = YES;
    self.selectedBtn = btn;
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

- (NSArray *)title {
    if (!_title) {
        _title = [NSArray array];
    }
    return _title;
}

- (NSMutableArray *)btnMarr {
    if (!_btnMarr) {
        _btnMarr = [NSMutableArray array];
    }
    return _btnMarr;
}

@end
