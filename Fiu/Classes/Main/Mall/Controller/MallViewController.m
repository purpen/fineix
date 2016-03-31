//
//  MallViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallViewController.h"

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car"];
    [self addNavLogo:@"Nav_Title"];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊搜索");
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊购物车");
}
@end
