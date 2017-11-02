//
//  THNViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNUserData.h"

@protocol THNNavigationBarItemsDelegate <NSObject>

@optional
- (void)thn_leftBarItemSelected;
- (void)thn_rightBarItemSelected;

@end

@interface THNViewController : UIViewController

@property (nonatomic, strong) UIView *navView;        //  Nav视图
@property (nonatomic, strong) UILabel *navViewTitle;  //  控制器标题
@property (nonatomic, strong) UIButton *navBackBtn;   //  返回按钮
@property (nonatomic, strong) UIButton *leftBtn;      //  ligthItem
@property (nonatomic, strong) UIButton *rightBtn;     //  rightItem
@property (nonatomic, strong) UIButton *logoImg;      //  Nav中间的Logo
@property (nonatomic, strong) UIButton *qrBtn;        //  二维码扫描
@property (nonatomic, strong) UIButton *searchBtn;    //  搜索
@property (nonatomic, strong) UITableView *baseTable; //  当前列表
@property (nonatomic, strong) UIButton *subscribeBtn; //  订阅按钮
@property (nonatomic, assign) CGFloat screenHeight;

/**
 *  请求购物车数量
 */
@property (nonatomic, strong) FBRequest   *   goodsCarRequest;
@property (nonatomic, strong) NSString    *   goodsCount;
@property (nonatomic, strong) UILabel     *   countLab;
- (void)getGoodsCarNumData;
- (void)setNavGoodsCarNumLab;

/**
 获取商品推广码

 @return 推广码
 */
- (NSString *)thn_getGoodsReferralCode;

/**
 *  是否登录
 */
- (BOOL)isUserLogin;

/**
 *  获取当前登录用户id
 */
- (NSString *)getLoginUserID;

/**
 *  获取当前登录用户信息
 */
- (THNUserData *)getLoginUserInfo;

/**
 *  获取登录用户注册时间
 */
- (NSString *)getRegisterTime;

/**
 *  是否是用户本人
 */
- (BOOL)isLoginUserSelf:(NSString *)userId;

/**
 *  获取当前登录用户订阅主题
 */
- (NSString *)getLoginUserInterestSceneCate;

/**
 *  未登录弹出登录框
 */
- (void)openUserLoginVC;

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
 *  添加搜索按钮
 *  type:搜索的类型：1: ／ 2:
 */
- (void)thn_addSearchBtnText:(NSString *)title type:(NSInteger)type;

/*
 *  在Nav上添加leftItem
 */
- (void)thn_addBarItemLeftBarButton:(NSString *)title image:(NSString *)image;

/*
 *  在Nav上添加rightItem
 */
- (void)thn_addBarItemRightBarButton:(NSString *)title image:(NSString *)image;

/**
 *  订阅按钮
 */
- (void)thn_addSubscribeBtn;

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
@property (nonatomic, weak) id <THNNavigationBarItemsDelegate> delegate;


/**
 轮播图点击跳转

 @param nav 当前控制器
 @param type 类型
 @param idx 轮播图id
 */
- (void)thn_openSubjectTypeController:(UINavigationController *)nav type:(NSInteger)type subjectId:(NSString *)idx;

-(void)thn_tiaoZhuanLanMuWeiWithType:(NSInteger)type andId:(NSString*)theId andDelegate:(id)delegate andNav:(UINavigationController*)nav;

@end
