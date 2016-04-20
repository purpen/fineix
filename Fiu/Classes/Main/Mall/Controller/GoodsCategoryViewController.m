//
//  GoodsCategoryViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCategoryViewController.h"

@interface GoodsCategoryViewController ()

@end

@implementation GoodsCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryTitleArr = @[@"3C数码", @"智能出行", @"健康周边", @"母婴产品", @"3C数码", @"智能出行", @"健康周边", @"母婴产品"];
    
    [self.view addSubview:self.categoryMenuView];
}

#pragma mark - 滑动导航栏
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.menuTitle = self.categoryTitleArr;
        [_categoryMenuView updateMenuButtonData];
    }
    return _categoryMenuView;
}

#pragma mark - 点击导航
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    NSLog(@"－－－－－－－－－－－－－－－－ 点击了 %zi", index);
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.title = NSLocalizedString(@"GoodsCategoryVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
