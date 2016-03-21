//
//  SearchLocationViewController.m
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchLocationViewController.h"

@interface SearchLocationViewController ()

@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
    
    [self.view addSubview:self.searchView];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"位置"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addLine];
    [self.navView addSubview:self.positioningBtn];
    [self.navView addSubview:self.cancelVCBtn];
}

#pragma mark - 定位按钮
- (UIButton *)positioningBtn {
    if (!_positioningBtn) {
        _positioningBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_positioningBtn setImage:[UIImage imageNamed:@"Location Indicator"] forState:(UIControlStateNormal)];
        [_positioningBtn addTarget:self action:@selector(positioningBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _positioningBtn;
}

- (void)positioningBtnClick {
    [SVProgressHUD showInfoWithStatus:@"获取当前定位"];
}

#pragma mark - 取消按钮
- (UIButton *)cancelVCBtn {
    if (!_cancelVCBtn) {
        _cancelVCBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_cancelVCBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _cancelVCBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.cancelVCBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [self.cancelVCBtn addTarget:self action:@selector(cancelVCBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelVCBtn;
}

- (void)cancelVCBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜素框
- (FBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchView.searchInputBox.placeholder = @"搜索地点";
        _searchView.delegate = self;
    }
    return _searchView;
}

- (void)beginSearch:(NSString *)searchKeyword {
    NSLog(@"开始搜索地点======== %@", searchKeyword);
}


@end
