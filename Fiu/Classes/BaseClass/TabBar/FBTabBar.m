//
//  FBTabBar.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBTabBar.h"
#import "UserInfoEntity.h"
#import "CounterModel.h"
#import "NSObject+MJKeyValue.h"


@implementation FBTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 59.5, SCREEN_WIDTH, 59.5);
        if (SCREEN_WIDTH <= 320) {
            self.backgroundImage = [UIImage imageNamed:@"tabBar_5"];
        } else {
            self.backgroundImage = [UIImage imageNamed:@"tabBar"];
        }
        
        self.shadowImage = [UIImage new];
        self.translucent = YES;
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
    }
    return _createBtn;
}

#pragma mark - 自定义按钮标题“Fiu”
- (UILabel *)createTitle {
    if (!_createTitle) {
        _createTitle = [[UILabel alloc] init];
        _createTitle.text = @"Fiu 浮游";
        _createTitle.textColor = [UIColor colorWithHexString:tabBarTitle alpha:1];
        _createTitle.font = [UIFont systemFontOfSize:10];
        _createTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _createTitle;
}

#pragma mark - 调整tabBar上item的位置和尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.createBtn];
    [self addSubview:self.createTitle];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
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
    self.createBtn.frame = CGRectMake(btnX, btnY, 49, 49);
    self.createBtn.layer.cornerRadius = 49 / 2;
    if (SCREEN_WIDTH > 375) {
        self.createBtn.center = CGPointMake(width * 0.5, height * 0.2);
    } else {
        self.createBtn.center = CGPointMake(width * 0.5, height * 0.3);
    }
    
    //  标题
    self.createTitle.frame = CGRectMake(btnX, btnY, 60, 12);
    self.createTitle.center = CGPointMake(width * 0.5, height * 0.87 -2);
    
}


@end
