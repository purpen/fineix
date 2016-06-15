//
//  EditViewController.m
//  Fiu
//
//  Created by FLYang on 16/6/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"editScene", nil)];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"editFiuScene", nil)];
    }
    
    self.navTitle.textColor = [UIColor blackColor];
    [self addCloseBtn];
    [self addDoneButton];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认修改
- (void)releaseScene {
    if ([self.createType isEqualToString:@"scene"]) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝修改场景");
    } else if ([self.createType isEqualToString:@"fScene"]) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝修改情景");
    }
}

@end
