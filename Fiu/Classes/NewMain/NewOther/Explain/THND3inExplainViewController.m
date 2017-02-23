//
//  THND3inExplainViewController.m
//  Fiu
//
//  Created by FLYang on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THND3inExplainViewController.h"

@interface THND3inExplainViewController ()

@end

@implementation THND3inExplainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"" image:@"icon_cancel"];
    self.navViewTitle.text = @"合伙人招募计划";
}

- (void)thn_rightBarItemSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
