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
    
    self.titleArr = [NSArray arrayWithObjects:@"情景", @"场景", @"用户", @"产品", nil];
    
//    [self.view addSubview:self.searchMenu];
    [self.view addSubview:self.menuView];
    
}

#pragma mark - 导航菜单视图
- (HTHorizontalSelectionList *)menuView {
    if (!_menuView) {
        _menuView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        [_menuView setTitleFont:[UIFont systemFontOfSize:14] forState:(UIControlStateNormal)];
        [_menuView setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_menuView setTitleColor:[UIColor colorWithHexString:fineixColor alpha:1] forState:(UIControlStateSelected)];
        _menuView.bottomTrimColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
        _menuView.selectionIndicatorColor = [UIColor colorWithHexString:fineixColor alpha:1];
        _menuView.delegate = self;
        _menuView.dataSource = self;
    }
    return _menuView;
}

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.titleArr.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.titleArr[index];
}

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    NSLog(@"＝＝＝＝＝＝＝＝＝ %zi", index);
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBarTransparent:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    
}

@end
