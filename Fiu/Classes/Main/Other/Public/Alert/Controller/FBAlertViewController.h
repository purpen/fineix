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

@interface FBAlertViewController : UIViewController

@pro_strong NSString        *   targetId;
@pro_strong UIView          *   alertView;
@pro_strong NSDictionary    *   sceneData;

- (void)initFBAlertVcStyle:(BOOL)isUserSelf;

@end
