//
//  FBViewController.h
//  fineix
//
//  Created by FLYang on 16/3/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+Helper.h"
#import "Fiu.h"


@protocol FBNavigationBarItemsDelegate <NSObject>

@optional
- (void)leftBarItemSelected;
- (void)rightBarItemSelected;

@end


@interface FBViewController : UIViewController

@pro_weak id <FBNavigationBarItemsDelegate> delegate;

/*
 *  在Nav上添加左边的按钮
 */
- (void)addBarItemLeftBarButton:(NSString *)title image:(NSString *)image;

/*
 *  在Nav上添加右边的按钮
 */
- (void)addBarItemRightBarButton:(NSString *)title image:(NSString *)image;

/*
 *  在Nav上添加Logo
 */
- (void)addNavLogo:(NSString *)image;

/*
 *  设置Nav透明
 */
- (void)navBarTransparent;

/*
 *  设置Nav不透明
 */
- (void)navBarNoTransparent;


@end
