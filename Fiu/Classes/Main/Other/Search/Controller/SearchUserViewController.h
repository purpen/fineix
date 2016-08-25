//
//  SearchUserViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "MJRefresh.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SearchUserViewController : FBViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_assign NSInteger index;
@pro_strong FBRequest *followRequest;
@pro_strong FBRequest *cancelFollowRequest;
@pro_strong FBRequest *searchListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong UITableView *userTable;
@pro_strong UILabel *noneLab;
@pro_strong NSMutableArray *userListMarr;
@pro_strong NSMutableArray *userIdMarr;

- (void)searchAgain:(NSString *)keyword;

@end
