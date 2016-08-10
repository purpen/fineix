
//
//  THNMacro.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#ifndef THNMacro_h
#define THNMacro_h

#import "FBConfig.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "Masonry.h"
#import "UIColor+Extension.h"
#import "SVProgressHUD.h"

#undef 宽高尺寸
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define BOUNDS_WIDTH        self.bounds.size.width
#define BOUNDS_HEIGHT       self.bounds.size.height
#define BANNER_HEIGHT       211

#undef 设备信息
#define USERDEFAULT          [NSUserDefaults standardUserDefaults]
#define IS_iOS9              [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define IS_PHONE5            [[UIScreen mainScreen] bounds].size.width >= 320
#define IS_PHONE6            [[UIScreen mainScreen] bounds].size.width >= 375
#define IS_PHONE6P           [[UIScreen mainScreen] bounds].size.width >= 414

#undef 颜色
#define MAIN_COLOR            @"#BE8914"
#define MINOR_COLOR           @"#F1F1F1"
#define GRAY_COLOR            @"#F7F7F7"
#define WHITE_COLOR           @"#FFFFFF"
#define BLACK_COLOR           @"#000000"

#undef  创建属性
#define pro_strong             property (nonatomic, strong)
#define pro_weak               property (nonatomic, weak)
#define pro_assign             property (nonatomic, assign)
#define pro_copy               property (nonatomic, copy)
#define pro_strong_readonly    property (nonatomic, strong, readonly)

#endif /* THNMacro_h */
