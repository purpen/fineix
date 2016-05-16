//
//  FBGoodsCommentViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBGoodsCommentViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   commentRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong NSString                *   targetId;

@pro_strong UITableView             *   commentTabel;   //  评论视图
@pro_strong UILabel                 *   promptLab;

@end
