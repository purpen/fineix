//
//  MyFansViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyFansViewController.h"
#import "FocusOnTableViewCell.h"
#import "MyFansActionSheetViewController.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"

@interface MyFansViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
{
    NSMutableArray *_modelAry;
    int _page;
}
@end

@implementation MyFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    _modelAry = [NSMutableArray array];
    //设置导航条
    self.navViewTitle.text = @"粉丝";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    
    //self.navigationController.navigationBarHidden = NO;
    
    //请求数据
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_page),@"size":@15,@"user_id":self.userId,@"find_type":@2} delegate:self];
    request.flag = @"follow";
    [request startRequest];
    
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(1),@"size":@15,@"user_id":self.userId,@"find_type":@2} delegate:self];
        request.flag = @"follow";
        [request startRequest];
        [self.mytableView.mj_header endRefreshing];
    }];
    
    self.mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _page++;
        FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_page),@"size":@15,@"user_id":self.userId,@"find_type":@2} delegate:self];
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
    cell.focusOnBtn.tag = indexPath.row;
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell setUIWithModel:[_modelAry objectAtIndex:indexPath.row]];
    return cell;
}

-(void)clickFocusBtn:(UIButton*)sender{
//    sender.selected = !sender.selected;
//    if (!sender.selected) {
//        
//        //请求数据
//        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":@(sender.tag)} delegate:self];
//        request.flag = @"/follow/ajax_follow";
//        [request startRequest];
//    }else{
//        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
//        [sheetVC setUI];
//        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [self presentViewController:sheetVC animated:NO completion:nil];
//        sheetVC.stopBtn.tag = sender.tag;
//        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        [sheetVC setUI];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:sheetVC animated:NO completion:nil];
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
    [self dismissViewControllerAnimated:NO completion:nil];
    FocusOnTableViewCell *cell = [_mytableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.focusOnBtn.selected = NO;
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":@(sender.tag)} delegate:self];
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



@end
