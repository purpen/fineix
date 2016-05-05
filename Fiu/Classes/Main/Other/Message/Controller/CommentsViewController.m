//
//  CommentsViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsTableViewCell.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "MJRefresh.h"
#import "SceneInfoViewController.h"

@interface CommentsViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_modelAry;
    NSMutableArray *_sceneIdMarr;
    int _page;
    int _totalePage;
}
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelAry = [NSMutableArray array];
    _sceneIdMarr = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"评论";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    
    self.myTbaleView.rowHeight = 65;
    //进行网络请求
    [self networkRequestData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/comment/getlist" requestDictionary:@{@"page":@(_page+1),@"size":@15,@"user_id":entity.userId,@"type":@12} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"评论丫丫丫result  %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *usersDict = [rowsDict objectForKey:@"user"];
            UserInfo *model = [[UserInfo alloc] init];
            model.userId = usersDict[@"_id"];
            model.summary = rowsDict[@"content"];
            model.nickname = usersDict[@"nickname"];
            model.mediumAvatarUrl = usersDict[@"medium_avatar_url"];
            model.birthday = rowsDict[@"created_at"];
            model.head_pic_url = rowsDict[@"target_small_cover_url"];
            NSLog(@"时间啊啊   %@",rowsDict[@"created_at"]);
            [_modelAry addObject:model];
            NSString *target_id = rowsDict[@"target_id"];
            [_sceneIdMarr addObject:target_id];
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
        _page = [[[result valueForKey:@"data"] valueForKey:@"current_page"] intValue];
        _totalePage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] intValue];
        if (_totalePage > 1) {
            [self addMJRefresh:self.myTbaleView];
            [self requestIsLastData:self.myTbaleView currentPage:_page withTotalPage:_totalePage];
        }
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    
}


-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

//  判断是否为最后一条数据
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


#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self networkRequestData];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_page < _totalePage) {
            [self networkRequestData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
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
    UserInfo *model = _modelAry[indexPath.row];
    [cell setUIWithModel:model];
    cell.focusBtn.hidden = YES;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
    sceneInfoVC.sceneId = _sceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:sceneInfoVC animated:YES];
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
