//
//  FBCityViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBCityViewController.h"

@interface FBCityViewController ()

@end

@implementation FBCityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"CityVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
