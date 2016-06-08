//
//  FBUserTagsLable.h
//  Fiu
//
//  Created by FLYang on 16/6/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

typedef NS_ENUM(NSInteger, TagColor) {
    Color_DaNa,
    Color_HangJia,
    Color_XingSheJia,
    Color_YiShuFan,
    Color_ShouYiRen,
    Color_RenLaiFeng,
    Color_ShuHui,
    Color_ZhiYeBuyer,
};

@interface FBUserTagsLable : UILabel

@pro_assign TagColor    colorType;

- (void)setUserTagInfo:(NSString *)info;

@end
