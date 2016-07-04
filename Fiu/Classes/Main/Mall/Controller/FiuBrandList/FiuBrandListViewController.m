//
//  FiuBrandListViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuBrandListViewController.h"

@interface FiuBrandListViewController ()

@end

@implementation FiuBrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationViewUI];
    
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"FiuBrandListVC", nil);
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

@end
