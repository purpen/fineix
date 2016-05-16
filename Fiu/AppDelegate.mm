//
//  AppDelegate.m
//  fineix
//
//  Created by xiaoyi on 16/2/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AppDelegate.h"
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


@interface AppDelegate ()<WXApiDelegate>
{
    BMKMapManager *_mapManager;
    float _la;
    float _lo;
}

@end

NSString *const UMSocialAppKey = @"56ef6ab167e58e85710005b3";
NSString *const SinaAppKey = @"1342896218";
NSString *const SinaAppSecret = @"ed4fe8faa35c5b006ad7a87d76e60583";

NSString *const WechatAppID = @"wxdf5f6f5907a238e8";
NSString *const WechatAppSecret = @"227f6fe4c54ad3e51eed975815167b0b";

NSString *const QQAppID = @"1105228778";
NSString *const QQAppKey = @"SFUAKQBkqY8AjWGh";
NSString *const determineLogin = @"/auth/check_login";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //设置引导图片
    [self guide];
    
    
    //首先统一设置为未登录
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//    entity.isLogin = NO;
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
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    
    
    
    
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
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }
    //------------------------------------------------------

    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
}


#pragma mark -  引导图的设置
-(void)guide{
    NSArray *arr = [NSArray arrayWithObjects:@"guide",@"guide",@"guide",@"guide",@"guide", nil];
    //    使用的时候用key+版本号替换UserHasGuideView
    //    这样容易控制每个版本都可以显示引导图
    BOOL userIsFirstInstalled = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasGuideView"];
    
    if (userIsFirstInstalled) {
        FBTabBarController * tabBarC = [[FBTabBarController alloc] init];
        self.window.rootViewController = tabBarC;
    }else{
        self.window.rootViewController = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:[[FBTabBarController alloc] init]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasGuideView"];
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
    NSLog(@"url %@    ****    %@",url,sourceApplication);
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
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    
    //回到前台时刷新通知状态
    if (_notiDelegate && [_notiDelegate respondsToSelector:@selector(resetNotificationState)]) {
        [_notiDelegate resetNotificationState];
    }
    
    //登录状态查询及本地用户信息获取
    FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
        userEntity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
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
