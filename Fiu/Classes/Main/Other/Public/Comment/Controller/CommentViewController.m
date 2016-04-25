//
//  CommentViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setCommentViewUI];

}

#pragma mark -
- (void)setCommentViewUI {
    [self.view addSubview:self.commentTabel];
    
    [self.view addSubview:self.writeComment];
    [_writeComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
}

#pragma mark - 填写评论
- (WriteCommentView *)writeComment {
    if (!_writeComment) {
        _writeComment = [[WriteCommentView alloc] init];
    }
    return _writeComment;
}

#pragma mark - 评论列表
- (UITableView *)commentTabel {
    if (!_commentTabel) {
        _commentTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStylePlain)];
        _commentTabel.delegate = self;
        _commentTabel.dataSource = self;
        _commentTabel.showsVerticalScrollIndicator = NO;
    }
    return _commentTabel;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBarNoTransparent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}


@end
