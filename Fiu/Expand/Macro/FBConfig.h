//
//  FBConfig.h
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#ifndef FBConfig_h
#define FBConfig_h

// API ROOT URL
//#define kDomainBaseUrl @"http://api.taihuoniao.com"           //生产环境 （上线正式环境）
#define kDomainBaseUrl @"http://t.taihuoniao.com/app/api"     //开发环境


#undef 请求接口
#define HomeSceneList         @"/scene_sight/"




#define kAppDebug 1

#define kChannel              @"appstore"
// 客户端版本
#define kClientVersion        @"2.1.0"
#define kClientID             @"1415289600"
#define kClientSecret         @"545d9f8aac6b7a4d04abffe5"

#define kFontFamily           @"HelveticaNeue"

// App Store ID
#define kAppStoreId           @"FrBrid2.0"
#define kAppName              @"太火鸟+"

// Error Domain
#define kDomain               @"TaiHuoNiao"
#define kServerError          60001
#define kParseError           60002
#define kNetError             60003

#define kUserInfoPath         @"FB__StoreUserInfo__"
#define kLocalKeyUUID         @"FB__UUID__"

#define WEAKSELF  __weak __typeof(self)weakSelf = self;


#endif /* FBConfig_h */
