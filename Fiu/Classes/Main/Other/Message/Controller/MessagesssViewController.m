//
//  MessagesssViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MessagesssViewController.h"
#import "CommentsTableViewCell.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "MJRefresh.h"
#import "DirectMessagesViewController.h"


@interface MessagesssViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_modelAry;
}
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@end

@implementation MessagesssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelAry = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"私信";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    
    self.myTbaleView.rowHeight = 65;
    
    
    
    // 下拉刷新
    self.myTbaleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [_modelAry removeAllObjects];
        [self requestDataForOderList];
    }];
    
    //上拉加载更多
    self.myTbaleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self requestDataForOderListOperation];
        } else {
            [self.myTbaleView.mj_footer endRefreshing];
        }
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进行网络请求
    [self requestDataForOderList];
}

#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [_modelAry removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
}

- (void)requestDataForOderListOperation
{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/message" requestDictionary:@{@"page":@(_currentPageNumber+1),@"size":@15,@"from_user_id":entity.userId,@"type":@0} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"私信丫丫丫result  %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *usersDict = [rowsDict objectForKey:@"users"];
            NSDictionary *toUserDict = [usersDict objectForKey:@"from_user"];
            UserInfo *model = [[UserInfo alloc] init];
            model.userId = toUserDict[@"id"];
            model.summary = rowsDict[@"last_content"][@"content"];
            model.nickname = toUserDict[@"nickname"];
            model.mediumAvatarUrl = toUserDict[@"big_avatar_url"];
            model.birthday = rowsDict[@"last_time_at"];
            model.firstLogin = rowsDict[@"is_read"];
            NSLog(@"时间啊啊   %@",rowsDict[@"last_time_at"]);
            [_modelAry addObject:model];
        }
        if (_modelAry.count == 0) {
            [self.view addSubview:self.tipLabel];
            _tipLabel.text = @"快去找人聊天吧";
            [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(200, 30));
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.top.mas_equalTo(self.view.mas_top).with.offset(200);
            }];
        }else{
            [self.tipLabel removeFromSuperview];
        }
        
        [self.myTbaleView reloadData];
        
        
        _currentPageNumber = [[[result valueForKey:@"data"] valueForKey:@"current_page"] intValue];
        _totalPageNumber = [[[result valueForKey:@"data"] valueForKey:@"total_page"] intValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.myTbaleView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.myTbaleView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            self.myTbaleView.mj_footer.state = MJRefreshStateNoMoreData;
            self.myTbaleView.mj_footer.hidden = true;
        }
        
        if ([self.myTbaleView.mj_header isRefreshing]) {
            [self.myTbaleView.mj_header endRefreshing];
        }
        if ([self.myTbaleView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [self.myTbaleView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [self.myTbaleView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}


-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellOne";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_modelAry.count == 0) {
        
    }else{
        UserInfo *model = _modelAry[indexPath.row];
        [cell setUIWithModel:model];
        cell.iconImageView.hidden = YES;
        cell.focusBtn.hidden = YES;
        cell.timeLabel.hidden = YES;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfo *model = _modelAry[indexPath.row];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    DirectMessagesViewController *vc = [story instantiateViewControllerWithIdentifier:@"DirectMessagesViewController"];
    vc.nickName = model.nickname;
    vc.userId = model.userId;
    vc.otherIconImageUrl = model.mediumAvatarUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
