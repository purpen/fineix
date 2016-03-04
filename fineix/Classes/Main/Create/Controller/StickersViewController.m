//
//  StickersViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "StickersViewController.h"

@interface StickersViewController ()

@end

@implementation StickersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"贴纸"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addLine];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
