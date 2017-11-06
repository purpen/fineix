//
//  AppDelegate.m
//  fineix
//
//  Created by xiaoyi on 16/2/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AppDelegate.h"
#import "THNTabBarController.h"
#import "Fiu.h"
#import "THNUserData.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "GuidePageViewController.h"
#import "HomePageViewController.h"
#import "THNLoginRegisterViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <UserNotifications/UserNotifications.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "UMessage.h"
#import "CounterModel.h"
#import "UITabBar+badge.h"
#import "IQKeyboardManager.h"
#import "InviteCCodeViewController.h"
#import "AppDelegate+UMAnalytics.h"
#import <UMSocialCore/UMSocialCore.h>

#import "FBGoodsInfoViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"

@interface AppDelegate () <
    WXApiDelegate,
    UNUserNotificationCenterDelegate
>
{
    BMKMapManager *_mapManager;
    float _la;
    float _lo;
    CounterModel *_counterModel;
    NSInteger _subjectType;
}

@end

static NSString *const UMSocialAppKey        = @"5791f41b67e58e8de5002568";
static NSString *const SinaAppKey            = @"1342896218";
static NSString *const SinaAppSecret         = @"ed4fe8faa35c5b006ad7a87d76e60583";
static NSString *const WechatAppID           = @"wxdf5f6f5907a238e8";
static NSString *const WechatAppSecret       = @"227f6fe4c54ad3e51eed975815167b0b";
static NSString *const QQAppID               = @"1105329592";
static NSString *const QQAppKey              = @"CaKcLeg32YeVF7b9";
static NSString *const determineLogin        = @"/auth/check_login";
static NSString *const UMMessageAppKey       = @"5791f41b67e58e8de5002568";
static NSString *const UMMessageMasterSecret = @"6s7pzrgvimmxfpzyc3qvyefgaaoibyiu";
static NSString *const URLSubjectView        = @"/scene_subject/view";
static NSString *const ShareURL              = @"http://m.taihuoniao.com/fiu";
static NSString *const RedirectURL           = @"http://www.taihuoniao.com";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //  设置推送 创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    
    [application registerUserNotificationSettings:notiSettings];
    
    [self thn_setAppFirstLaunching];

    [self thn_setFirstGuideView];
    
    [self thn_setThirdExpand];

    [self thn_setBaiDuMapDelegate];
    
    [self thn_setUserInfoModelMapping];
    
    [self thn_setUmengService];
    
    [self thn_setRegisterWeChatPay];

    [self thn_setUmengPush:launchOptions];
    
    return YES;
}

#pragma mark - 推送设置
- (void)thn_setUmengPush:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:UMMessageAppKey launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];

    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //  打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    //  应用未启动时
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        [self thn_getNotice:userInfo];
        [UMessage sendClickReportForRemoteNotification:userInfo];
    } else {
        //  未接收到通知
    }
}

//  iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"thnUserInfoNotification" object:self userInfo:userInfo];
        //  关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
    }
    [UMessage didReceiveRemoteNotification:userInfo];
}

//  iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if (userInfo) {
            //应用处于前台时的远程推送接受
            [UMessage setAutoAlert:NO];
        }
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于前台时的本地推送接受
    }
}

//  iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if (userInfo) {
            //应用处于后台时的远程推送接受
            [[NSNotificationCenter defaultCenter] postNotificationName:@"thnUserInfoNotification" object:self userInfo:userInfo];
        }
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于后台时的本地推送接受
    }
}

#pragma mark - 第三方库设置
- (void)thn_setThirdExpand {
    //  SVP颜色设置
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:fineixColor alpha:1]];
    
    //  键盘弹起模式
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 获取用户启动时的登录状态
- (void)thn_setAppFirstLaunching {
    //  首先统一设置为未登录
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    //  绑定Umeng Alias
    if (userdata.userId.length) {
        [UMessage setAlias:userdata.userId type:@"user_id" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (responseObject) {
            } else {
            }
        }];
    }
}

#pragma mark - 引导图的设置
- (void)thn_setFirstGuideView {
    //  使用的时候用key+版本号替换UserHasGuideView
    //  这样容易控制每个版本都可以显示引导图
    __block BOOL invitation = [[NSUserDefaults standardUserDefaults] boolForKey:@"invitation"];;
    FBRequest *request = [FBAPI postWithUrlString:@"/gateway/is_invited" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dict = [result objectForKey:@"data"];
        NSNumber *code = [dict objectForKey:@"status"];
        if ([code isEqual:@(1)]) {
            //开启了邀请功能
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"invitation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if([code isEqual:@(0)]){
            //没有开启邀请功能
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"invitation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    [self lanch:invitation];
}

- (void)lanch:(BOOL)flag {
    NSArray *arr;
    if (Is_iPhoneX) {
        arr = [NSArray arrayWithObjects:@"iPhoneX01",@"iPhoneX02",@"iPhoneX03",@"iPhoneX04", nil];
    } else {
        arr = [NSArray arrayWithObjects:@"Guide_one",@"Guide_two",@"Guide_three",@"Guide_four", nil];
    }
    BOOL codeFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"codeFlag"];
    BOOL userIsFirstInstalled = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasGuideView"];
    // 获取当前的版本号
    NSString *v = [[NSUserDefaults standardUserDefaults] stringForKey:@"version"];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if ([v isEqualToString:version]) {
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserHasGuideView"];
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (userIsFirstInstalled && codeFlag) {
        THNTabBarController * tabBarC = [[THNTabBarController alloc] init];
        self.window.rootViewController = tabBarC;
        
        THNUserData *userdata = [[THNUserData findAll] lastObject];
        if (userdata.isLogin) {
            FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":userdata.userId} delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                NSDictionary *dataDict = result[@"data"];
                NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
                _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
                
                [tabBarC thn_showTabBarItemBadgeWithItem:[tabBarC.tabBar.items objectAtIndex:3]
                                               likeValue:[NSString stringWithFormat:@"%@", _counterModel.fiu_alert_count]
                                               fansValue:[NSString stringWithFormat:@"%@", _counterModel.fans_count]];
                
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
        
    } else if(!userIsFirstInstalled){
        GuidePageViewController *vc = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:[[THNTabBarController alloc] init]];
        vc.flag = shouYe;
        self.window.rootViewController = vc;
    
    } else if (userIsFirstInstalled && !codeFlag){
        if (flag) {
            self.window.rootViewController = [[InviteCCodeViewController alloc] init];
        } else{
            THNTabBarController * tabBarC = [[THNTabBarController alloc] init];
            self.window.rootViewController = tabBarC;
            THNUserData *userdata = [[THNUserData findAll] lastObject];
            if (userdata.isLogin) {
                FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":userdata.userId} delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    NSDictionary *dataDict = result[@"data"];
                    NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
                    _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
                    
                    [tabBarC thn_showTabBarItemBadgeWithItem:[tabBarC.tabBar.items objectAtIndex:3]
                                                   likeValue:[NSString stringWithFormat:@"%@", _counterModel.fiu_alert_count]
                                                   fansValue:[NSString stringWithFormat:@"%@", _counterModel.fans_count]];
                    
                } failure:^(FBRequest *request, NSError *error) {
                    
                }];
            }
        }
    }
}

#pragma mark - model属性名与字典key名映射
- (void)thn_setUserInfoModelMapping {
    [THNUserData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"userId" : @"_id",
                 @"firstLogin" : @"first_login",
                 @"mediumAvatarUrl" : @"medium_avatar_url",
                 @"trueNickname": @"true_nickname",
                 @"level": @"rank_id",
                 @"levelDesc": @"rank_title",
                 @"birdCoin": @"bird_coin"
                 };
    }];
}

#pragma mark - 友盟的相关配置
- (void)thn_setUmengService {
    //  注册友盟统计
    [self RegistrUMAnalyticsWithAppkey:UMSocialAppKey];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMSocialAppKey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //  设置微信AppId、appSecret，分享url
    [[UMSocialManager defaultManager] setPlaform:(UMSocialPlatformType_WechatSession) appKey:WechatAppID appSecret:WechatAppSecret redirectURL:RedirectURL];
    
    //  设置手机QQ 的AppId，Appkey，和分享URL
    [[UMSocialManager defaultManager] setPlaform:(UMSocialPlatformType_QQ) appKey:QQAppID appSecret:nil redirectURL:RedirectURL];
    
    //  打开新浪微博的SSO开关，设置新浪微博回调地址
    [[UMSocialManager defaultManager] setPlaform:(UMSocialPlatformType_Sina) appKey:SinaAppKey appSecret:SinaAppSecret redirectURL:RedirectURL];
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
}

#pragma mark - 注册百度地图代理
- (void)thn_setBaiDuMapDelegate {
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"7MLakRE70YBXUoMSSNXA9GYXutwS3Wi0" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - 微信支付注册appId
- (void)thn_setRegisterWeChatPay {
    [WXApi registerApp:WechatAppID];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    获取device token
//    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
//    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
//    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"Token：%@", deviceTokenStr);
    
    [UMessage registerDeviceToken:deviceToken];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([WXApi handleOpenURL:url delegate:self]) {
            return YES;
        }
        
        //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                if (_aliDelegate && [_aliDelegate respondsToSelector:@selector(standbyCallbackWithResultDic:)]) {
                    [_aliDelegate standbyCallbackWithResultDic:resultDic];
                }
            }];
        }
    }
    return result;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([WXApi handleOpenURL:url delegate:self]) {
            return YES;
        }
        
        //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                if (_aliDelegate && [_aliDelegate respondsToSelector:@selector(standbyCallbackWithResultDic:)]) {
                    [_aliDelegate standbyCallbackWithResultDic:resultDic];
                }
            }];
        }
    }
    return result;
}

-(void)onReq:(BaseReq*)req
{
    if (self.wxDelegate && [self.wxDelegate respondsToSelector:@selector(onReq:)]) {
        [self.wxDelegate onReq:req];
    }
}

-(void)onResp:(BaseResp*)resp
{
    if (self.wxDelegate && [self.wxDelegate respondsToSelector:@selector(onResp:)]) {
        [self.wxDelegate onResp:resp];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //回到前台时刷新通知状态
    if (_notiDelegate && [_notiDelegate respondsToSelector:@selector(resetNotificationState)]) {
        [_notiDelegate resetNotificationState];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark - 应用未启动状态查看通知消息
- (void)thn_getNotice:(NSDictionary *)userInfo {
    NSInteger type = [[userInfo valueForKey:@"type"] integerValue];
    NSString *targetId = [userInfo valueForKey:@"target_id"];
    
    if (type > 0 && targetId.length > 0) {
        [self thn_openViewControllerWithType:type targetId:targetId];
    }
}
#pragma mark 接收推送消息类型跳转指定页面
- (void)thn_openViewControllerWithType:(NSInteger)type targetId:(NSString *)targetId {
    switch (type) {
        case 1:
            [self thn_openGoodsInfoVC:targetId];
            break;
        case 2:
            [self thn_networkSubjectInfoData:targetId];
            break;
        case 11:
            [self thn_openSceneInfoVC:targetId];
            break;
        case 13:
            [self thn_openUserHomeInfoVC:targetId];
            break;
        default:
            break;
    }
}

//  打开商品详情
- (void)thn_openGoodsInfoVC:(NSString *)targetId {
    FBGoodsInfoViewController *goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = targetId;
    [self.window.rootViewController.childViewControllers[0] pushViewController:goodsInfoVC animated:YES];
}

//  打开情境详情
- (void)thn_openSceneInfoVC:(NSString *)targetId {
    THNSceneDetalViewController *sceneInfoVC = [[THNSceneDetalViewController alloc] init];
    sceneInfoVC.sceneDetalId = targetId;
    [self.window.rootViewController.childViewControllers[0] pushViewController:sceneInfoVC animated:YES];
}

//  打开个人主页
- (void)thn_openUserHomeInfoVC:(NSString *)targetId {
    HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
    userHomeVC.userId = targetId;
    userHomeVC.type = @2;
    //    userHomeVC.isMySelf = [targetId isEqualToString:[self getLoginUserID]];
    [self.window.rootViewController.childViewControllers[0] pushViewController:userHomeVC animated:YES];
}

//  打开专题
- (void)thn_networkSubjectInfoData:(NSString *)idx {
    self.subjectInfoRequest = [FBAPI getWithUrlString:URLSubjectView requestDictionary:@{@"id":idx} delegate:self];
    [self.subjectInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        if (![[[result valueForKey:@"data"] valueForKey:@"type"] isKindOfClass:[NSNull class]]) {
            _subjectType = [[[result valueForKey:@"data"] valueForKey:@"type"] integerValue];
            if (_subjectType == 1) {
                THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
                articleVC.articleDetalid = idx;
                [self.window.rootViewController.childViewControllers[0] pushViewController:articleVC animated:YES];
                
            } else if (_subjectType == 2) {
                THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
                activity.activeDetalId = idx;
                [self.window.rootViewController.childViewControllers[0] pushViewController:activity animated:YES];
                
            } else if (_subjectType == 3) {
                THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
                cuXiao.cuXiaoDetalId = idx;
                cuXiao.vcType = 1;
                [self.window.rootViewController.childViewControllers[0] pushViewController:cuXiao animated:YES];
                
            } else if (_subjectType == 4) {
                THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
                xinPin.xinPinDetalId = idx;
                [self.window.rootViewController.childViewControllers[0] pushViewController:xinPin animated:YES];
                
            } else if (_subjectType == 5) {
                THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
                cuXiao.cuXiaoDetalId = idx;
                cuXiao.vcType = 2;
                [self.window.rootViewController.childViewControllers[0] pushViewController:cuXiao animated:YES];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
    }];
}

@end
