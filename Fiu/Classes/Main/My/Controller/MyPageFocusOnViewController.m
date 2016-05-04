//
//  MyPageFocusOnViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyPageFocusOnViewController.h"
#import "FocusOnTableViewCell.h"
#import "HomePageViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "UserInfo.h"
#import <SVProgressHUD.h>
#import "MJRefresh.h"
#import "MyFansActionSheetViewController.h"

@interface MyPageFocusOnViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
{
    NSMutableArray *_modelAry;
    int _page;
    int _totalePage;
}

@property(nonatomic,strong) UILabel *tipLabel;

@end

@implementation MyPageFocusOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _modelAry = [NSMutableArray array];
    // Do any additional setup after loading the view.
    //设置导航条
    self.navViewTitle.text = @"关注";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    
    //进行网络请求
    [self networkRequestData];
    
    [self.view addSubview:self.mytableView];
}

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_page),@"size":@15,@"user_id":self.userId,@"find_type":@1} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"result  %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
            UserInfo *model = [[UserInfo alloc] init];
            
            model.userId = followsDict[@"user_id"];
            NSLog(@"userid             %@",model.userId);
            model.summary = followsDict[@"summary"];
            model.nickname = followsDict[@"nickname"];
            model.mediumAvatarUrl = followsDict[@"avatar_url"];
            [_modelAry addObject:model];
        }
        if (_modelAry.count == 0) {
            [self.view addSubview:self.tipLabel];
            _tipLabel.text = @"快去关注别人吧";
            [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(200, 30));
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.top.mas_equalTo(self.view.mas_top).with.offset(200);
            }];
        }else{
            [self.tipLabel removeFromSuperview];
        }

        [self.mytableView reloadData];
        _page = [[[result valueForKey:@"data"] valueForKey:@"current_page"] intValue];
        _totalePage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] intValue];
        if (_totalePage > 1) {
            [self addMJRefresh:self.mytableView];
            [self requestIsLastData:self.mytableView currentPage:_page withTotalPage:_totalePage];
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

-(void)requestSucess:(FBRequest *)request result:(id)result{
   if ([request.flag isEqualToString:@"/follow/ajax_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }
    }else if ([request.flag isEqualToString:@"/follow/ajax_cancel_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"连接失败"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        self.mytableView.delegate = self;
        self.mytableView.dataSource = self;
        self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mytableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FocusOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FocusOnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    //UserInfo *model = _modelAry[indexPath.row];
    cell.focusOnBtn.tag = indexPath.row;
    cell.focusOnBtn.selected = YES;
    [cell setUIWithModel:[_modelAry objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageViewController *v = [[HomePageViewController alloc] init];
    UserInfo *model = _modelAry[indexPath.row];
    NSLog(@"userId  %@",model.userId);
    v.userId = model.userId;
    v.isMySelf = NO;
    v.type = @1;
    [self.navigationController pushViewController:v animated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        [sheetVC setUI];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        sender.selected = !sender.selected;
        //请求数据
        UserInfo *model = _modelAry[sender.tag];
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
        request.flag = @"/follow/ajax_follow";
        [request startRequest];
    }
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    FocusOnTableViewCell *cell = [_mytableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.focusOnBtn.selected = NO;
    UserInfo *model = _modelAry[sender.tag];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
    request.flag = @"/follow/ajax_cancel_follow";
    [request startRequest];
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55/667.0*SCREEN_HEIGHT;
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
