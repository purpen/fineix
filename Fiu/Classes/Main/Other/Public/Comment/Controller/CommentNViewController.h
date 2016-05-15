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

@interface CommentNViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   sceneCommentRequest;
@pro_strong FBRequest               *   sendCommentRequest;
@pro_strong FBRequest               *   replyCommentRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong NSString                *   targetId;

@pro_strong UITableView             *   commentTabel;   //  评论视图
@pro_strong WriteCommentView        *   writeComment;   //  填写评论
@pro_strong NSString                *   tagetUserId;    //  被回复的人id
@pro_strong NSString                *   replyCommentId; //  被回复的评论id
@pro_strong UILabel                 *   promptLab;

/**
 *  0:默认评论场景 ／ 1:回复评论
 */
@pro_assign NSInteger                   isReply;        //  是否回复评论

@end
