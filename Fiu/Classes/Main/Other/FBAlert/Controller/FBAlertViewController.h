//
//  FBAlertViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBAlertViewController : UIViewController

@pro_strong UIView          *   alertView;

- (void)initFBAlertVcStyle:(BOOL)isUserSelf;

@end
