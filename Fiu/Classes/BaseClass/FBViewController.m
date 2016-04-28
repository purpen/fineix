//
//  FBViewController.m
//  fineix
//
//  Created by FLYang on 16/3/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface FBViewController ()

@end

@implementation FBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setSlideBackVC];
    
    [self.view addSubview:self.navView];
    
    [self addNavBackBtn];
}

#pragma mark - 自定义Nav视图
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _navView.backgroundColor = [UIColor whiteColor];
        
        [_navView addSubview:self.navViewTitle];

        [_navView addSubview:self.navLine];
        
    }
    return _navView;
}

#pragma mark - 控制器的标题
- (UILabel *)navViewTitle {
    if (!_navViewTitle) {
        _navViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH - 88, 44)];
        _navViewTitle.textColor = [UIColor blackColor];
        _navViewTitle.font = [UIFont systemFontOfSize:17.0f];
        _navViewTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navViewTitle;
}

#pragma mark - pop返回按钮
- (UIButton *)navBackBtn {
    if (!_navBackBtn) {
        _navBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [_navBackBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_navBackBtn addTarget:self action:@selector(popViewController) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _navBackBtn;
}

#pragma mark - Nav左边按钮
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
        [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

#pragma mark - Nav右边按钮
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 20, 44, 44)];
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}

#pragma mark - Nav中间的Logo
- (UIImageView *)logoImg {
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] init];
        _logoImg.image = [UIImage imageNamed:@"Nav_Title"];
    }
    return _logoImg;
}

#pragma mark - 视图分割线
- (UILabel *)navLine {
    if (!_navLine) {
        _navLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
        _navLine.backgroundColor = [UIColor colorWithHexString:@"#F0F0F1"];
    }
    return _navLine;
}

#pragma mark - 添加Nav中间的Logo
- (void)addNavLogoImgisTransparent:(BOOL)transparent {
    if (transparent == YES) {
        self.navView.hidden = YES;
        [self.view addSubview:self.logoImg];
    } else if (transparent == NO) {
        self.navView.hidden = NO;
        [self.navView addSubview:self.logoImg];
    }
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 24));
        make.bottom.equalTo(_navView.mas_bottom).with.offset(-10);
        make.centerX.equalTo(_navView);
    }];
}

#pragma mark - 添加pop返回按钮
- (void)addNavBackBtn {
    if ([self.navigationController viewControllers].count > 1) {
        [self.navView addSubview:self.navBackBtn];
    }
}

//  返回上层视图
- (void)popViewController {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 添加Nav左边的按钮
- (void)addBarItemLeftBarButton:(NSString *)title image:(NSString *)image isTransparent:(BOOL)transparent {
    [self.leftBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    if (transparent == NO) {
        self.navView.hidden = NO;
        [self.navView addSubview:self.leftBtn];
    } else if (transparent == YES) {
        self.navView.hidden = YES;
        [self.view addSubview:self.leftBtn];
    }
}

//  点击左边按钮事件
- (void)leftAction {
    if ([self.delegate respondsToSelector:@selector(leftBarItemSelected)]) {
        [self.delegate leftBarItemSelected];
    }
}

#pragma mark - 添加Nav左边的按钮
- (void)addBarItemRightBarButton:(NSString *)title image:(NSString *)image isTransparent:(BOOL)transparent {
    [self.rightBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"全部城市"]) {
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateNormal];
        self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    if (transparent == NO) {
        self.navView.hidden = NO;
        [self.navView addSubview:self.rightBtn];
    } else if (transparent == YES) {
        self.navView.hidden = YES;
        [self.view addSubview:self.rightBtn];
    }
}

//  点击右边按钮事件
- (void)rightAction {
    if ([self.delegate respondsToSelector:@selector(rightBarItemSelected)]) {
        [self.delegate rightBarItemSelected];
    }
}

#pragma mark - 开启侧滑返回
- (void)setSlideBackVC {
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


@end
