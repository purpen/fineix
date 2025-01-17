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
#import "THNUserData.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "HomePageViewController.h"
#import "FocusNonView.h"
#import "TipNumberView.h"
#import "THNMacro.h"

@interface MyFansViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>

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

@implementation MyFansViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navViewTitle.text = @"粉丝";
    [self setUpRefresh];
    [self.view addSubview:self.mytableView];
}


//void printN(int N){
//    if (!N) return;
//    printN(N-1);
//    printf("%d",N);
//}

-(void)setUpRefresh{
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.mytableView.mj_header.automaticallyChangeAlpha = YES;
    [self.mytableView.mj_header beginRefreshing];
    
    self.mytableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


-(void)loadNew{
    [self.mytableView.mj_footer endRefreshing];
    [self.modelAry removeAllObjects];
    self.current_page = 1;
    NSDictionary *params = @{@"page":@(self.current_page),@"size":@30,@"user_id":self.userId,@"find_type":@2, @"clean_remind":self.cleanRemind};
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
            THNUserData *model = [[THNUserData alloc] init];
            
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
            THNUserData *userdata = [[THNUserData findAll] lastObject];
            if ([self.userId isEqual:userdata.userId]) {
                self.scenarioNonView.tipLabel.text = @"给你一首歌的时间就回来哦，粉丝们还等着你的新动态呢";
            }else{
                self.scenarioNonView.tipLabel.text = @"众里寻他千百度，爱人之心不可无";
            }
            [_scenarioNonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
                make.left.mas_equalTo(self.view.mas_left).with.offset(0);
                if (Is_iPhoneX) {
                    make.top.mas_equalTo(self.view.mas_top).with.offset(88);
                } else {
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

-(void)loadMore{
    [self.mytableView.mj_header endRefreshing];
    NSDictionary *params = @{@"page":@(++self.current_page),@"size":@30,@"user_id":self.userId,@"find_type":@2};
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/follow" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *followsDict = [rowsDict objectForKey:@"follows"];
            THNUserData *model = [[THNUserData alloc] init];
            
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mytableView{
    if (!_mytableView) {
        if (SCREEN_HEIGHT == 812) {
            _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88) style:UITableViewStylePlain];
        } else {
           _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        }
        _mytableView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        if (indexPath.row < self.num) {
            cell.alertTipviewNum.hidden = NO;
        }else{
            cell.alertTipviewNum.hidden = YES;
        }
    }
    
    [cell.focusOnBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.focusOnBtn.tag = indexPath.row;
    [cell setUIWithModel:model andType:@1];
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
        THNUserData *userdata = [[THNUserData findAll] lastObject];
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([userdata.userId isEqualToString:model.userId]) {
                model.is_love = 2;
            }else{
                model.level = @1;
            }
            [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            FBRequest *numRequest = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":self.userId} delegate:self];
            [numRequest startRequestSuccess:^(FBRequest *request, id result) {
                NSDictionary *dataDict = result[@"data"];
                if ([self.fansQuantityDelegate respondsToSelector:@selector(updateTheFansQuantity:)]) {
                    [self.fansQuantityDelegate updateTheFansQuantity:[dataDict[@"follow_count"] integerValue]];
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
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if ([userdata.userId isEqual:model.userId]) {
        model.is_love = 1;
    }else{
        model.level = @0;
    }
    [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        FBRequest *numRequest = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":self.userId} delegate:self];
        [numRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            if ([self.fansQuantityDelegate respondsToSelector:@selector(updateTheFansQuantity:)]) {
                [self.fansQuantityDelegate updateTheFansQuantity:[dataDict[@"follow_count"] integerValue]];
            }
        } failure:^(FBRequest *request, NSError *error) {
        }];
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
