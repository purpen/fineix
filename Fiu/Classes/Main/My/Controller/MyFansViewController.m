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
#import "MJRefresh.h"
#import "HomePageViewController.h"
#import "UserInfoEntity.h"
#import "FocusNonView.h"
#import "UserInfoEntity.h"


@interface MyFansViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
{
    NSMutableArray *_modelAry;
    int _page;
    int _totalePage;
}

@property(nonatomic,strong) FocusNonView *scenarioNonView;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
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
    
    //进行网络请求
    [self requestDataForOderList];
    
    // 下拉刷新
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [_modelAry removeAllObjects];
        [self requestDataForOderList];
    }];
    
    [self.mytableView.mj_header beginRefreshing];
    
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

//void printN(int N){
//    if (!N) return;
//    printN(N-1);
//    printf("%d",N);
//}

#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [_modelAry removeAllObjects];
    
    [self requestDataForOderListOperation];
}




- (void)requestDataForOderListOperation
{
    
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:@{@"page":@(_currentPageNumber+1),@"size":@30,@"user_id":self.userId,@"find_type":@2} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"粉丝 %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
            UserInfo *model = [[UserInfo alloc] init];
            
            model.userId = followsDict[@"user_id"];
            model.summary = followsDict[@"summary"];
            model.nickname = followsDict[@"nickname"];
            model.mediumAvatarUrl = followsDict[@"avatar_url"];
            model.is_love = [rowsDict[@"type"] integerValue];
            model.level = followsDict[@"is_love"];
            model.expert_info = followsDict[@"expert_info"];
            model.expert_label = followsDict[@"expert_label"];
            model.is_expert = followsDict[@"is_expert"];
            //8888888888888888888888
            [_modelAry addObject:model];
        }
        if (_modelAry.count == 0) {
            [self.view addSubview:self.scenarioNonView];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            if ([self.userId isEqual:entity.userId]) {
                self.scenarioNonView.tipLabel.text = @"给你一首歌的时间就回来哦，粉丝们还等着你的新动态呢";
            }else{
                self.scenarioNonView.tipLabel.text = @"众里寻他千百度，爱人之心不可无";
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
     if ([request.flag isEqualToString:@"/follow/ajax_cancel_follow"]){
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    
    UserInfo *model;
    if (_modelAry.count != 0) {
        model = [_modelAry objectAtIndex:indexPath.row];
    }
    
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.focusOnBtn.tag = indexPath.row;
    [cell setUIWithModel:model andType:@1];
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
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([entity.userId isEqualToString:model.userId]) {
                model.is_love = 2;
            }else{
                model.level = @1;
            }
            [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];

        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    UserInfo *model = _modelAry[sender.tag];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if ([entity.userId isEqual:model.userId]) {
        model.is_love = 1;
    }else{
        model.level = @0;
    }
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result objectForKey:@"success"]) {
            
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
@end