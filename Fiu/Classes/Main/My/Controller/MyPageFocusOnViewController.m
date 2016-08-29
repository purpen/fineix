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
#import "UserInfoEntity.h"
#import "FocusNonView.h"

@interface MyPageFocusOnViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
{
    NSMutableArray *_modelAry;
}

@property(nonatomic,strong) FocusNonView *scenarioNonView;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;

@end

@implementation MyPageFocusOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelAry = [NSMutableArray array];
    // Do any additional setup after loading the view.
    //设置导航条
    self.navViewTitle.text = @"关注";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.delegate = self;
    
    
    
    // 下拉刷新
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [_modelAry removeAllObjects];
        [self requestDataForOderList];
    }];
    
    //上拉加载更多
    self.mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self requestDataForOderListOperation];
        } else {
            [self.mytableView.mj_footer endRefreshing];
        }
    }];

    
    [self.view addSubview:self.mytableView];
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
    
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_currentPageNumber+1),@"size":@15,@"user_id":self.userId,@"find_type":@1} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            if ([[rowsDict objectForKey:@"follows"] isKindOfClass:[NSArray class]]) {
                
            } else if ([[rowsDict objectForKey:@"follows"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
                UserInfo *model = [[UserInfo alloc] init];
                
                model.is_love = [followsDict[@"is_love"] integerValue];
                model.userId = followsDict[@"user_id"];
                model.summary = followsDict[@"summary"];
                model.nickname = followsDict[@"nickname"];
                model.mediumAvatarUrl = followsDict[@"avatar_url"];
                model.expert_info = followsDict[@"expert_info"];
                model.expert_label = followsDict[@"expert_label"];
                model.is_expert = followsDict[@"is_expert"];
                [_modelAry addObject:model];
            }
            
        }
        if (_modelAry.count == 0) {
            [self.view addSubview:self.scenarioNonView];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            if ([self.userId isEqual:entity.userId]) {
                self.scenarioNonView.tipLabel.text = @"偷偷告诉你：关注越多，推送越精准哦";
            }else{
                self.scenarioNonView.tipLabel.text = @"你一定是想关注我，才点进来的对吧";
            }
            [_scenarioNonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
                make.left.mas_equalTo(self.view.mas_left).with.offset(0);
                make.top.mas_equalTo(self.view.mas_top).with.offset(64);
            }];
        }else{
            [self.scenarioNonView removeFromSuperview];
        }
        
        [self.mytableView reloadData];

        
        _currentPageNumber = [[[result valueForKey:@"data"] valueForKey:@"current_page"] intValue];
        _totalPageNumber = [[[result valueForKey:@"data"] valueForKey:@"total_page"] intValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.mytableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.mytableView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            self.mytableView.mj_footer.state = MJRefreshStateNoMoreData;
            self.mytableView.mj_footer.hidden = true;
        }
        
        if ([self.mytableView.mj_header isRefreshing]) {
            [self.mytableView.mj_header endRefreshing];
        }
        if ([self.mytableView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [self.mytableView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [self.mytableView.mj_footer endRefreshing];
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}



-(FocusNonView *)scenarioNonView{
    if (!_scenarioNonView) {
        _scenarioNonView = [FocusNonView getFocusNonView];
    }
    return _scenarioNonView;
}



-(void)requestSucess:(FBRequest *)request result:(id)result{
   if ([request.flag isEqualToString:@"/follow/ajax_follow"]){
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"关注失败"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //self.navigationController.navigationBarHidden = NO;
    //进行网络请求
    [self requestDataForOderList];
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _mytableView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
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
    cell.focusOnBtn.tag = indexPath.row;
    if (_modelAry.count == 0) {
        
    }else{
        [cell setUIWithModel:[_modelAry objectAtIndex:indexPath.row] andType:@0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageViewController *v = [[HomePageViewController alloc] init];
    UserInfo *model = _modelAry[indexPath.row];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    v.userId = model.userId;
    if ([entity.userId integerValue] == [model.userId integerValue]) {
        v.isMySelf = YES;
    }else{
        v.isMySelf = NO;
    }
    v.type = @2;
    [self.navigationController pushViewController:v animated:YES];
}

-(void)clickFocusBtn:(UIButton*)sender{
    
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        UserInfo *model = _modelAry[sender.tag];
        [sheetVC setUIWithModel:model];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UserInfo *model = _modelAry[sender.tag];
        
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            model.is_love = 1;
            [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    UserInfo *model = _modelAry[sender.tag];
    model.is_love = 0;
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result objectForKey:@"success"]) {
            FocusOnTableViewCell *cell = [self.mytableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
            cell.focusOnBtn.backgroundColor = [UIColor whiteColor];
            cell.focusOnBtn.layer.borderWidth = 1;
            cell.focusOnBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }else{
        }
    } failure:nil];
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
