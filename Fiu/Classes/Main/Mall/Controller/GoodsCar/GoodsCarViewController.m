//
//  GoodsCarViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCarViewController.h"

static NSString *const URLGoodsCar = @"/shopping/fetch_cart";

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
    
    [self networkGoodsCarList];
    
}

#pragma mark - 网络请求
#pragma mark 购物车列表
- (void)networkGoodsCarList {
    self.goodsCarRequest = [FBAPI getWithUrlString:URLGoodsCar requestDictionary:nil delegate:self];
    [self.goodsCarRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝ 购物车列表：%@", result);
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
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
