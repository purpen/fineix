//
//  THNViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "QRCodeScanViewController.h"
#import "THNLoginRegisterViewController.h"
#import "DiscoverSearchViewController.h"
#import "MallSearchViewController.h"
#import "GuidePageViewController.h"

#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"
#import "THNQingJingZhuanTiViewController.h"

static NSString *const URLGoodsCarNum = @"/shopping/fetch_cart_count";
static NSInteger const saveTime = 30 * 24 * 60;

@implementation THNViewController {
    NSMutableArray *_guideImgMarr;
    UIButton       *_guideBtn;
    NSInteger       _searchType;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSlideBackVC];
    [self thn_setNavViewUI];
}

-(void)thn_tiaoZhuanLanMuWeiWithType:(NSInteger)type andId:(NSString*)theId andDelegate:(id)delegate andNav:(UINavigationController*)nav{
    switch (type) {
        case 1:
        {
            //url类型
        }
            break;
        case 2:
        {
            //商品ID
        }
            break;

        case 3:
        {
            //字符串
        }
            break;

        case 4:
        {
            //app专题
        }
            break;

        case 5:
        {
            //试用
        }
            break;

        case 6:
        {
            //(话题)评测
        }
            break;

        case 7:
        {
            //－－
        }
            break;

        case 8:
        {
            //情境
        }
            break;

        case 11:
        {
            //情境专题
            __block NSString *dataId;
            __block NSString *dataType;
            FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{@"id" : theId} delegate:delegate];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                NSDictionary *dataDict = result[@"data"];
                dataId = dataDict[@"_id"];
                dataType = dataDict[@"type"];
                [self thn_openSubjectTypeController:nav type:[dataType integerValue] subjectId:dataId];
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
            break;

        case 12:
        {
            //地盘
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 轮播图类型跳转
- (void)thn_openSubjectTypeController:(UINavigationController *)nav type:(NSInteger)type subjectId:(NSString *)idx {
    if (type == 1) {
        THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
        articleVC.articleDetalid = idx;
        [nav pushViewController:articleVC animated:YES];
        
    } else if (type == 2) {
        THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
        activity.activeDetalId = idx;
        [nav pushViewController:activity animated:YES];
        
    } else if (type == 3) {
        THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
        cuXiao.cuXiaoDetalId = idx;
        cuXiao.vcType = 1;
        [nav pushViewController:cuXiao animated:YES];
        
    } else if (type == 4) {
        THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
        xinPin.xinPinDetalId = idx;
        [nav pushViewController:xinPin animated:YES];
        
    } else if (type == 5) {
        THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
        cuXiao.cuXiaoDetalId = idx;
        cuXiao.vcType = 2;
        [nav pushViewController:cuXiao animated:YES];
    } else if (type == 6) {
        THNQingJingZhuanTiViewController *vc = [[THNQingJingZhuanTiViewController alloc] init];
        vc.qingJingZhuanTiID = idx;
        [nav pushViewController:vc animated:YES];
    }
}

#pragma mark 是否有商品推广
- (NSString *)thn_getGoodsReferralCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *referralCode = [defaults objectForKey:ReferralCode];
    NSInteger getTime = [[defaults objectForKey:ReferralCodeTime] integerValue];
    
    //  获取推广码间隔，30天清空推广码
    if (getTime > 0) {
        NSInteger nowTime = [[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] integerValue];
        NSInteger subTime = (nowTime - getTime)/60;
        if (subTime == saveTime) {
            [defaults setObject:@"" forKey:ReferralCode];
            [defaults setObject:@"" forKey:ReferralCodeTime];
        }
    }
    
    if (referralCode.length > 0) {
        return referralCode;
    } else
        return @"";
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
        _countLab.backgroundColor = [UIColor colorWithHexString:fineixColor];
        _countLab.textColor = [UIColor whiteColor];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.font = [UIFont systemFontOfSize:9];
    }
    return _countLab;
}

#pragma mark - 显示购物车数量按钮
- (void)setNavGoodsCarNumLab {
    self.countLab.hidden = YES;
    [self.navView addSubview:self.countLab];
}

#pragma mark - 获取用户登录信息
- (BOOL)isUserLogin {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.isLogin;
}

#pragma mark - 获取用户登录id
- (NSString *)getLoginUserID {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.userId;
}

#pragma mark - 获取用户信息
- (THNUserData *)getLoginUserInfo {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata;
}

#pragma mark - 获取注册时间
- (NSString *)getRegisterTime {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.created_on;
}

#pragma mark - 是否用户本人
- (BOOL)isLoginUserSelf:(NSString *)userId {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if ([userId isEqualToString:userdata.userId])
        return YES;
    else
        return NO;
}

#pragma mark - 获取登录用户订阅主题
- (NSString *)getLoginUserInterestSceneCate {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.interest_scene_cate;
}

#pragma mark - 弹出登录
- (void)openUserLoginVC {
    THNLoginRegisterViewController * loginSignupVC = [[THNLoginRegisterViewController alloc] init];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 设置加载Nav视图
- (void)thn_setNavViewUI {
    [self.view addSubview:self.navView];
    [self.navView bringSubviewToFront:self.view];
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
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 54, 20, 44, 44)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
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
        _logoImg = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 28, 27, 56, 25)];
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
    if (_searchType == 1) {
        DiscoverSearchViewController *discoverVC = [[DiscoverSearchViewController alloc] init];
        [self.navigationController pushViewController:discoverVC animated:YES];
    } else if (_searchType == 2) {
        
        MallSearchViewController *mallVC = [[MallSearchViewController alloc] init];
        [self.navigationController pushViewController:mallVC animated:YES];
    }
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
        [_subscribeBtn setTitle:NSLocalizedString(@"SubscribeDone", nil) forState:(UIControlStateSelected)];
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
    _searchType = type;
    [self.searchBtn setTitle:title forState:(UIControlStateNormal)];
    [self.navView addSubview:self.searchBtn];
    
}

- (void)thn_addBarItemLeftBarButton:(NSString *)title image:(NSString *)image {
    [self.leftBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.leftBtn];
}

- (void)thn_addBarItemRightBarButton:(NSString *)title image:(NSString *)image {
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    CGFloat buttonWidth = [title boundingRectWithSize:CGSizeMake(320, 44) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width *1.5;
    if (image.length > 0) {
        [self.rightBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
        self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 20, 44, 44);
        [self.navView addSubview:self.rightBtn];
        return;
    }
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - buttonWidth - 15, 20, buttonWidth, 44);
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
    label.font = [UIFont systemFontOfSize:14];
    [showview addSubview:label];
    
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark - 开启侧滑返回
- (void)setSlideBackVC {
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
