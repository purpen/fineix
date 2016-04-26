//
//  SubscribeViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneSubscribeViewController.h"

@interface SceneSubscribeViewController ()

@end

@implementation SceneSubscribeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"SubscribeVcTitle", nil);
}


@end
