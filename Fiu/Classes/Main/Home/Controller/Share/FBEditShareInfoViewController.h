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
#import "FBMenuView.h"

typedef void(^GetEditShareText)(NSString * title, NSString * des, NSArray * tagsArr);

@interface FBEditShareInfoViewController : FBViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FBMenuViewDelegate>

@pro_strong FBRequest           *   categoryRequest;
@pro_strong FBRequest           *   listRequest;
@pro_strong FBRequest           *   searchListRequest;
@pro_assign NSInteger               listCurrentpageNum;
@pro_assign NSInteger               listTotalPageNum;
@pro_assign NSInteger               currentpageNum;
@pro_assign NSInteger               totalPageNum;

@pro_strong UIImageView         *   bgImgView;
@pro_strong UIImage             *   bgImg;
@pro_strong UIView              *   topView;
@pro_strong UIButton            *   clooseBtn;

/*  默认进入的分类语境列表视图 */
@pro_strong UIView              *   listView;
@pro_strong UIButton            *   searchBtn;
@pro_strong UITableView         *   listTable;
@pro_strong FBMenuView          *   categoryMenuView;       //  滑动导航栏

/*  搜索进入的列表视图 */
@pro_strong UIView              *   searchView;
@pro_strong UITextField         *   searchField;
@pro_strong UITableView         *   shareTextTable;
@pro_strong UIButton            *   cancelSearchBtn;

@pro_strong GetEditShareText        getEdtiShareText;

@end
