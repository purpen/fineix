//
//  Fineix.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#ifndef Fineix_h
#define Fineix_h

#import "FBConfig.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "UIColor+Extension.h"
#import "Masonry.h"
#import "UIImageView+SDWedImage.h"

#define USERDEFAULT [NSUserDefaults standardUserDefaults]

#undef 宽高尺寸
//  屏幕宽
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
//  屏幕高
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
//  宽度
#define BOUNDS_WIDTH    self.bounds.size.width
//  高度
#define BOUNDS_HEIGHT   self.bounds.size.height
//  banner
#define Banner_height   SCREEN_WIDTH * 0.48

#define IS_PHONE5             ( ([[UIScreen mainScreen] bounds].size.height - 568) ? NO : YES )
#define IS_PHONE6P            ( ([[UIScreen mainScreen] bounds].size.height >= 1104) ? NO : YES )

#undef 颜色
#define fineixColor             @"#BE8914"
#define grayLineColor           @"#F7F7F7"
#define cellBgColor             @"#F1F1F1"
#define pictureNavColor         @"#222222"
#define blackFont               @"#333333"
#define lineGrayColor           @"#F0F0F1"
#define tabBarTitle             @"#999999"
#define titleColor              @"#666666"
#define fiuRedColor             @"#FF3366"

#undef  字体大小
//  页面标题
#define Font_ControllerTitle    17
//  场景标题
#define Font_SceneTitle         14
//  商品标题
#define Font_GoodsTitle         14
//  商品价格
#define Font_GoodsPrice         16
//  商品详情标题
#define Font_InfoTitle          16
//  标签
#define Font_Tag                12
//  组标题
#define Font_GroupHeader        14
//  地点
#define Font_Place              10
//  内容
#define Font_Content            14
//  评论
#define Font_Comment            12
//  数字
#define Font_Number             12
//  商品标记标题
#define Font_TabTitle           10
//  商品标记价格
#define Font_TabPrice           9
//  滤镜名称
#define Font_filtersTitle       12
//  用户昵称
#define Font_UserName           12
//  用户简介
#define Font_UserProfile        9


#undef  创建属性
//  strong
#define pro_strong      property (nonatomic, strong)
//  weak
#define pro_weak        property (nonatomic, weak)
//  assign
#define pro_assign      property (nonatomic, assign)
//  copy
#define pro_copy        property (nonatomic, copy)
//  readonly
#define pro_readonly    property (nonatomic, readonly)


#endif /* Fineix_h */
