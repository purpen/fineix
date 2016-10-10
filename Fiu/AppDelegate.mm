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
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "GuidePageViewController.h"
#import "HomePageViewController.h"
#import "THNLoginRegisterViewController.h"

#import <UserNotifications/UserNotifications.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "WXApi.h"
#import "CounterModel.h"
#import "UITabBar+badge.h"
#import "IQKeyboardManager.h"
#import "InviteCCodeViewController.h"
#import "AppDelegate+UMAnalytics.h"

@interface AppDelegate () <
    WXApiDelegate,
    UNUserNotificationCenterDelegate
>
{
    BMKMapManager *_mapManager;
    float _la;
    float _lo;
    CounterModel *_counterModel;
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
}

//  iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"thnUserInfoNotification" object:self userInfo:userInfo];
    //  关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

//  iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
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
        //应用处于后台时的远程推送接受
        //    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
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
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    entity.isLogin = NO;
    //  发送网络请求查看登录状态
    FBRequest *request = [FBAPI postWithUrlString:determineLogin requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        if ([[dataDic objectForKey:@"is_login"] boolValue]) {
            //  已经登录的获取用户信息，更改登录状态
            [[[UserInfo findAll] lastObject] updateUserInfoEntity];
            entity.isLogin = YES;
            
            //  绑定Umeng Alias
            if (entity.userId.length) {
                [UMessage setAlias:entity.userId type:@"user_Id" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                    if (responseObject) {
                        NSLog(@"绑定成功 %@", entity.userId);
                    } else {
                        NSLog(@"-- %@ --", [error localizedDescription]);
                    }
                }];
            }

        } else {
            NSLog(@"绑定成功 %zi", entity.isLogin);
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
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
    NSArray *arr = [NSArray arrayWithObjects:@"Guide_one",@"Guide_two",@"Guide_three",@"Guide_four", nil];
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
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
            _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
            //判断小圆点是否消失
            if (![_counterModel.message_total_count isEqual:@0]) {
                [tabBarC.tabBar showBadgeWithIndex:4];
            
            } else{
                [tabBarC.tabBar hideBadgeWithIndex:4];
            }
        
        } failure:^(FBRequest *request, NSError *error) {
        
        }];
        
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
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                NSDictionary *dataDict = result[@"data"];
                NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
                _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
                //判断小圆点是否消失
                if (![_counterModel.message_total_count isEqual:@0]) {
                    [tabBarC.tabBar showBadgeWithIndex:4];
                
                } else{
                    [tabBarC.tabBar hideBadgeWithIndex:4];
                }
            
            } failure:^(FBRequest *request, NSError *error) {
            
            }];
        }
    }
}

#pragma mark - model属性名与字典key名映射
- (void)thn_setUserInfoModelMapping {
    [UserInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"userId" : @"_id",
                 @"firstLogin" : @"first_login",
                 @"mediumAvatarUrl" : @"medium_avatar_url",
                 @"trueNickname": @"true_nickname",
                 @"level": @"rank_id",
                 @"levelDesc": @"rank_title",
                 @"birdCoin": @"bird_coin",
                 //                 @"": @"",
                 };
    }];
}

#pragma mark - 友盟的相关配置
- (void)thn_setUmengService {
    //  设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMSocialAppKey];
    
    //  注册友盟统计
    [self RegistrUMAnalyticsWithAppkey:UMSocialAppKey];
    
    //  设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:WechatAppSecret url:@"http://www.taihuoniao.com"];
    
    //  设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:@"http://www.taihuoniao.com"];
    
    //  打开新浪微博的SSO开关，设置新浪微博回调地址
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey secret:SinaAppSecret RedirectURL:@"http://www.taihuoniao.com"];
    
    // 未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina]];
    UMSocialConfig *isHidden = [[UMSocialConfig alloc] init];
    isHidden.hiddenStatusTip = YES;
    isHidden.hiddenLoadingHUD = YES;
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
    //  获取device token
//    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
//    
//    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
//    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:deviceTokenStr forKey:@"deviceToken"];
//    userDefaults = nil;
//    
//    NSLog(@"Token：%@", deviceTokenStr);
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([UMSocialSnsService handleOpenURL:url]) {
        return YES;
    }
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
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    [UMSocialSnsService handleOpenURL:url];
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
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
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([UMSocialSnsService handleOpenURL:url]) {
        return YES;
    }
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
    
    return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //回到前台时刷新通知状态
    if (_notiDelegate && [_notiDelegate respondsToSelector:@selector(resetNotificationState)]) {
        [_notiDelegate resetNotificationState];
    }
    
    //登录状态查询及本地用户信息获取
    UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        userEntity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
    } failure:^(FBRequest *request, NSError *error) {

    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
