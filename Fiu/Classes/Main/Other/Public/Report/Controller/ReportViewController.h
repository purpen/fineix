//
//  ReportViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ReportViewController : FBViewController <FBNavigationBarItemsDelegate>

@pro_strong FBRequest               *   reportRequest;  //  举报
@pro_strong NSString                *   targetId;       //  关联id

@end
