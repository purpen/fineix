//
//  SelectSceneViewController.m
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SelectSceneViewController.h"

@interface SelectSceneViewController ()

@end

@implementation SelectSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"chooseSceneVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton:@"icon_back"];
    [self addLine];
    [self.navView addSubview:self.sureBtn];
}

#pragma mark - 确定按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
    }
    return _sureBtn;
}


@end
