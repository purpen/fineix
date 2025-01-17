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
#import "THNUserData.h"
#import "MJRefresh.h"
#import "HomePageViewController.h"
#import "TipNumberView.h"
#import "THNSceneDetalViewController.h"
#import "CommentNViewController.h"

@interface CommentsViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_modelAry;
    NSMutableArray *_sceneIdMarr;
    int _page;
    int _totalePage;
}
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;

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
    
    // 下拉刷新
    self.myTbaleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [_modelAry removeAllObjects];
        [self requestDataForOderList];
    }];
    
    [self.myTbaleView.mj_header beginRefreshing];
    
    //上拉加载更多
    self.myTbaleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self requestDataForOderListOperation];
        } else {
            [self.myTbaleView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [_modelAry removeAllObjects];
    
    [self requestDataForOderListOperation];
}

- (void)requestDataForOderListOperation
{
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    FBRequest *request = [FBAPI postWithUrlString:@"/my/comment_list" requestDictionary:@{@"page":@(_currentPageNumber+1),@"size":@15,@"target_user_id":userdata.userId,@"type":@12} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"rows"];
        
        for (NSDictionary *rowsDict in rowsAry) {
            NSDictionary *usersDict = [rowsDict objectForKey:@"user"];
            THNUserData *model = [[THNUserData alloc] init];
            if (![usersDict[@"_id"] isKindOfClass:[NSNull class]]) {
                model.userId = usersDict[@"_id"];
            }
            if (![rowsDict[@"content"] isKindOfClass:[NSNull class]]) {
                model.summary = rowsDict[@"content"];
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
            if (![rowsDict[@"target_small_cover_url"] isKindOfClass:[NSNull class]]) {
                model.head_pic_url = rowsDict[@"target_small_cover_url"];
            }
            if (![rowsDict[@"target_id"] isKindOfClass:[NSNull class]]) {
                NSString *target_id = rowsDict[@"target_id"];
                [_sceneIdMarr addObject:target_id];
            }
            [_modelAry addObject:model];
            
        }
//        if (_modelAry.count == 0) {
//            [self.view addSubview:self.tipLabel];
//            _tipLabel.text = @"快去找人聊天吧";
//            [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(200, 30));
//                make.centerX.mas_equalTo(self.view.mas_centerX);
//                make.top.mas_equalTo(self.view.mas_top).with.offset(200);
//            }];
//        }else{
//            [self.tipLabel removeFromSuperview];
//        }
        
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}



-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        if (IS_iOS9) {
            _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _tipLabel.font = [UIFont systemFontOfSize:13];
        }
    }
    return _tipLabel;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellOne";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.navi = self.navigationController;
    cell.scenceId = _sceneIdMarr[indexPath.row];
    if (cell == nil) {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_modelAry.count == 0) {
    }else{
        UserInfo *model = _modelAry[indexPath.row];
        [cell setUIWithModel:model];
        if (indexPath.row < self.num) {
            cell.alertTipviewNum.hidden = NO;
        }else{
            cell.alertTipviewNum.hidden = YES;
        }
        cell.focusBtn.hidden = YES;
        cell.timeLabelTwo.hidden = YES;
        cell.headBtn.tag = indexPath.row;
        cell.iconBtn.tag = indexPath.row;
        [cell.headBtn addTarget:self action:@selector(headBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(void)iconBtnClick:(UIButton*)sender{
    THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
    NSLog(@"id  %@",_sceneIdMarr[sender.tag]);
    vc.sceneDetalId = _sceneIdMarr[sender.tag];
    
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/view" requestDictionary:@{
                                                                                           @"id" : _sceneIdMarr[sender.tag]
                                                                                           } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.navigationController pushViewController:vc animated:YES];
    } failure:nil];
}

-(void)headBtn:(UIButton*)sender{
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.type = @2;
    vc.isMySelf = NO;
    vc.userId = ((THNUserData*)_modelAry[sender.tag]).userId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    THNUserData *model = _modelAry[indexPath.row];
    CommentNViewController * commentVC = [[CommentNViewController alloc] init];
    commentVC.targetId = _sceneIdMarr[indexPath.row];
    commentVC.sceneUserId = model.userId;
    [self.navigationController pushViewController:commentVC animated:YES];
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
