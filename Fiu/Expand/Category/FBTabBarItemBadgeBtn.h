//
//  FBTabBarItemBadgeBtn.h
//  Fiu
//
//  Created by FLYang on 2016/10/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBTabBarItemBadgeBtn : UIButton

/**
 气泡背景
 */
@pro_strong UIImageView *backImage;

/**
 点赞
 */
@pro_strong UIImageView *likeIcon;

/**
 点赞数量
 */
@pro_strong UILabel *likeNum;

/**
 新增粉丝
 */
@pro_strong UIImageView *fansIcon;

/**
 新增粉丝数量
 */
@pro_strong UILabel *fansNum;


/**
 显示消息气泡

 @param value 数量
 */
- (void)thn_showBadgeValue:(NSString *)value;

@end
