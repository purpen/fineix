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
    // Do any additional setup after loading the view.
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
    if ([self.delegate respondsToSelector:@selector(rightBarButtonItem)]) {
        [self.delegate rightBarItemSelected];
    }
}

#pragma mark - 添加Nav中间的Logo
- (void)addNavLogo:(NSString *)image {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
}

#pragma mark - 设置Nav透明
- (void)navBarTransparent {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


@end
