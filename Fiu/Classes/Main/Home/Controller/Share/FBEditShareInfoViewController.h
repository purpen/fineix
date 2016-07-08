//
//  FBEditShareInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJRefresh.h"

typedef void(^GetEditShareText)(NSString * title, NSString * des);

@interface FBEditShareInfoViewController : FBViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@pro_strong FBRequest           *   shareTextRequest;
@pro_strong FBRequest           *   searchListRequest;
@pro_assign NSInteger               currentpageNum;
@pro_assign NSInteger               totalPageNum;
@pro_strong UIImage             *   bgImg;

@pro_strong UIView              *   topView;
@pro_strong UIButton            *   clooseBtn;
@pro_strong UIImageView         *   bgImgView;
@pro_strong UITextField         *   searchView;
@pro_strong UITableView         *   shareTextTable;

@pro_strong GetEditShareText        getEdtiShareText;

@end
