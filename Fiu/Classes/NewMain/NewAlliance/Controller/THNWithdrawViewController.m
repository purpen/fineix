//
//  THNWithdrawViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWithdrawViewController.h"

@interface THNWithdrawViewController ()

@end

@implementation THNWithdrawViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_registerNotification];
    [self setViewUI];
}

#pragma mark - 注册通知
- (void)thn_registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(a) name:@"canWithdrawalMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(b) name:@"canNotWithdrawalMoney" object:nil];
}

- (void)a {
    self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    self.sureButton.userInteractionEnabled = YES;
}

- (void)b {
    self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#8D8D8D"];
    self.sureButton.userInteractionEnabled = NO;
}

#pragma mark - 设置界面UI
- (void)setViewUI {
    [self.view addSubview:self.withdrawView];
    [self.view addSubview:self.sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 35));
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(_withdrawView.mas_bottom).with.offset(15);
    }];
}

- (THNWithdrawView *)withdrawView {
    if (!_withdrawView) {
        _withdrawView = [[THNWithdrawView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 135)];
        [_withdrawView thn_setCanWithdrawMoneyData:2000];
    }
    return _withdrawView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.layer.cornerRadius = 3.0f;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitle:@"确认提现" forState:(UIControlStateNormal)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"8D8D8D"];
        _sureButton.userInteractionEnabled = NO;
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureButton;
}

#pragma mark - 确认提现
- (void)sureButtonClick:(UIButton *)button {
    [self.withdrawView.moneyTextField resignFirstResponder];
    [SVProgressHUD showSuccessWithStatus:@"确认提现"];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"提现";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"canWithdrawalMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"canNotWithdrawalMoney" object:nil];
}

@end
