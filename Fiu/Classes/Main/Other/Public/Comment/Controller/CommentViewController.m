//
//  CommentViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentRow.h"

static NSString *const URLSceneComment = @"/comment/getlist";
static NSString *const URLSendSceneComment = @"/comment/ajax_comment";

@interface CommentViewController ()

@pro_strong NSMutableArray      *   commentListMarr;

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
    self.sceneCommentRequest = [FBAPI getWithUrlString:URLSceneComment requestDictionary:@{@"target_id":self.targetId, @"page":@(self.currentpageNum + 1), @"type":@"12", @"size":@"8"} delegate:self];
    [self.sceneCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            CommentRow * commentModel = [[CommentRow alloc] initWithDictionary:sceneDic];
            [self.commentListMarr addObject:commentModel];
        }
        [self.commentTabel reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        if (self.totalPageNum > 1) {
            [self addMJRefresh:self.commentTabel];
            [self requestIsLastData:self.commentTabel currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 发布评论
- (void)networkSendCommentData {
    if ([self.writeComment.writeText.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写评论"];
    
    } else {
        self.sendCommentRequest = [FBAPI postWithUrlString:URLSendSceneComment requestDictionary:@{@"from_site":@"ios", @"type":@"12", @"target_id":self.targetId, @"content":self.writeComment.writeText.text} delegate:self];
        [self.sendCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSLog(@"＝＝＝＝＝＝＝＝＝＝ ＊＊＊＊＊＊＊＊＊＊  －－－－－－ 提交评论%@", result);
            
        } failure:^(FBRequest *request, NSError *error) {
            
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
//    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.currentpageNum = 0;
//        [self networkSceneCommenstData];
//    }];
//    
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
        [_writeComment.sendBtn addTarget:self action:@selector(networkSendCommentData) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _writeComment;
}

#pragma mark 评论列表
- (UITableView *)commentTabel {
    if (!_commentTabel) {
        _commentTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStylePlain)];
        _commentTabel.delegate = self;
        _commentTabel.dataSource = self;
        _commentTabel.showsVerticalScrollIndicator = NO;
    }
    return _commentTabel;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"commentDataCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %zi 个评论", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"CommentVcTitle", nil);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (NSMutableArray *)commentListMarr {
    if (!_commentListMarr) {
        _commentListMarr = [NSMutableArray array];
    }
    return _commentListMarr;
}

@end
