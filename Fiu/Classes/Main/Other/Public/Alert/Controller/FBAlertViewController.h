//
//  FBAlertViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^OpenCommentVC)();
typedef void(^DeleteScene)();
typedef void(^EditDoneAndRefresh)();

@interface FBAlertViewController : UIViewController

@pro_strong NSString        *   type;
@pro_strong UIButton        *   closeBtn;
@pro_strong NSString        *   targetId;
@pro_strong UIView          *   alertView;
@pro_strong NSDictionary    *   sceneData;
@pro_copy OpenCommentVC         openCommentVc;
@pro_copy DeleteScene           deleteScene;
@pro_copy EditDoneAndRefresh    editDoneAndRefresh;

- (void)initFBAlertVcStyle:(BOOL)isUserSelf;

@end
