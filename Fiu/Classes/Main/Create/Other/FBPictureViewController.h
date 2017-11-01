//
//  FBPictureViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "Masonry.h"

@protocol FBPictureViewControllerDelegate <NSObject>

@optional
- (void)thn_sureButtonAction;

@end

@interface FBPictureViewController : UIViewController

@property (nonatomic, strong) UIView *navView;            //  顶部状态栏
@property (nonatomic, strong) UILabel *navTitle;          //  顶部标题
@property (nonatomic, strong) UIButton *openPhotoAlbums;  //  打开相薄
@property (nonatomic, strong) UIButton *cancelBtn;        //  取消按钮
@property (nonatomic, strong) UIButton *backBtn;          //  返回按钮
@property (nonatomic, strong) UIButton *doneBtn;          //  完成发布按钮
@property (nonatomic, strong) UIButton *cancelDoneBtn;    //  取消创建
@property (nonatomic, strong) UIButton *closeBtn;         //  关闭
@property (nonatomic, strong) UIButton *sureButton;       //  确定
@property (nonatomic, strong) UIButton *nextBtn;          //  继续按钮
@property (nonatomic, strong) UIButton *cropBack;         //  "裁剪"返回
@property (nonatomic, strong) UILabel *line;              //  视图分割线
@property (nonatomic, weak) id <FBPictureViewControllerDelegate> delegate;

/**
 *  获取当前登录用户id
 */
- (NSString *)getLoginUserID;

/*
 *  导航视图
 */
- (void)addNavViewTitle:(NSString *)title;

/*
 *  打开相薄按钮
 */
- (void)addOpenPhotoAlbumsButton:(NSString *)title;
- (void)getPhotoAlbumsTitleSize:(NSString *)title;

/*
 *  取消按钮
 */
- (void)addCancelButton:(NSString *)image;

/*
 *  继续按钮
 */
- (void)addNextButton;

/*
 *  返回按钮
 */
- (void)addBackButton:(NSString *)image;

/*
 *  发布按钮
 */
- (void)addDoneButton;

/*
 *  确定按钮
 */
- (void)addSureButton;

/*
 *  关闭按钮
 */
- (void)addCloseBtn:(NSString *)image;

/*
 *  视图的分割线
 */
- (void)addLine;

/*
 *  取消创建情景
 */
- (void)addCancelDoneButton;

/*
 *  页面提示框
 */
- (void)showMessage:(NSString *)message;

/**
 *  添加操作指示图
 */
- (void)setGuideImgForVC:(NSString *)image;

@end
