//
//  THNViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "QRCodeScanViewController.h"

@implementation THNViewController {
    NSMutableArray *_guideImgMarr;
    UIButton       *_guideBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self thn_setNavViewUI];
}

#pragma mark - 设置加载Nav视图
- (void)thn_setNavViewUI {
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.navViewTitle];
    [self thn_addNavBackBtn];
}

#pragma mark - 初始化视图控件
#pragma mark Nav视图
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _navView.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
    }
    return _navView;
}

- (UILabel *)navViewTitle {
    if (!_navViewTitle) {
        _navViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 120, 44)];
        _navViewTitle.textColor = [UIColor whiteColor];
        _navViewTitle.font = [UIFont systemFontOfSize:17];
        _navViewTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navViewTitle;
}

#pragma mark pop返回按钮
- (UIButton *)navBackBtn {
    if (!_navBackBtn) {
        _navBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [_navBackBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:(UIControlStateNormal)];
        [_navBackBtn addTarget:self action:@selector(popViewController) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _navBackBtn;
}

- (void)popViewController {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Nav左边按钮
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

- (void)leftAction {
    if ([self.delegate respondsToSelector:@selector(thn_leftBarItemSelected)]) {
        [self.delegate thn_leftBarItemSelected];
    }
}

#pragma mark Nav右边按钮
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 20, 44, 44)];
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}

- (void)rightAction {
    if ([self.delegate respondsToSelector:@selector(thn_rightBarItemSelected)]) {
        [self.delegate thn_rightBarItemSelected];
    }
}

#pragma mark Nav中间的Logo
- (UIButton *)logoImg {
    if (!_logoImg) {
        _logoImg = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 22, 20, 44, 44)];
        [_logoImg setImage:[UIImage imageNamed:@"shouye_Logo"] forState:(UIControlStateNormal)];
        [_logoImg setImage:[UIImage imageNamed:@"shouye_Logo"] forState:(UIControlStateHighlighted)];
        [_logoImg addTarget:self action:@selector(backTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _logoImg;
}

- (void)backTop {
    [self.baseTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark 二维码扫描
- (UIButton *)qrBtn {
    if (!_qrBtn) {
        _qrBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 78, 20, 44, 44)];
        [_qrBtn setImage:[UIImage imageNamed:@"qr_saoyisao"] forState:(UIControlStateNormal)];
        [_qrBtn addTarget:self action:@selector(openQR) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _qrBtn;
}

- (void)openQR {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark 搜索
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 29, SCREEN_WIDTH - 100, 26)];
        [_searchBtn setImage:[UIImage imageNamed:@"button_search"] forState:(UIControlStateNormal)];
        [_searchBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:(UIControlStateNormal)];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _searchBtn.backgroundColor = [UIColor whiteColor];
        _searchBtn.layer.cornerRadius = 3.0f;
        _searchBtn.clipsToBounds = YES;
        [_searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _searchBtn;
}

- (void)searchBtnClick:(UIButton *)button {
    [SVProgressHUD showSuccessWithStatus:@"去搜索"];
}

#pragma mark - 订阅
- (UIButton *)subscribeBtn {
    if (!_subscribeBtn) {
        _subscribeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 30, 60, 24)];
        _subscribeBtn.layer.cornerRadius = 4.0f;
        _subscribeBtn.layer.borderWidth = 0.5f;
        _subscribeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _subscribeBtn.layer.masksToBounds = YES;
        [_subscribeBtn setTitle:NSLocalizedString(@"Subscribe", nil) forState:(UIControlStateNormal)];
        [_subscribeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subscribeBtn;
}

#pragma mark - 加载控件
- (void)thn_addNavLogoImage {
    [self.navView addSubview:self.logoImg];
}

- (void)thn_addQRBtn {
    [self.navView addSubview:self.qrBtn];
}

- (void)thn_addSubscribeBtn {
    [self.navView addSubview:self.subscribeBtn];
}

- (void)thn_addSearchBtnText:(NSString *)title type:(NSInteger)type {
    [self.searchBtn setTitle:title forState:(UIControlStateNormal)];
    [self.navView addSubview:self.searchBtn];
    
}

- (void)thn_addBarItemLeftBarButton:(NSString *)title image:(NSString *)image {
    [self.leftBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.leftBtn];
}

- (void)thn_addBarItemRightBarButton:(NSString *)title image:(NSString *)image {
    [self.rightBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.rightBtn];
}

#pragma mark - 添加操作指示图
- (void)thn_setMoreGuideImgForVC:(NSArray *)imgArr {
    _guideImgMarr = [NSMutableArray arrayWithArray:imgArr];
    _guideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_guideBtn setBackgroundImage:[UIImage imageNamed:_guideImgMarr[0]] forState:(UIControlStateNormal)];
    [_guideBtn addTarget:self action:@selector(removeHomeGuide:) forControlEvents:(UIControlEventTouchUpInside)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_guideBtn];
}

- (void)removeHomeGuide:(UIButton *)button {
    if (_guideImgMarr.count == 1) {
        [_guideBtn removeFromSuperview];
    } else {
        [_guideImgMarr removeObjectAtIndex:0];
        [_guideBtn setBackgroundImage:[UIImage imageNamed:_guideImgMarr[0]] forState:(UIControlStateNormal)];
    }
}

- (void)thn_setGuideImgForVC:(NSString *)image {
    UIButton * guideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [guideBtn setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [guideBtn addTarget:self action:@selector(removeGuide:) forControlEvents:(UIControlEventTouchUpInside)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:guideBtn];
}

- (void)removeGuide:(UIButton *)button {
    [button removeFromSuperview];
}

- (void)thn_addNavBackBtn {
    if ([self.navigationController viewControllers].count > 1) {
        [self.navView addSubview:self.navBackBtn];
    }
}

- (void)thn_showMessage:(NSString *)message {
    
}

@end
