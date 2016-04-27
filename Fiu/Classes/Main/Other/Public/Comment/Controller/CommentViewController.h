//
//  CommentViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "WriteCommentView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

@interface CommentViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   sceneCommentRequest;
@pro_strong FBRequest               *   sendCommentRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong NSString                *   targetId;

@pro_strong UITableView             *   commentTabel;   //  评论视图
@pro_strong WriteCommentView        *   writeComment;   //  填写评论

@end
