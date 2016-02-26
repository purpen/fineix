//
//  FBTabBar.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBTabBar.h"

@implementation FBTabBar

#pragma mark 自定义的“创建”按钮
- (UIButton *)createBtn {
    if (!_createBtn) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setImage:[UIImage imageNamed:@"create"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"create"] forState:(UIControlStateHighlighted)];
        [btn sizeToFit];
        _createBtn = btn;
        
        [self addSubview:_createBtn];
    }
    return _createBtn;
}

#pragma mark 调整tabBar上item的位置和尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = Bounds_width;
    CGFloat height = Bounds_height;
    
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
    self.createBtn.center = CGPointMake(width * 0.5, height * 0.5);

}


@end
