//
//  FBEditShareInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPictureViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJRefresh.h"
#import "FBMenuView.h"
#import "FBKeyboradToolbar.h"

typedef void(^GetEditShareText)(NSString * title, NSString * des, NSMutableArray * tagsArr);
typedef void(^GetActionId)(NSString *actionId);

@interface FBEditShareInfoViewController : FBPictureViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate,
    UITextViewDelegate,
    FBMenuViewDelegate,
    FBKeyboradToolbarDelegate,
    FBPictureViewControllerDelegate
>

@property (nonatomic, strong) FBRequest           *   categoryRequest;
@property (nonatomic, strong) FBRequest           *   listRequest;
@property (nonatomic, strong) FBRequest           *   searchListRequest;
@property (nonatomic, strong) FBRequest           *   actionTagRequest;
@property (nonatomic, assign) NSInteger               listCurrentpageNum;
@property (nonatomic, assign) NSInteger               listTotalPageNum;
@property (nonatomic, assign) NSInteger               currentpageNum;
@property (nonatomic, assign) NSInteger               totalPageNum;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField         *   titleText;
@property (nonatomic, strong) UITextView          *   desText;
@property (nonatomic, strong) UIImageView         *   bgImgView;
@property (nonatomic, strong) UIImage             *   bgImg;
@property (nonatomic, strong) NSString            *   actionTag;

/*  默认进入的分类语境列表视图 */
@property (nonatomic, strong) UIView              *   listView;
@property (nonatomic, strong) UIButton            *   searchBtn;
@property (nonatomic, strong) UITableView         *   listTable;
@property (nonatomic, strong) FBMenuView          *   categoryMenuView;
@property (nonatomic, strong) FBKeyboradToolbar   *   keyboardToolbar;

/*  搜索进入的列表视图 */
@property (nonatomic, strong) UIView              *   searchView;
@property (nonatomic, strong) UITextField         *   searchField;
@property (nonatomic, strong) UITableView         *   shareTextTable;
@property (nonatomic, strong) UIButton            *   cancelSearchBtn;
@property (nonatomic, copy) GetEditShareText          getEdtiShareText;
@property (nonatomic, copy) GetActionId               getActionId;
@property (nonatomic, strong) NSString            *   actionTitle;

@end
