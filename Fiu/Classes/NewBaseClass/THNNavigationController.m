//
//  THNNavigationController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNNavigationController.h"

@interface THNNavigationController ()

@end

@implementation THNNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBarHidden = YES;
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
