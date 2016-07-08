//
//  AppDelegate.m
//  fineix
//
//  Created by xiaoyi on 16/2/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AppDelegate.h"
#import <PhotoEditFramework/PhotoEditFramework.h>
#import "FBTabBarController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Fiu.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "GuidePageViewController.h"
#import "HomePageViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FBLoginRegisterViewController.h"
#import "CounterModel.h"
#import "UITabBar+badge.h"
#import "IQKeyboardManager.h"
#import "InviteCCodeViewController.h"

@interface AppDelegate ()<WXApiDelegate>
{
    BMKMapManager *_mapManager;
    float _la;
    float _lo;
    CounterModel *_counterModel;
}

@end

NSString *const UMSocialAppKey = @"56ef6ab167e58e85710005b3";
NSString *const SinaAppKey = @"1342896218";
NSString *const SinaAppSecret = @"ed4fe8faa35c5b006ad7a87d76e60583";

NSString *const WechatAppID = @"wxdf5f6f5907a238e8";
NSString *const WechatAppSecret = @"227f6fe4c54ad3e51eed975815167b0b";

NSString *const QQAppID = @"1105329592";  // 1105228778
NSString *const QQAppKey = @"CaKcLeg32YeVF7b9";    // SFUAKQBkqY8AjWGh
NSString *const determineLogin = @"/auth/check_login";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//    //首先统一设置为未登录-----------------------------------------------
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    entity.isLogin = NO;
    //发送网络请求查看登录状态
    FBRequest *request = [FBAPI postWithUrlString:determineLogin requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //发送成功查看登录信息
        NSDictionary *dataDic = [result objectForKey:@"data"];
        if ([[dataDic objectForKey:@"is_login"] boolValue]) {
            //已经登录的获取用户信息，更改登录状态
            
            [[[UserInfo findAll] lastObject] updateUserInfoEntity];
            entity.isLogin = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        //发送失败提示失败信息
        NSLog(@"%@",error);
    }];
//--------------------------------------------------------
    
    //设置引导图片
    [self guide];
    //---------------------------------------
    
    
    
    //  设置SVP颜色---------------------------------------
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:fineixColor alpha:1]];
    //---------------------------------------------------
    
    
    
    //设置百度地图代理---------------------------------
    [self bmkMap];
    //------------------------------------------
    
    //model属性名与字典key名映射----------------------------
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
    //---------------------------------------------------
   

    //设置友盟社会化组件appkey--------------------------------------------------
    [UMSocialData setAppKey:UMSocialAppKey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:WechatAppSecret url:@"http://www.taihuoniao.com"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:@"http://www.taihuoniao.com"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey secret:SinaAppSecret RedirectURL:@"http://www.taihuoniao.com"];
    
    // 由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina]];
    //---------------------------------------------------------------------
    
    
    
    //微信支付注册appId-------------------------
    [WXApi registerApp:WechatAppID];
    //----------------------------------------
    
    //设置推送---------------------------------------------------
    //创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    
    [application registerUserNotificationSettings:notiSettings];
    //------------------------------------------------------
    
    
    //  键盘事件
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    //  camera360 API Key
    [pg_edit_sdk_controller sStart:@"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"];
    
    return YES;
}

/**
 *  程序接受到内存警告
 *  将图片缓存清空
 *  @param application 
 */
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    //清空缓存
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *files = [manager subpathsAtPath:cachesPath];
    //如果数组里有内容需要遍历清空
    for (NSString *fileName in files) {
        NSError *error = nil;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
        if ([manager fileExistsAtPath:filePath]) {
            [manager removeItemAtPath:filePath error:&error];
        }
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
}


#pragma mark -  引导图的设置
-(void)guide{
    
    //    使用的时候用key+版本号替换UserHasGuideView
    //    这样容易控制每个版本都可以显示引导图
    
    __block BOOL invitation = [[NSUserDefaults standardUserDefaults] boolForKey:@"invitation"];;
    FBRequest *request = [FBAPI postWithUrlString:@"/gateway/is_invited" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dict = [result objectForKey:@"data"];
        NSNumber *code = [dict objectForKey:@"status"];
        if ([code isEqual:@(1)]) {
            //开启了邀请功能
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"invitation"];
        }else if([code isEqual:@(0)]){
            //没有开启邀请功能
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"invitation"];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    
    [self lanch:invitation];
    
}

-(void)lanch:(BOOL)flag{
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
    }
    if (userIsFirstInstalled && codeFlag) {
        FBTabBarController * tabBarC = [[FBTabBarController alloc] init];
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
            }else{
                [tabBarC.tabBar hideBadgeWithIndex:4];
            }
        } failure:^(FBRequest *request, NSError *error) {
        }];
    }else if(!userIsFirstInstalled){
        GuidePageViewController *vc = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:[[FBTabBarController alloc] init]];
        vc.flag = shouYe;
        self.window.rootViewController = vc;
    }else if (userIsFirstInstalled && !codeFlag){
        if (flag) {
            self.window.rootViewController = [[InviteCCodeViewController alloc] init];
        }else{
            FBTabBarController * tabBarC = [[FBTabBarController alloc] init];
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
                }else{
                    [tabBarC.tabBar hideBadgeWithIndex:4];
                }
            } failure:^(FBRequest *request, NSError *error) {
            }];
        }
    }
}

#pragma mark -注册百度地图代理
-(void)bmkMap{
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"7MLakRE70YBXUoMSSNXA9GYXutwS3Wi0" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
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
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //回到前台时刷新通知状态
    if (_notiDelegate && [_notiDelegate respondsToSelector:@selector(resetNotificationState)]) {
        [_notiDelegate resetNotificationState];
    }
    
//    //登录状态查询及本地用户信息获取
    UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        userEntity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.taihuoniao.fineix" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"fineix" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"fineix.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
