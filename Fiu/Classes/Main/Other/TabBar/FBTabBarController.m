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
#import "FBLoginRegisterViewController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "CreateViewController.h"
#import "MallViewController.h"
#import "MyViewController.h"
#import "UserInfoEntity.h"
#import "PictureToolViewController.h"

@interface FBTabBarController ()<UITabBarControllerDelegate>

@end

@implementation FBTabBarController {
    FBNavigationViewController * _homeNav;
    FBNavigationViewController * _discoverNav;
    FBNavigationViewController * _mallNav;
    FBNavigationViewController * _myNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarController];
    
    
    /**
     *  创建自定义的TabBar
     *  修改系统 tabBar 的 readOnly 权限
     */
    FBTabBar * tabBar = [[FBTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar.createBtn addTarget:self action:@selector(createBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.delegate = self;
}


//UITabBarDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //这里我判断的是当前点击的tabBarItem的标题
    //在我的界面出现之前进行判断
    if ([viewController.tabBarItem.title isEqualToString:@"我"]) {
        //如果用户ID存在的话，说明已登陆
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        if (entity.isLogin) {
            return YES;
        }
        else
        {
           
            //跳到登录页面
            UIStoryboard *loginReginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
            FBLoginRegisterViewController * loginRegisterVC = [loginReginStory instantiateViewControllerWithIdentifier:@"FBLoginRegisterViewController"];
            //设置导航
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginRegisterVC];
            [self presentViewController:navi animated:YES completion:nil];
            //隐藏tabbar
            
            
            return NO;
        }
    }
    
    return YES;
}


#pragma mark 添加子控制器的方法
/**
 *  @param vc 控制器
 *  @param image 默认图标
 *  @Param seletedImage 点击后的图标
 */
- (void)setChildViewController:(UIViewController *)vc image:(NSString *)image seletedImage:(NSString *)seletedImage itemTitle:(NSString *)title {
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:seletedImage];
    vc.tabBarItem.title = title;
    
    //  tabBarItem点击的文字颜色
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:tabBarTitle alpha:1], NSForegroundColorAttributeName, nil] forState:(UIControlStateNormal)];
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:fineixColor alpha:1], NSForegroundColorAttributeName, nil] forState:(UIControlStateSelected)];
    
    //  设置tabBarItem点击颜色为原图标颜色
    UIImage * seletedimg = [UIImage imageNamed:seletedImage];
    seletedimg = [seletedimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = seletedimg;
    
    //  设置tabBarItem图标居中
//    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0);
    
    [self addChildViewController:vc];
    
}

#pragma mark 设置tabBar
- (void)setTabBarController {
    
    HomeViewController * homeVC = [[HomeViewController alloc] init];
    DiscoverViewController * discoverVC = [[DiscoverViewController alloc] init];
    MallViewController * mallVC = [[MallViewController alloc] init];
    UIStoryboard *myStory = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    MyViewController * myVC = [myStory instantiateViewControllerWithIdentifier:@"MyViewController"];
    
    _homeNav = [[FBNavigationViewController alloc] initWithRootViewController:homeVC];
    _discoverNav = [[FBNavigationViewController alloc] initWithRootViewController:discoverVC];
    _mallNav = [[FBNavigationViewController alloc] initWithRootViewController:mallVC];
    _myNav = [[FBNavigationViewController alloc] initWithRootViewController:myVC];
    
    [self setChildViewController:_homeNav image:@"homegray" seletedImage:@"homered" itemTitle:@"情"];
    [self setChildViewController:_discoverNav image:@"findgray" seletedImage:@"findred" itemTitle:@"景"];
    [self setChildViewController:_mallNav image:@"shopgray" seletedImage:@"shopred" itemTitle:@"品"];
    [self setChildViewController:_myNav image:@"minegray" seletedImage:@"minered" itemTitle:@"我"];
    
    self.viewControllers = @[_homeNav, _discoverNav, _mallNav, _myNav];
    
    

}

#pragma mark “创建情景”的按钮事件
- (void)createBtnClick {
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    [self presentViewController:pictureToolVC animated:YES completion:nil];
}

@end
