//
//  GoodsInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsInfoViewController.h"

@interface GoodsInfoViewController ()

@end

@implementation GoodsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.title = NSLocalizedString(@"GoodsInfoVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car"];
    self.delegate = self;
}

- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊购物车");
}

@end
