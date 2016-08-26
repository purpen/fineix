//
//  FBMenuView.m
//  Fiu
//
//  Created by FLYang on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBMenuView.h"

@implementation FBMenuView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.btnMarr = [[NSMutableArray alloc] init];
        [self addSubview:self.viewLine];
        
    }
    return self;
}

#pragma mark - 滑动视图
- (UIScrollView *)menuRollView {
    if (!_menuRollView) {
        _menuRollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _menuRollView.showsVerticalScrollIndicator = NO;
        _menuRollView.showsHorizontalScrollIndicator = NO;
    }
    return _menuRollView;
}

#pragma mark - 视图分割线
- (UILabel *)viewLine {
    if (!_viewLine) {
        _viewLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        _viewLine.backgroundColor = [UIColor colorWithHexString:@"#F0F0F1" alpha:1];
    }
    return _viewLine;
}

#pragma mark - 底部导航线
- (void)showBottomLine:(CGFloat)width {
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(10, 41, width - 20, 3)];
    self.line.backgroundColor = [UIColor colorWithHexString:fineixColor];
    [self.menuRollView addSubview:self.line];
}

#pragma mark - 动态获取按钮宽度
- (NSArray *)getMenuBtnWidthByTitle:(NSArray *)titles {
    NSMutableArray * allWidths = [[NSMutableArray alloc] init];
    UIFont * font = [UIFont systemFontOfSize:14];
    for (NSString * title in titles) {
        CGSize size = [title sizeWithAttributes:@{font:NSFontAttributeName}];
        NSNumber * width = [NSNumber numberWithFloat:size.width + 40];
        [allWidths addObject:width];
    }
    return allWidths;
}

#pragma mark - 获取菜单视图的宽度
- (CGFloat)getMenuViewWidth:(NSArray *)widths {
    CGFloat menuBtnW = 0;
    [self addSubview:self.menuRollView];
    
    for (NSUInteger idx = 0; idx < self.menuTitle.count; ++ idx) {
        UIButton * menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(menuBtnW, 0, [widths[idx] floatValue], 44)];
        [menuBtn setTitle:self.menuTitle[idx] forState:(UIControlStateNormal)];
        [menuBtn setTitleColor:[UIColor colorWithHexString:self.defaultColor] forState:(UIControlStateNormal)];
        [menuBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateSelected)];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        menuBtn.tag = menuBtnTag + idx;
        if (menuBtn.tag == menuBtnTag) {
            menuBtn.selected = YES;
            self.selectedBtn = menuBtn;
        }
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.menuRollView addSubview:menuBtn];
        [self.btnMarr addObject:menuBtn];
        menuBtnW += [widths[idx] floatValue];
    }
    
    [self showBottomLine:[widths[0] floatValue]];
    return menuBtnW;
}

#pragma mark - 点击导航按钮
- (void)menuBtnClick:(UIButton *)button {
    self.nowSelectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    NSInteger index = [self.btnMarr indexOfObject:button];
    if ([_delegate respondsToSelector:@selector(menuItemSelectedWithIndex:)]) {
        [_delegate menuItemSelectedWithIndex:index];
    }
    
    [self updateMenuBtnState:index];
}

#pragma mark - 更新导航栏的状态 
- (void)updateMenuBtnState:(NSInteger)index {
    self.selectedBtn.selected = NO;
    UIButton * btn = self.btnMarr[index];
    btn.selected = YES;
    self.nowSelectedBtn = btn;
    self.selectedBtn = self.nowSelectedBtn;
    
    if (self.btnMarr.count > 4) {
        //  改变导航视图的偏移量，判断使按钮保持居中显示
        if (btn.center.x > self.menuRollView.bounds.size.width/2) {
            CGFloat pointX = btn.center.x - self.menuRollView.bounds.size.width/2.0;
            CGFloat maxWidth = self.menuRollView.contentSize.width - self.menuRollView.bounds.size.width;
            if (pointX > maxWidth) {
                [self.menuRollView setContentOffset:CGPointMake(maxWidth, 0) animated:YES];
                
            } else {
                [self.menuRollView setContentOffset:CGPointMake(pointX, 0) animated:YES];
            }
            
        } else {
            [self.menuRollView setContentOffset:CGPointZero animated:YES];
        }
        
    } else {
         [self.menuRollView setContentOffset:CGPointZero animated:YES];
    }

    
    //  移动底部导航条
    [UIView animateWithDuration:0.2f animations:^{
        self.line.frame = CGRectMake(btn.frame.origin.x + 10, self.line.frame.origin.y, [self.widthArr[index] floatValue] - 20, self.line.frame.size.height);
    }];
}

#pragma mark - 更新导航栏选项
- (void)updateMenuButtonData {
    self.widthArr = [self getMenuBtnWidthByTitle:self.menuTitle];
    if (self.widthArr.count) {
        CGFloat contentSize = [self getMenuViewWidth:self.widthArr];
        self.menuRollView.contentSize = CGSizeMake(contentSize, 0);
    }
}

@end
