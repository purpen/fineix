//
//  ProjectViewCommentsViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/6/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ProjectViewCommentsViewController.h"
#import "CommentDataTableViewCell.h"
#import "CommentRow.h"
#import "SVProgressHUD.h"
#import "WriteCommentView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

static NSString *const URLSceneComment = @"/comment/getlist";
static NSString *const URLSendSceneComment = @"/comment/ajax_comment";

@interface ProjectViewCommentsViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger       _isReply;
    NSString    *   _userLoginID;
}

@pro_strong NSMutableArray      *   commentListMarr;    //  评论列表
@pro_strong NSMutableArray      *   userId;             //  被回复人id
@pro_strong NSMutableArray      *   replyId;            //  被回复评论id

@end

@implementation ProjectViewCommentsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _isReply = 0;
    self.currentpageNum = 0;
    [self networkSceneCommenstData];
    
    [self setCommentViewUI];
    
}

#pragma mark - 网络请求
#pragma mark 请求评论
- (void)networkSceneCommenstData {
    [SVProgressHUD show];
    self.sceneCommentRequest = [FBAPI getWithUrlString:URLSceneComment requestDictionary:@{@"target_id":self.targetId, @"page":@(self.currentpageNum + 1), @"type":@"13", @"size":@"20", @"sort":@"1"} delegate:self];
    [self.sceneCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            CommentRow * commentModel = [[CommentRow alloc] initWithDictionary:sceneDic];
            [self.commentListMarr addObject:commentModel];
        }
        
        if (self.commentListMarr.count == 0) {
            self.commentTabel.tableHeaderView = self.promptLab;
        } else {
            [self.commentTabel reloadData];
        }
        
        //  用户id
        [self.userId addObjectsFromArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"user_id"]];
        //  评论id
        [self.replyId addObjectsFromArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"]];
        //  当前登录用户id
        _userLoginID = [NSString stringWithFormat:@"%@", [result valueForKey:@"current_user_id"]];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.commentTabel currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 发布评论
- (void)networkSendCommentData {
    if ([self.writeComment.writeText.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写评论"];
    } else {
        self.sendCommentRequest = [FBAPI postWithUrlString:URLSendSceneComment requestDictionary:@{@"from_site":@"3", @"type":@"13", @"target_id":self.targetId, @"content":self.writeComment.writeText.text ,@"is_reply":@"0",@"target_user_id":self.sceneUserId} delegate:self];
        [self.sendCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
            CommentRow * sendCommentModel = [[CommentRow alloc] initWithDictionary:[result valueForKey:@"data"]];
            [self.commentListMarr insertObject:sendCommentModel atIndex:0];
            [self.replyId insertObject:[[result valueForKey:@"data"] valueForKey:@"_id"] atIndex:0];
            [self.userId insertObject:[[result valueForKey:@"data"] valueForKey:@"user_id"] atIndex:0];
            self.commentTabel.tableHeaderView = [UIView new];
            [self.commentTabel reloadData];
            self.writeComment.writeText.text = @"";
            [self.writeComment.writeText resignFirstResponder];
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
            [self requestIsLastData:self.commentTabel currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 回复评论
- (void)notworkReplyCommentData:(NSString *)targetUserId withReplyId:(NSString *)replyId {
    if ([self.writeComment.writeText.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写评论"];
    } else {
        self.replyCommentRequest = [FBAPI postWithUrlString:URLSendSceneComment requestDictionary:@{@"from_site":@"3", @"type":@"13", @"target_id":self.targetId, @"content":self.writeComment.writeText.text ,@"is_reply":@"1",@"reply_user_id":targetUserId, @"reply_id":replyId} delegate:self];
        [self.replyCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
            CommentRow * replyCommentModel = [[CommentRow alloc] initWithDictionary:[result valueForKey:@"data"]];
            [self.commentListMarr insertObject:replyCommentModel atIndex:0];
            [self.replyId insertObject:[[result valueForKey:@"data"] valueForKey:@"_id"] atIndex:0];
            [self.userId insertObject:[[result valueForKey:@"data"] valueForKey:@"user_id"] atIndex:0];
            [self.commentTabel reloadData];
            self.writeComment.writeText.text = @"";
            [self.writeComment.writeText resignFirstResponder];
            [SVProgressHUD showSuccessWithStatus:@"回复成功"];
            [self requestIsLastData:self.commentTabel currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentpageNum = 0;
        [self.commentListMarr removeAllObjects];
        [self.userId removeAllObjects];
        [self.replyId removeAllObjects];
        [self networkSceneCommenstData];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkSceneCommenstData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置视图
- (void)setCommentViewUI {
    [self.view addSubview:self.commentTabel];
    
    [self.view addSubview:self.writeComment];
    [_writeComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
}

#pragma mark - 没有评论的提示
- (UILabel *)promptLab {
    if (!_promptLab) {
        _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
        _promptLab.text = @"你可是第一个看到它的人，快来评论一下吧";
        _promptLab.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _promptLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _promptLab.font = [UIFont systemFontOfSize:13];
        }
        _promptLab.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLab;
}

#pragma mark 填写评论
- (WriteCommentView *)writeComment {
    if (!_writeComment) {
        _writeComment = [[WriteCommentView alloc] init];
        [_writeComment.sendBtn addTarget:self action:@selector(sendCommentData) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _writeComment;
}

#pragma mark 发表评论
- (void)sendCommentData {
    if (_isReply == 0) {
        [self networkSendCommentData];
    } else if (_isReply == 1) {
        [self notworkReplyCommentData:self.tagetUserId withReplyId:self.replyCommentId];
    }
}

#pragma mark 评论列表
- (UITableView *)commentTabel {
    if (!_commentTabel) {
        _commentTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStylePlain)];
        _commentTabel.delegate = self;
        _commentTabel.dataSource = self;
        _commentTabel.showsVerticalScrollIndicator = NO;
        _commentTabel.tableFooterView = [UIView new];
        _commentTabel.estimatedRowHeight = 100;
        [self addMJRefresh:_commentTabel];
    }
    return _commentTabel;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CommentDataCellId = @"commentDataCellId";
    CommentDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CommentDataCellId];
    if (!cell) {
        cell = [[CommentDataTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CommentDataCellId];
    }
    if (self.commentListMarr.count > 0) {
        [cell setCommentData:self.commentListMarr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _isReply = 1;
    self.tagetUserId = [NSString stringWithFormat:@"%@", self.userId[indexPath.row]];
    self.replyCommentId = [NSString stringWithFormat:@"%@", self.replyId[indexPath.row]];
    
    if ([self.tagetUserId isEqualToString:_userLoginID]) {
        NSLog(@"＝＝＝＝＝＝＝＝ 删除评论");
        
    } else {
        self.writeComment.writeText.placeholder = NSLocalizedString(@"reply", nil);
        [self.writeComment.writeText becomeFirstResponder];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"CommentVcTitle", nil);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark -
- (NSMutableArray *)commentListMarr {
    if (!_commentListMarr) {
        _commentListMarr = [NSMutableArray array];
    }
    return _commentListMarr;
}

- (NSMutableArray *)userId {
    if (!_userId) {
        _userId = [NSMutableArray array];
    }
    return _userId;
}

- (NSMutableArray *)replyId {
    if (!_replyId) {
        _replyId = [NSMutableArray array];
    }
    return _replyId;
}

@end

