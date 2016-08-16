//
//  THNTabBarController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNTabBarController.h"
#import "THNNavigationController.h"
#import "THNTabBar.h"
#import "THNHomeViewController.h"
#import "THNDiscoverViewController.h"
#import "THNMallViewController.h"
#import "THNMallViewController.h"
#import "MyPageViewController.h"
#import "UserInfoEntity.h"
#import "THNLoginRegisterViewController.h"
#import "PictureToolViewController.h"
#import "THNLoginRegisterViewController.h"

@implementation THNTabBarController {
    THNNavigationController * _homeNav;
    THNNavigationController * _discoverNav;
    THNNavigationController * _mallNav;
    THNNavigationController * _myNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self thn_setTabBarController];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //这里我判断的是当前点击的tabBarItem的标题
    if ([viewController.tabBarItem.title isEqualToString:NSLocalizedString(@"TabBar_MyCenter", nil)]) {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary * dataDic = [result objectForKey:@"data"];
            entity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
        
        if (entity.isLogin) {
            return YES;
        } else {
            THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navi animated:YES completion:nil];
            
            return NO;
        }
        
    } else {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary * dataDic = [result objectForKey:@"data"];
            entity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
        return YES;
    }
}

#pragma mark 添加子控制器的方法
/**
 *  @param vc 控制器
 *  @param image 默认图标
 *  @Param seletedImage 点击后的图标
 */
- (void)setChildViewController:(UIViewController *)vc image:(NSString *)image seletedImage:(NSString *)seletedImage itemTitle:(NSString *)title {
    UIImage * defaultImg = [UIImage imageNamed:image];
    defaultImg = [defaultImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = defaultImg;
    vc.tabBarItem.selectedImage = [UIImage imageNamed:seletedImage];
    vc.tabBarItem.title = title;
    
    //  tabBarItem点击的文字颜色
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:WHITE_COLOR]}
                                 forState:(UIControlStateNormal)];
     
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:MAIN_COLOR]}
                                 forState:(UIControlStateSelected)];
    
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    //  设置tabBarItem点击颜色为原图标颜色
    UIImage *seletedImg = [UIImage imageNamed:seletedImage];
    seletedImg = [seletedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = seletedImg;
    
    [self addChildViewController:vc];
}

#pragma mark 设置tabBar
- (void)thn_setTabBarController {
    self.delegate = self;

    THNTabBar *tabBar = [[THNTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar.createBtn addTarget:self action:@selector(createBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    THNHomeViewController *homeVC = [[THNHomeViewController alloc] init];
    THNDiscoverViewController *discoverVC = [[THNDiscoverViewController alloc] init];
    THNMallViewController *mallVC = [[THNMallViewController alloc] init];
    MyPageViewController *myVC = [[MyPageViewController alloc] init];
    
    _homeNav = [[THNNavigationController alloc] initWithRootViewController:homeVC];
    _discoverNav = [[THNNavigationController alloc] initWithRootViewController:discoverVC];
    _mallNav = [[THNNavigationController alloc] initWithRootViewController:mallVC];
    _myNav = [[THNNavigationController alloc] initWithRootViewController:myVC];
    
    [self setChildViewController:_homeNav
                           image:@"tabBar_Home"
                    seletedImage:@"tabBar_Home_Se"
                       itemTitle:NSLocalizedString(@"TabBar_Home", nil)];
    [self setChildViewController:_discoverNav
                           image:@"tabBar_Discover"
                    seletedImage:@"tabBar_Discover_Se"
                       itemTitle:NSLocalizedString(@"TabBar_Discover", nil)];
    [self setChildViewController:_mallNav
                           image:@"tabBar_Mall"
                    seletedImage:@"tabBar_Mall_Se"
                       itemTitle:NSLocalizedString(@"TabBar_Mall", nil)];
    [self setChildViewController:_myNav
                           image:@"tabBar_MyCenter"
                    seletedImage:@"tabBar_MyCenter_Se"
                       itemTitle:NSLocalizedString(@"TabBar_MyCenter", nil)];
    
    self.viewControllers = @[_homeNav, _discoverNav, _mallNav, _myNav];
}

#pragma mark “创建情景”的按钮事件
- (void)createBtnClick {
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        entity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
    
//    if (entity.isLogin) {
        PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
        [self presentViewController:pictureToolVC animated:YES completion:nil];
//    } else {
//        THNLoginRegisterViewController *loginSignupVC = [[THNLoginRegisterViewController alloc] init];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
//        [self presentViewController:navi animated:YES completion:nil];
//    }
}

@end
