//
//  MarkGoodsViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MarkGoodsViewController.h"

@interface MarkGoodsViewController ()

@end

@implementation MarkGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"标记产品"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addLine];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
