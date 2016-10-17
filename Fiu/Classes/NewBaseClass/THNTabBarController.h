//
//  THNTabBarController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBTabBarItemBadgeBtn.h"

@interface THNTabBarController : UITabBarController <UITabBarControllerDelegate>

@pro_strong FBTabBarItemBadgeBtn *badgeBtn;

/**
 显示消息的角标
 
 @param item 位置
 @param value 数量
 
 */
- (void)thn_showTabBarItemBadgeWithItem:(UITabBarItem *)item value:(NSString *)value;


/**
 清楚消息角标
 */
- (void)thn_clearTabBarItemBadge;

@end
