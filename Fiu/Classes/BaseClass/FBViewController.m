//
//  FBViewController.m
//  fineix
//
//  Created by FLYang on 16/3/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBLoginRegisterViewController.h"

static NSString *const URLGoodsCarNum = @"/shopping/fetch_cart_count";
static NSString *const URLUserIsLogin = @"/user/user_info";

@interface FBViewController () {
    NSMutableArray * _guideImgMarr;
    UIButton       * _guideBtn;
}

@end

@implementation FBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setSlideBackVC];
    
    [self.view addSubview:self.navView];
    
    [self addNavBackBtn];
    
    [self getGoodsCarNumData];
    self.formalUrl = @"http://t.taihuoniao.com/app/api";
}

#pragma mark - 获取购物车数量
- (void)getGoodsCarNumData {
    self.goodsCarRequest = [FBAPI getWithUrlString:URLGoodsCarNum requestDictionary:nil delegate:self];
    [self.goodsCarRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.goodsCount = [NSString stringWithFormat:@"%@", [[result valueForKey:@"data"] valueForKey:@"count"]];
        if ([[[result valueForKey:@"data"] valueForKey:@"count"] integerValue] > 0) {
            self.countLab.hidden = NO;
            self.countLab.text = self.goodsCount;
        } else {
            self.countLab.hidden = YES;
        }

    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (UILabel *)countLab {
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 25, 15, 15)];
        _countLab.layer.cornerRadius = 15 / 2;
        _countLab.layer.masksToBounds = YES;
        _countLab.backgroundColor = [UIColor blackColor];
        _countLab.textColor = [UIColor whiteColor];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.font = [UIFont systemFontOfSize:9];
    }
    return _countLab;
}

#pragma mark - 显示购物车数量按钮
- (void)setNavGoodsCarNumLab {
    [self.navView addSubview:self.countLab];
}

#pragma mark - 获取用户登录信息
- (BOOL)isUserLogin {
    UserInfoEntity * entity = [UserInfoEntity defaultUserInfoEntity];
    return entity.isLogin;
}

#pragma mark - 弹出登录
- (void)openUserLoginVC {
    UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:[NSBundle mainBundle]];
    FBLoginRegisterViewController * loginSignupVC = [loginStory instantiateViewControllerWithIdentifier:@"FBLoginRegisterViewController"];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 添加操作指示图
- (void)setHomeGuideImgForVC {
    
    _guideImgMarr = [NSMutableArray arrayWithObjects:@"guide-index",@"guide-scene",@"guide-fiu",@"guide-tase",@"guide-personal",@"Guide_index", nil];
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

- (void)setGuideImgForVC:(NSString *)image {
    UIButton * guideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [guideBtn setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [guideBtn addTarget:self action:@selector(removeGuide:) forControlEvents:(UIControlEventTouchUpInside)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:guideBtn];
}

- (void)removeGuide:(UIButton *)button {
    [button removeFromSuperview];
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
        [_rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
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

#pragma mark - 提示语
- (void)showMessage:(NSString *)message {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    [showview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200,44));
        make.bottom.equalTo(window.mas_bottom).with.offset(-100);
        make.centerX.equalTo(window);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 200, 44)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    [showview addSubview:label];
    
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}


@end
