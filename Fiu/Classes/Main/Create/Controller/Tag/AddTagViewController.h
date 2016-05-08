//
//  AddTagViewController.h
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddTagViewController : FBPictureViewController

@pro_strong FBRequest           *   tagRequest;         //  标签

@pro_strong UIButton            *   sureBtn;            //  确定按钮

@end
