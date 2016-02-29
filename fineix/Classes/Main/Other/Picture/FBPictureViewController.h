//
//  FBPictureViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"
#import "Masonry.h"

@interface FBPictureViewController : UIViewController

@pro_strong UIView      *   navView;        //  顶部导航
@pro_strong UIButton    *   cancelBtn;      //  取消按钮
@pro_strong UIButton    *   backBtn;        //  返回按钮
@pro_strong UILabel     *   navTitle;       //  页面标题
@pro_strong UIButton    *   nextBtn;        //  继续按钮
@pro_strong UIButton    *   photoAlbumBtn;  //  照片胶卷

//  添加取消按钮
- (void)addCancelBtn;
//  添加返回按钮
- (void)addBackBtn;
//  添加页面标题
- (void)addNavTitle;
//  添加继续下一步的按钮
- (void)addNextBtn;

//  添加胶卷的按钮
- (void)addPhotoAlbumBtn;

@end
