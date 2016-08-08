//
//  THNViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@protocol THNNavigationBarItemsDelegate <NSObject>

@optional
- (void)thn_leftBarItemSelected;
- (void)thn_rightBarItemSelected;

@end

@interface THNViewController : UIViewController

@pro_strong UIView *navView;        //  Nav视图
@pro_strong UILabel *navViewTitle;  //  控制器标题
@pro_strong UIButton *navBackBtn;   //  返回按钮
@pro_strong UIButton *leftBtn;      //  ligthItem
@pro_strong UIButton *rightBtn;     //  rightItem
@pro_strong UIButton *logoImg;      //  Nav中间的Logo
@pro_strong UIButton *qrBtn;        //  二维码扫描
@pro_strong UITableView *baseTable; //  当前列表

/*
 *  在Nav上添加中间的Logo
 */
- (void)thn_addNavLogoImage;

/*
 *  在Nav上添加返回按钮
 */
- (void)thn_addNavBackBtn;

/*
 *  添加二维码扫描按钮
 */
- (void)thn_addQRBtn;

/*
 *  在Nav上添加leftItem
 */
- (void)thn_addBarItemLeftBarButton:(NSString *)title image:(NSString *)image;

/*
 *  在Nav上添加rightItem
 */
- (void)thn_addBarItemRightBarButton:(NSString *)title image:(NSString *)image;

/**
 *  添加首次启动操作指示图
 */
- (void)thn_setGuideImgForVC:(NSString *)image;
- (void)thn_setMoreGuideImgForVC:(NSArray *)imgArr;

/**
 *  提示语
 */
- (void)thn_showMessage:(NSString *)message;

/**
 *  navigationItem点击事件
 */
@pro_weak id <THNNavigationBarItemsDelegate> delegate;


@end
