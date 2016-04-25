//
//  FBNavigationViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBNavigationViewController.h"
#import "FBViewController.h"

@interface FBNavigationViewController ()

@end

@implementation FBNavigationViewController

#pragma mark - 重写Nav的方法
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBarHidden = true;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController * _Nullable)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        return [super popViewControllerAnimated:animated];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    return nil;
}

@end
