//
//  THNTabBar.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNTabBar.h"

@implementation THNTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        self.barTintColor = [UIColor colorWithHexString:BLACK_COLOR];
        self.translucent = NO;
    }
    return self;
}

#pragma mark - 自定义的“创建”按钮
- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setImage:[UIImage imageNamed:@"Create"] forState:(UIControlStateNormal)];
        [_createBtn setImage:[UIImage imageNamed:@"Create"] forState:(UIControlStateHighlighted)];
        [_createBtn sizeToFit];
        _createBtn.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
    }
    return _createBtn;
}

#pragma mark - 自定义按钮标题“Fiu”
- (UILabel *)createTitle {
    if (!_createTitle) {
        _createTitle = [[UILabel alloc] init];
        _createTitle.text = NSLocalizedString(@"TabBar_Creat", nil);
        _createTitle.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _createTitle.font = [UIFont systemFontOfSize:10];
        _createTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _createTitle;
}

#pragma mark - 调整tabBar上item的位置和尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = BOUNDS_WIDTH;
    CGFloat height = BOUNDS_HEIGHT;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = width / (self.items.count + 1);
    CGFloat btnH = height;
    
    NSUInteger idx = 0;
    for (UIView * tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (idx == 2) {
                idx = 3;
            }
            btnX = idx * btnW;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            idx++;
        }
    }
    //  设置自定义的按钮在中间
    self.createBtn.frame = CGRectMake(btnX, btnY, 50, 50);
    self.createBtn.layer.cornerRadius = 50 / 2;
    self.createBtn.center = CGPointMake(width * 0.5, height * 0.25);
    
    //  标题
    self.createTitle.frame = CGRectMake(btnX, btnY, 60, 12);
    self.createTitle.center = CGPointMake(width * 0.5, height * 0.87 -2);
    
    [self addSubview:self.createBtn];
    [self addSubview:self.createTitle];
}

@end
