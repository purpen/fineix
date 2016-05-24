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

@interface FBPictureViewController : UIViewController

@pro_strong UIView              *   navView;            //  顶部状态栏
@pro_strong UILabel             *   navTitle;           //  顶部标题
@pro_strong UIButton            *   openPhotoAlbums;    //  打开相薄
@pro_strong UIButton            *   cancelBtn;          //  取消按钮
@pro_strong UIButton            *   backBtn;            //  返回按钮
@pro_strong UIButton            *   doneBtn;            //  完成发布按钮
@pro_strong UIButton            *   cancelDoneBtn;      //  取消创建
@pro_strong UIButton            *   closeBtn;           //  关闭
@pro_strong UIButton            *   nextBtn;            //  继续按钮
@pro_strong UIButton            *   cropBack;           //  "裁剪"返回
@pro_strong UILabel             *   line;               //  视图分割线

/*
 *  导航视图
 */
- (void)addNavViewTitle:(NSString *)title;

/*
 *  打开相薄按钮
 */
- (void)addOpenPhotoAlbumsButton;

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
 *  发布按钮
 */
- (void)addCloseButton;

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

@end
