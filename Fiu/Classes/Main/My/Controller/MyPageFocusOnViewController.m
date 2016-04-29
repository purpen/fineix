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

@interface MyPageFocusOnViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
{
    NSMutableArray *_modelAry;
    int _page;
}
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
    
    //请求数据
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_page),@"size":@15,@"user_id":self.userId,@"find_type":@1} delegate:self];
    request.flag = @"follow";
    [request startRequest];
    
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(1),@"size":@15,@"user_id":self.userId,@"find_type":@1} delegate:self];
        request.flag = @"follow";
        [request startRequest];
        [self.mytableView.mj_header endRefreshing];
    }];
    
    self.mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page++;
        FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_page),@"size":@15,@"user_id":self.userId,@"find_type":@1} delegate:self];
        request.flag = @"follow";
        [request startRequest];
        [self.mytableView.mj_header endRefreshing];
    }];
    
    [self.view addSubview:self.mytableView];
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:@"follow"]) {
        NSLog(@"result  %@",result);
        if ([result objectForKey:@"success"]) {
            NSDictionary *dataDict = [result objectForKey:@"data"];
            NSArray *rowsAry = [dataDict objectForKey:@"rows"];
            for (NSDictionary *rowsDict in rowsAry) {
                NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
                UserInfo *model = [[UserInfo alloc] init];
                model.userId = followsDict[@"user_id"];
                model.summary = followsDict[@"summary"];
                model.nickname = followsDict[@"nickname"];
                model.mediumAvatarUrl = followsDict[@"avatar_url"];
                [_modelAry addObject:model];
            }
            if (_modelAry.count == [dataDict[@"total_rows"] integerValue]) {
                [self.mytableView.mj_footer endRefreshingWithNoMoreData];
                self.mytableView.mj_footer.hidden = YES;
            }else{
                
            }
            if (_modelAry.count == 0) {
                self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }else{
                self.mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
        }

    }else if ([request.flag isEqualToString:@"/follow/ajax_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }
    }else if ([request.flag isEqualToString:@"/follow/ajax_cancel_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
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
    UserInfo *model = _modelAry[indexPath.row];
    cell.focusOnBtn.tag = [model.userId intValue];
    [cell setUIWithModel:[_modelAry objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageViewController *v = [[HomePageViewController alloc] init];
    UserInfo *model = _modelAry[indexPath.row];
    v.userId = model.userId;
    v.isMySelf = NO;
    v.type = @1;
    [self.navigationController pushViewController:v animated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":@(sender.tag)} delegate:self];
        request.flag = @"/follow/ajax_follow";
        [request startRequest];
    }else{
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":@(sender.tag)} delegate:self];
        request.flag = @"/follow/ajax_cancel_follow";
        [request startRequest];
    }
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
