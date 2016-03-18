//
//  SelectSceneViewController.m
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SelectSceneViewController.h"

@interface SelectSceneViewController ()

@end

@implementation SelectSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"选择情境"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton];
    [self addLine];
}

@end
