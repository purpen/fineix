//
//  MorePeopleViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MorePeopleViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_assign NSInteger               type;
@pro_strong NSString            *   likeType;
@pro_strong NSString            *   event;
@pro_strong NSString            *   ids;
@pro_strong UITableView         *   peopleTable;
@pro_strong FBRequest           *   peopleRequest;
@pro_assign NSInteger               currentpageNum;
@pro_assign NSInteger               totalPageNum;
@pro_strong NSMutableArray      *   peopleMarr;   

@end
