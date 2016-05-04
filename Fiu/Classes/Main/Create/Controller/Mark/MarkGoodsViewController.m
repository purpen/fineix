//
//  MarkGoodsViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MarkGoodsViewController.h"
#import "Fiu.h"
#import "SVProgressHUD.h"

@interface MarkGoodsViewController ()

@end

@implementation MarkGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    
    [self setNavViewUI];
    
    [self setUI];
}

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"marker", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton:@"icon_cancel_black"];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addLine];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置视图UI
- (void)setUI {
    self.categoryTitleArr = @[@"全部", @"智能家居", @"3C数码", @"生活方式", @"家居日用", @"智能家居", @"3C数码", @"生活方式", @"家居日用"];
    
    [self.view addSubview:self.searchGoods];
    
    [self.view addSubview:self.categoryMenuView];

}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"searchGoods", nil);
        _searchGoods.delegate = self;
    }
    return _searchGoods;
}

#pragma mark - 搜索产品
- (void)beginSearch:(NSString *)searchKeyword {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"搜索的产品关键字：%@", searchKeyword]];
}

#pragma mark - 导航菜单视图
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, 44)];
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


@end
