//
//  ProjectViewCommentsViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/6/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
@class WriteCommentView;

@interface ProjectViewCommentsViewController : FBViewController

@pro_strong FBRequest               *   sceneCommentRequest;
@pro_strong FBRequest               *   sendCommentRequest;
@pro_strong FBRequest               *   replyCommentRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;
@pro_strong NSString                *   targetId;

@pro_strong UITableView             *   commentTabel;   //  评论视图
@pro_strong WriteCommentView        *   writeComment;   //  填写评论
@pro_strong NSString                *   sceneUserId;    //  场景创建人id
@pro_strong NSString                *   tagetUserId;    //  被回复的人id
@pro_strong NSString                *   replyCommentId; //  被回复的评论id
@pro_strong UILabel                 *   promptLab;

@end
