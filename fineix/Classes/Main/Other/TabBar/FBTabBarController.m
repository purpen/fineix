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

}

#pragma mark 添加子控制器的方法
/**
 *  @param vc 控制器
 *  @param image 默认图标
 *  @Param seletedImage 点击后的图标
 */
- (void)setChildViewController:(UIViewController *)vc image:(NSString *)image seletedImage:(NSString *)seletedImage {
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:seletedImage];
    
    //  设置tabBarItem点击颜色为原图标颜色
    UIImage * seletedimg = [UIImage imageNamed:seletedImage];
    seletedimg = [seletedimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = seletedimg;
    
    //  设置tabBarItem图标居中
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0);
    
    [self addChildViewController:vc];
    
}

#pragma mark 设置tabBar
- (void)setTabBarController {
    
    HomeViewController * homeVC = [[HomeViewController alloc] init];
    DiscoverViewController * discoverVC = [[DiscoverViewController alloc] init];
    MallViewController * mallVC = [[MallViewController alloc] init];
    MyViewController * myVC = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
    
    [self setChildViewController:homeVC image:@"homegray" seletedImage:@"homered"];
    [self setChildViewController:discoverVC image:@"findgray" seletedImage:@"findred"];
    [self setChildViewController:mallVC image:@"shopgray" seletedImage:@"shopred"];
    [self setChildViewController:myVC image:@"minegray" seletedImage:@"minered"];
    
    self.viewControllers = @[homeVC, discoverVC, mallVC, myVC];

}

#pragma mark “创建情景”的按钮事件
- (void)createBtnClick {
    CreateViewController * createVC = [[CreateViewController alloc] init];
    [self presentViewController:createVC animated:YES completion:nil];
}

@end
