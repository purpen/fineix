//
//  GoodsCarViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCarViewController.h"

@interface GoodsCarViewController ()

@end

@implementation GoodsCarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGoodsCarVcUI];
    
}

#pragma mark - 
- (void)setGoodsCarVcUI {
    [self.view addSubview:self.defaultCarView];
    
}

#pragma mark - 没有商品的购物车背景
- (BuyCarDefault *)defaultCarView {
    if (!_defaultCarView) {
        _defaultCarView = [[BuyCarDefault alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _defaultCarView.nav = self.navigationController;
    }
    return _defaultCarView;
}

#pragma mark - 设置导航栏
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"GoodsCarVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
