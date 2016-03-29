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
    self.menuTitle = [NSMutableArray arrayWithObjects:@"全部", @"智能家居", @"3C数码", @"生活方式", @"家居日用", @"智能家居", @"3C数码", @"生活方式", @"家居日用", nil];
    
    [self.view addSubview:self.searchGoods];
    
    [self.view addSubview:self.menuView];

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
- (HTHorizontalSelectionList *)menuView {
    if (!_menuView) {
        _menuView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 44)];
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
    return self.menuTitle.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.menuTitle[index];
}

#pragma mark - 点击分类导航按钮
- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    NSLog(@"+++++++++++++++++++++++++++++++  %zi", index);
}


@end
