//
//  FBNavigationViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBNavigationViewController.h"

@interface FBNavigationViewController ()

@end

@implementation FBNavigationViewController

//+ (void)initialize {
//    
//    UINavigationBar * fiuNavBar = [UINavigationBar appearance];
//    [fiuNavBar setBarTintColor:[UIColor whiteColor]];
//    [fiuNavBar setTitleTextAttributes:@{
//                                        NSForegroundColorAttributeName:[UIColor blackColor],
//                                        NSFontAttributeName:[UIFont systemFontOfSize:17]
//                                        }];
//}

#pragma mark - 重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //  判断是否为根视图
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNormalIcon:@"icon_back" highlightedIcon:@"icon_back" target:self action:@selector(backAction)];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

@end
