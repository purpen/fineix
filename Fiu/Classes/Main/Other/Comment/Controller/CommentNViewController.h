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

@property (nonatomic, strong) FBRequest               *   sceneCommentRequest;
@property (nonatomic, strong) FBRequest               *   sendCommentRequest;
@property (nonatomic, strong) FBRequest               *   replyCommentRequest;
@property (nonatomic, assign) NSInteger                   currentpageNum;
@property (nonatomic, assign) NSInteger                   totalPageNum;
@property (nonatomic, strong) NSString                *   targetId;

@property (nonatomic, strong) UITableView             *   commentTabel;   //  评论视图
@property (nonatomic, strong) WriteCommentView        *   writeComment;   //  填写评论
@property (nonatomic, strong) NSString                *   sceneUserId;    //  场景创建人id
@property (nonatomic, strong) NSString                *   tagetUserId;    //  被回复的人id
@property (nonatomic, strong) NSString                *   replyCommentId; //  被回复的评论id
@property (nonatomic, strong) UILabel                 *   promptLab;

@end
