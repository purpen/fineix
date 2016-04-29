//
//  CommentViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentDataTableViewCell.h"
#import "CommentRow.h"

static NSString *const URLSceneComment = @"/comment/getlist";
static NSString *const URLSendSceneComment = @"/comment/ajax_comment";

@interface CommentViewController ()

@pro_strong NSMutableArray      *   commentListMarr;    //  评论列表
@pro_strong NSMutableArray      *   targetUserId;       //  被回复人id
@pro_strong NSMutableArray      *   replyId;            //  被回复评论id

@end

@implementation CommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentpageNum = 0;
    [self networkSceneCommenstData];
    
    [self setCommentViewUI];
}

#pragma mark - 网络请求 
#pragma mark 请求评论
- (void)networkSceneCommenstData {
    [SVProgressHUD show];
    self.sceneCommentRequest = [FBAPI getWithUrlString:URLSceneComment requestDictionary:@{@"target_id":self.targetId, @"page":@(self.currentpageNum + 1), @"type":@"12", @"size":@"12"} delegate:self];
    [self.sceneCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            CommentRow * commentModel = [[CommentRow alloc] initWithDictionary:sceneDic];
            [self.commentListMarr addObject:commentModel];
        }
        [self.targetUserId addObjectsFromArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"user_id"]];
        [self.replyId addObjectsFromArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"]];
        [self.commentTabel reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.commentTabel currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 发布评论
- (void)networkSendCommentDataWithTargetUserId:(NSString *)targetUserId withReplyId:(NSString *)replyId withIsReply:(NSString *)isReply {
    /**
     *  isReply
     *  0:默认评论场景 ／ 1:回复评论
     */
    if ([self.writeComment.writeText.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写评论"];
    
    } else {
        if ([isReply isEqualToString:@"1"]) {
            self.replyCommentRequest = [FBAPI postWithUrlString:URLSendSceneComment requestDictionary:@{@"from_site":@"3", @"type":@"12", @"target_id":self.targetId, @"content":self.writeComment.writeText.text ,@"is_reply":isReply,@"reply_user_id":targetUserId, @"reply_id":replyId} delegate:self];
            [self.replyCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
                [self.writeComment.writeText resignFirstResponder];
                self.writeComment.writeText.text = @"";
                self.isReply = 0;
                self.writeComment.writeText.placeholder = NSLocalizedString(@"comment", nil);
                [self.commentTabel.mj_header beginRefreshing];
                [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }];
            
        } else if ([isReply isEqualToString:@"0"]) {
            self.sendCommentRequest = [FBAPI postWithUrlString:URLSendSceneComment requestDictionary:@{@"from_site":@"3", @"type":@"12", @"target_id":self.targetId, @"content":self.writeComment.writeText.text ,@"is_reply":isReply} delegate:self];
            [self.sendCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
                [self.writeComment.writeText resignFirstResponder];
                self.writeComment.writeText.text = @"";
                [self.commentTabel.mj_header beginRefreshing];
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }];
        }
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

#pragma mark 填写评论
- (WriteCommentView *)writeComment {
    if (!_writeComment) {
        _writeComment = [[WriteCommentView alloc] init];
        self.isReply = 0;
        [_writeComment.sendBtn addTarget:self action:@selector(sendCommentData) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _writeComment;
}

#pragma mark 发表评论
- (void)sendCommentData {
    if (self.isReply == 0) {
        [self networkSendCommentDataWithTargetUserId:nil withReplyId:nil withIsReply:@"0"];
    } else if (self.isReply == 1) {
        [self networkSendCommentDataWithTargetUserId:self.tagetUserId withReplyId:self.replyCommentId withIsReply:@"1"];
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
    [cell setCommentData:self.commentListMarr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isReply = 1;
    self.writeComment.writeText.placeholder = NSLocalizedString(@"reply", nil);
    [self.writeComment.writeText becomeFirstResponder];
    self.tagetUserId = self.targetUserId[indexPath.row];
    self.replyCommentId = self.replyId[indexPath.row];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"CommentVcTitle", nil);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

#pragma mark -
- (NSMutableArray *)commentListMarr {
    if (!_commentListMarr) {
        _commentListMarr = [NSMutableArray array];
    }
    return _commentListMarr;
}

- (NSMutableArray *)targetUserId {
    if (!_targetUserId) {
        _targetUserId = [NSMutableArray array];
    }
    return _targetUserId;
}

- (NSMutableArray *)replyId {
    if (!_replyId) {
        _replyId = [NSMutableArray array];
    }
    return _replyId;
}

@end
