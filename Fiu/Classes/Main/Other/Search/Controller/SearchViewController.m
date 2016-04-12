//
//  SearchViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuTitle = @[@"情景", @"场景", @"用户", @"产品"];
    
    [self.view addSubview:self.searchMenu];
    
}

#pragma mark - 导航菜单视图
- (HTHorizontalSelectionList *)searchMenu {
    if (!_searchMenu) {
        _searchMenu = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        [_searchMenu setTitleFont:[UIFont systemFontOfSize:14] forState:(UIControlStateNormal)];
        [_searchMenu setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_searchMenu setTitleColor:[UIColor colorWithHexString:fineixColor alpha:1] forState:(UIControlStateSelected)];
        _searchMenu.bottomTrimColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
        _searchMenu.selectionIndicatorColor = [UIColor colorWithHexString:fineixColor alpha:1];
        _searchMenu.delegate = self;
        _searchMenu.dataSource = self;
    }
    return _searchMenu;
}

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.menuTitle.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.menuTitle[index];
}

#pragma mark - 点击分类导航按钮
- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    NSLog(@"+++++++++++++++++++++++++++++++  %zi", index);
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBarTransparent:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    
}

@end
