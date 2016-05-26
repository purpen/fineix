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
@pro_strong NSString            *   bgImg;
@pro_strong NSString            *   afterTitle;
@pro_strong NSString            *   afterDes;
@pro_strong NSString            *   sceneTags;

@pro_strong UIView              *   topView;
@pro_strong UIButton            *   shareBtn;
@pro_strong UIImageView         *   bgImgView;
@pro_strong UITextField         *   editTitle;
@pro_strong UITextView          *   editDes;
@pro_strong UITextField         *   searchView;
@pro_strong UIButton            *   searchBtn;
@pro_strong UITableView         *   searchListTable;
@pro_strong UIView              *   textSearchView;

@pro_strong GetEditShareText        getEdtiShareText;

@end
