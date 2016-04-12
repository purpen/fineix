//
//  FBViewController.m
//  fineix
//
//  Created by FLYang on 16/3/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface FBViewController ()

@end

@implementation FBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setSlideBackVC];
}

#pragma mark - 添加Nav左边的按钮
- (void)addBarItemLeftBarButton:(NSString *)title image:(NSString *)image {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:title backgroundImage:[UIImage imageNamed:image] target:self action:@selector(leftAction)];
}

//  点击左边按钮事件
- (void)leftAction {
    if ([self.delegate respondsToSelector:@selector(leftBarItemSelected)]) {
        [self.delegate leftBarItemSelected];
    }
}

#pragma mark - 添加Nav左边的按钮
- (void)addBarItemRightBarButton:(NSString *)title image:(NSString *)image {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:title backgroundImage:[UIImage imageNamed:image] target:self action:@selector(rightAction)];
}

//  点击右边按钮事件
- (void)rightAction {
    if ([self.delegate respondsToSelector:@selector(rightBarItemSelected)]) {
        [self.delegate rightBarItemSelected];
    }
}

#pragma mark - 添加Nav中间的Logo
- (void)addNavLogo:(NSString *)image {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
}

#pragma mark - 设置Nav透明
- (void)navBarTransparent:(BOOL)ture {
    if (ture) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    } else {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#E9E9E9" alpha:1].CGColor);
        CGContextFillRect(context, rect);
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.navigationController.navigationBar.shadowImage = img;
    }
    
}

#pragma mark - 开启侧滑返回
- (void)setSlideBackVC {
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


@end
