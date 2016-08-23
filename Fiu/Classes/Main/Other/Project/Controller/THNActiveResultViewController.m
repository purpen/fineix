//
//  THNActiveResultViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveResultViewController.h"
#import "Fiu.h"
#import "THNSenceModel.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "THNSenecCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "HomeSceneListRow.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNSceneCommentTableViewCell.h"

@interface THNActiveResultViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
}

/**  */
@property (nonatomic, strong) UITableView *contentView;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property (nonatomic, strong) NSDictionary *params;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, strong) UILabel *tipLabel;

@end

static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";
static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const commentsCellId = @"CommentsCellId";
static NSString *const twoCommentsCellId = @"TwoCommentsCellId";

@implementation THNActiveResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    [self setUpRefresh];
}


-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 40)];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _tipLabel;
}

-(UITableView *)contentView{
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 211 - 50) style:UITableViewStyleGrouped];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_contentView registerNib:[UINib nibWithNibName:@"THNSenecCollectionViewCell" bundle:nil] forCellReuseIdentifier:collectionViewCellId];
    }
    return _contentView;
}

-(void)setUpRefresh{
    [self load];
    
//    self.contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


-(void)loadMore{
    NSDictionary *params = @{
                             @"page" : @(++self.current_page),
                             @"size" : @8,
                             @"subject_id" : self.id
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"sights"];
            NSArray *ary = [HomeSceneListRow mj_objectArrayWithKeyValuesArray:rows];
            [self.modelAry addObjectsFromArray:ary];
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contentView.mj_footer endRefreshing];
        }
    } failure:nil];
}


-(void)load{
    self.current_page = 1;
    NSDictionary *params = @{
                             @"id" : self.id
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"活动结果 %@",result);
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"sights"];
            self.modelAry = [HomeSceneListRow mj_objectArrayWithKeyValuesArray:rows];
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
            [self.contentView.mj_header endRefreshing];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contentView.mj_footer endRefreshing];
        }
    } failure:nil];
}


-(void)checkFooterState{
    self.contentView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.contentView.mj_footer.hidden = YES;
    }else{
        [self.contentView.mj_footer endRefreshing];
    }
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        if (self.modelAry.count) {
            [cell thn_setHomeSceneUserInfoData:self.modelAry[indexPath.section]];
        }
        return cell;
        
    } else if (indexPath.row == 1) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        if (self.modelAry.count) {
            [cell thn_setSceneImageData:self.modelAry[indexPath.section]];
        }
        cell.nav = self.navigationController;
        return cell;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    } else if (indexPath.row == 1) {
        return SCREEN_WIDTH;
    } else if (indexPath.row == 2) {
        return 40;
    } else if (indexPath.row == 3) {
        return _contentHigh;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [headView addSubview:self.tipLabel];
    self.tipLabel.text = ((HomeSceneListRow*)self.modelAry[section]).prize;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
