//
//  AppDelegate+UMAnalytics.m
//  Fiu
//
//  Created by dys on 16/7/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AppDelegate+UMAnalytics.h"
#import "UMMobClick/MobClick.h"
#import "FBAPI.h"

@implementation AppDelegate (UMAnalytics)
-(void)RegistrUMAnalyticsWithAppkey:(NSString *)appkey{
    
    UMConfigInstance.appKey =appkey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    //日志加密
    //    [MobClick setEncryptEnabled:YES];
    
    //crash统计
    [MobClick setCrashReportEnabled:NO];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
}
@end
