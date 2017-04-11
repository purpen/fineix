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


/**
 获取商品推广码
 
 @return 推广码
 */
- (NSString *)thn_getGoodsReferralCode;

/**
 *  请求购物车数量
 */
@pro_strong FBRequest   *   goodsCarRequest;
@pro_strong NSString    *   goodsCount;
@pro_strong UILabel     *   countLab;
- (void)getGoodsCarNumData;
- (void)setNavGoodsCarNumLab;


/**
 * URL拼接
 */
@property(nonatomic,copy) NSString *formalUrl;


/**
 *  是否登录
 */
@pro_strong FBRequest   *   userLoginRequest;
- (BOOL)isUserLogin;

/**
 *  获取当前登录用户id
 */
- (NSString *)getLoginUserID;

/**
 *  是否是用户本人
 */
- (BOOL)isLoginUserSelf:(NSString *)userId;

/**
 *  未登录弹出登录框
 */
- (void)openUserLoginVC;

/*
 *  自定义Nav视图
 */
@pro_strong UIView      *   navView;

/*
 *  控制器的标题
 */
@pro_strong UILabel     *   navViewTitle;

/*
 *  返回pop按钮
 */
@pro_strong UIButton    *   navBackBtn;

/*
 *  返回pop按钮
 */
@pro_strong UIButton    *   leftBtn;

/*
 *  返回pop按钮
 */
@pro_strong UIButton    *   rightBtn;

/*
 *  Nav中间的Logo
 */
@pro_strong UIButton    *   logoImg;

/*
 *  表格
 */
@pro_strong UITableView *   baseTable;

/*
 *  视图分割线
 */
@pro_strong UILabel     *   navLine;

/*
 *  二维码扫描
 */
@pro_strong UIButton    *   qrBtn;


@pro_weak id <FBNavigationBarItemsDelegate> delegate;

/*
 *  在Nav上添加中间的Logo
 */
- (void)addNavLogoImgisTransparent:(BOOL)transparent;

/*
 *  在Nav上添加pop返回按钮
 */
- (void)addNavBackBtn;

/*
 *  在Nav上添加左边的按钮
 */
- (void)addBarItemLeftBarButton:(NSString *)title image:(NSString *)image isTransparent:(BOOL)transparent;

/*
 *  在Nav上添加右边的按钮
 */
- (void)addBarItemRightBarButton:(NSString *)title image:(NSString *)image isTransparent:(BOOL)transparent;

/*
 *  在Nav上添加左边的按钮
 */
- (void)addQRBtn;

/**
 *  添加操作指示图
 */
- (void)setGuideImgForVC:(NSString *)image;
- (void)setMoreGuideImgForVC:(NSArray *)imgArr;

/**
 *  提示语
 */
- (void)showMessage:(NSString *)message;

@end
