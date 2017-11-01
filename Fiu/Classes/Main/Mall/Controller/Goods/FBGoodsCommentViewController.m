//
//  FBGoodsCommentViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBGoodsCommentViewController.h"
#import "CommentModelRow.h"
#import "FBGoodsCommentTableViewCell.h"
#import "FBBuyGoodsViewController.h"

static NSString *const URLComment = @"/comment/getlist";

@interface FBGoodsCommentViewController () {
    NSString *_idx;
}

@pro_strong NSMutableArray *commentListMarr;    //  评论列表

@end

@implementation FBGoodsCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.commentTabel];
    
    self.currentpageNum = 0;
}

#pragma mark - 网络请求
#pragma mark 请求评论
- (void)networkSceneCommenstData:(NSString *)targetId {
    _idx = targetId;
    [SVProgressHUD show];
    self.commentRequest = [FBAPI getWithUrlString:URLComment requestDictionary:@{@"target_id":targetId, @"page":@(self.currentpageNum + 1), @"type":@"4", @"size":@"20", @"sort":@"1"} delegate:self];
    [self.commentRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            CommentModelRow * commentModel = [[CommentModelRow alloc] initWithDictionary:sceneDic];
            [self.commentListMarr addObject:commentModel];
        }
        if (self.commentListMarr.count == 0) {
            self.commentTabel.tableHeaderView = self.promptLab;
        }
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.commentTabel currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [self.commentTabel reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = YES;
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
        [self networkSceneCommenstData:_idx];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkSceneCommenstData:_idx];
        } else {
            table.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }];
}

#pragma mark - 没有评论的提示
- (UILabel *)promptLab {
    if (!_promptLab) {
        _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
        _promptLab.text = @"购买商品来评论一下吧";
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

#pragma mark 评论列表
- (UITableView *)commentTabel {
    if (!_commentTabel) {
        _commentTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 152) style:(UITableViewStylePlain)];
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
    static NSString * thnCommentDataCellId = @"ThnCommentDataCellId";
    FBGoodsCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:thnCommentDataCellId];
    if (!cell) {
        cell = [[FBGoodsCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:thnCommentDataCellId];
    }
    [cell setCommentModel:self.commentListMarr[indexPath.row]];
    return cell;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navViewTitle.text = NSLocalizedString(@"CommentVcTitle", nil);
    self.navView.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 152);
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

@end
