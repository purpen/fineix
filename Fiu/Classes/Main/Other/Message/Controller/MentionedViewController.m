//
//  MentionedViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MentionedViewController.h"
#import "CommentsTableViewCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "HomePageViewController.h"
#import "SceneInfoViewController.h"
#import "FiuSceneViewController.h"

@interface MentionedViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_modelAry;
    NSMutableArray *_sceneIdMarr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@end

@implementation MentionedViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进行网络请求
    [self requestDataForOderList];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelAry = [NSMutableArray array];
    _sceneIdMarr = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"提醒";
    
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

- (void)requestDataForOderListOperation
{
    FBRequest *request = [FBAPI postWithUrlString:@"/my/remind_list" requestDictionary:@{@"page":@(_currentPageNumber+1),@"size":@15} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"提醒丫丫丫result  %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *usersDict = [rowsDict objectForKey:@"s_user"];
            UserInfo *model = [[UserInfo alloc] init];
            if (![usersDict[@"_id"] isKindOfClass:[NSNull class]]) {
                model.userId = usersDict[@"_id"];
            }
            if (![rowsDict[@"info"] isKindOfClass:[NSNull class]]) {
                model.summary = rowsDict[@"info"];
            }
            if (![rowsDict[@"kind_str"] isKindOfClass:[NSNull class]]) {
                model.levelDesc = rowsDict[@"kind_str"];
            }
            if (![usersDict[@"nickname"] isKindOfClass:[NSNull class]]) {
                model.nickname = usersDict[@"nickname"];
            }
            if (![usersDict[@"medium_avatar_url"] isKindOfClass:[NSNull class]]) {
                model.mediumAvatarUrl = usersDict[@"medium_avatar_url"];
            }
            if (![rowsDict[@"created_at"] isKindOfClass:[NSNull class]]) {
                model.birthday = rowsDict[@"created_at"];
            }
            if (![rowsDict[@"target_cover_url"] isKindOfClass:[NSNull class]]) {
                model.head_pic_url = rowsDict[@"target_cover_url"];
            }
            if (![rowsDict[@"is_read"] isKindOfClass:[NSNull class]]) {
                model.firstLogin = rowsDict[@"is_read"];
            }
            if (![rowsDict[@"kind"] isKindOfClass:[NSNull class]]) {
                model.sex = rowsDict[@"kind"];
            }
            if (![rowsDict[@"related_id"] isKindOfClass:[NSNull class]]) {
                NSString *target_id = rowsDict[@"related_id"];
                [_sceneIdMarr addObject:target_id];
            }
            
            NSLog(@"时间啊啊   %@",rowsDict[@"created_at"]);
            [_modelAry addObject:model];
            
        }
        if (_modelAry.count == 0) {
            //[self.view addSubview:self.tipLabel];
            //_tipLabel.text = @"快去找人聊天吧";
//            [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(200, 30));
//                make.centerX.mas_equalTo(self.view.mas_centerX);
//                make.top.mas_equalTo(self.view.mas_top).with.offset(200);
//            }];
        }else{
            //[self.tipLabel removeFromSuperview];
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


#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [_modelAry removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
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
        cell.msgLabel.text = [NSString stringWithFormat:@"%@%@",model.summary,model.levelDesc];
        cell.focusBtn.hidden = YES;
        cell.timeLabelTwo.hidden = YES;
        cell.headBtn.tag = indexPath.row;
        [cell.headBtn addTarget:self action:@selector(headBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfo *model = _modelAry[indexPath.row];
    if ([model.sex isEqualToNumber:@12]) {
        //情景
        FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
        fiuSceneVC.fiuSceneId = _sceneIdMarr[indexPath.row];
        [self.navigationController pushViewController:fiuSceneVC animated:YES];
    }else if ([model.sex isEqualToNumber:@13]){
        //场景
        SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
        sceneInfoVC.sceneId = _sceneIdMarr[indexPath.row];
        [self.navigationController pushViewController:sceneInfoVC animated:YES];
    }
}

-(void)headBtn:(UIButton*)sender{
    NSLog(@"头像啊");
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.type = @1;
    vc.isMySelf = NO;
    vc.userId = ((UserInfo*)_modelAry[sender.tag]).userId;
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
