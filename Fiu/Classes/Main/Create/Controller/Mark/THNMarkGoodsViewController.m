//
//  THNMarkGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMarkGoodsViewController.h"

@interface THNMarkGoodsViewController ()

@end

@implementation THNMarkGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark - 设置视图UI
- (void)setUI {
    [self.view addSubview:self.searchGoods];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"pleaseWriteGoods", nil);
        _searchGoods.delegate = self;
        [_searchGoods.searchInputBox becomeFirstResponder];
    }
    return _searchGoods;
}

#pragma mark - 搜索产品
- (void)beginSearch:(NSString *)searchKeyword {
    
}

#pragma mark - 取消搜索
- (void)cancelSearch {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navView.hidden = YES;
}

@end
