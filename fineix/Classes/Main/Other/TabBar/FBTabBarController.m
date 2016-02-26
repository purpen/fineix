//
//  FBTabBarController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBTabBarController.h"
#import "FBNavigationViewController.h"
#import "FBTabBar.h"

#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "CreateViewController.h"
#import "MallViewController.h"
#import "MyViewController.h"

@implementation FBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarController];
    
    /**
     *  创建自定义的TabBar
     *  修改系统 tabBar 的 readOnly 权限
     */
    FBTabBar * tabBar = [[FBTabBar alloc] initWithFrame:self.tabBar.frame];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar.createBtn addTarget:self action:@selector(createBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    //  设置tabBarItem点击的颜色
    self.tabBar.tintColor = [UIColor colorWithHexString:color];
}

#pragma mark 添加子控制器的方法
/**
 *  @param vc 控制器
 *  @param image 默认图标
 *  @Param seletedImage 点击后的图标
 */
- (void)setChildViewController:(UIViewController *)vc image:(UIImage *)image seletedImage:(UIImage *)seletedImage {
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = seletedImage;
}

#pragma mark 设置tabBar
- (void)setTabBarController {
    
    HomeViewController * homeVC = [[HomeViewController alloc] init];
    DiscoverViewController * discoverVC = [[DiscoverViewController alloc] init];
    MallViewController * mallVC = [[MallViewController alloc] init];
    MyViewController * myVC = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
    
    [self setChildViewController:homeVC image:[UIImage imageNamed:@"homegray"] seletedImage:[UIImage imageNamed:@"homered"]];
    [self setChildViewController:discoverVC image:[UIImage imageNamed:@"findgray"] seletedImage:[UIImage imageNamed:@"findred"]];
    [self setChildViewController:mallVC image:[UIImage imageNamed:@"shopgray"] seletedImage:[UIImage imageNamed:@"shopred"]];
    [self setChildViewController:myVC image:[UIImage imageNamed:@"minegray"] seletedImage:[UIImage imageNamed:@"minered"]];
    
    self.viewControllers = @[homeVC, discoverVC, mallVC, myVC];
    
    //  设置tabBarItem图标居中
    CGFloat offset = 5.0f;
    for (UITabBarItem *item in self.tabBar.items) {
        item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    }
}

#pragma mark “创建情景”的按钮事件
- (void)createBtnClick {
    CreateViewController * createVC = [[CreateViewController alloc] init];
    [self presentViewController:createVC animated:YES completion:nil];
}

@end
