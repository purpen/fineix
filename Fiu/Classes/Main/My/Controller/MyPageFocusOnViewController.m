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
#import "THNUserData.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "MyFansActionSheetViewController.h"
#import "FocusNonView.h"
#import "TipNumberView.h"
#import "THNMacro.h"

@interface MyPageFocusOnViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>


@property(nonatomic,strong) FocusNonView *scenarioNonView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property (nonatomic, strong) NSDictionary *params;
/**  */
@property(nonatomic,assign) NSInteger total_rows;

@end

@implementation MyPageFocusOnViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    self.navViewTitle.text = @"关注";
    [self setUpRefresh];
    [self.view addSubview:self.mytableView];
}

-(void)setUpRefresh{
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.mytableView.mj_header.automaticallyChangeAlpha = YES;
    [self.mytableView.mj_header beginRefreshing];
    
    self.mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadMore{
    [self.mytableView.mj_header endRefreshing];
    NSDictionary *params = @{@"page":@(++self.current_page),@"size":@30,@"user_id":self.userId,@"find_type":@1};
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            if ([[rowsDict objectForKey:@"follows"] isKindOfClass:[NSArray class]]) {
                
            } else if ([[rowsDict objectForKey:@"follows"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
                THNUserData *model = [[THNUserData alloc] init];
                
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
        
        [self.mytableView reloadData];
        
        self.current_page = [result[@"data"][@"current_page"] integerValue];
        self.total_rows = [result[@"data"][@"total_rows"] integerValue];
        if (self.params != params) {
            return;
        }
        [self checkFooterState];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        [self.mytableView.mj_footer endRefreshing];
    }];
}

-(void)loadNew{
    [self.mytableView.mj_footer endRefreshing];
    [self.modelAry removeAllObjects];
    self.current_page = 1;
    NSDictionary *params = @{@"page":@(self.current_page),@"size":@30,@"user_id":self.userId,@"find_type":@1};
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            if ([[rowsDict objectForKey:@"follows"] isKindOfClass:[NSArray class]]) {
                
            } else if ([[rowsDict objectForKey:@"follows"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
                THNUserData *model = [[THNUserData alloc] init];
                
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
            THNUserData *userdata = [[THNUserData findAll] lastObject];
            if ([self.userId isEqual:userdata.userId]) {
                self.scenarioNonView.tipLabel.text = @"偷偷告诉你：关注越多，推送越精准哦";
            }else{
                self.scenarioNonView.tipLabel.text = @"你一定是想关注我，才点进来的对吧";
            }
            [_scenarioNonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.screenHeight));
                make.left.mas_equalTo(self.view.mas_left).with.offset(0);
                if (Is_iPhoneX) {
                    make.top.mas_equalTo(self.view.mas_top).with.offset(88);
                }else {
                    make.top.mas_equalTo(self.view.mas_top).with.offset(64);
                }
            }];
        }else{
            [self.scenarioNonView removeFromSuperview];
        }
        
        [self.mytableView reloadData];
        
        self.current_page = [result[@"data"][@"current_page"] integerValue];
        self.total_rows = [result[@"data"][@"total_rows"] integerValue];
        if (self.params != params) {
            return;
        }
        [self.mytableView.mj_header endRefreshing];
        [self checkFooterState];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        [self.mytableView.mj_footer endRefreshing];
    }];
    
}

-(void)checkFooterState{
    self.mytableView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.mytableView.mj_footer.hidden = YES;
    }else{
        [self.mytableView.mj_footer endRefreshing];
    }
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
        }else{
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mytableView{
    if (!_mytableView) {
        if (Is_iPhoneX) {
            _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88) style:UITableViewStylePlain];
        } else {
            _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        }
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
    cell.alertTipviewNum.hidden = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageViewController *v = [[HomePageViewController alloc] init];
    THNUserData *model = _modelAry[indexPath.row];
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    v.userId = model.userId;
    if ([userdata.userId integerValue] == [model.userId integerValue]) {
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
        THNUserData *model = _modelAry[sender.tag];
        [sheetVC setUIWithModel:model];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        THNUserData *model = _modelAry[sender.tag];
        
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            model.is_love = 1;
            [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            FBRequest *numRequest = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":self.userId} delegate:self];
            [numRequest startRequestSuccess:^(FBRequest *request, id result) {
                NSDictionary *dataDict = result[@"data"];
                if ([self.focusQuantityDelegate respondsToSelector:@selector(updateTheFocusQuantity:)]) {
                    [self.focusQuantityDelegate updateTheFocusQuantity:[dataDict[@"follow_count"] integerValue]];
                }
            } failure:^(FBRequest *request, NSError *error) {
            }];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    THNUserData *model = _modelAry[sender.tag];
    model.is_love = 0;
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        FBRequest *numRequest = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":self.userId} delegate:self];
        [numRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            if ([self.focusQuantityDelegate respondsToSelector:@selector(updateTheFocusQuantity:)]) {
                [self.focusQuantityDelegate updateTheFocusQuantity:[dataDict[@"follow_count"] integerValue]];
            }
        } failure:^(FBRequest *request, NSError *error) {
        }];
    } failure:nil];
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55/667.0*self.screenHeight;
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
