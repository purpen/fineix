//
//  SystemInformsViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SystemInformsViewController.h"
#import "SystemInfoMessageTableViewCell.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "SystemNoticeModel.h"
#import "NSObject+MJKeyValue.h"
#import "FiuSceneViewController.h"
#import "SceneInfoViewController.h"
#import "GoodsInfoViewController.h"
#import "TipNumberView.h"

@interface SystemInformsViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTbaleView;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@property(nonatomic,strong) NSMutableArray *noticeAry;
@end

@implementation SystemInformsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self requestDataForOderList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"系统通知";
    
    self.myTbaleView.delegate = self;
    self.myTbaleView.dataSource = self;
    
    self.myTbaleView.rowHeight = 180/667.0*SCREEN_HEIGHT;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    self.myTbaleView.tableFooterView = view;
    
    
    
    // 下拉刷新
    self.myTbaleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [self.noticeAry removeAllObjects];
        [self requestDataForOderListOperation];
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

- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [self.noticeAry removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
}

- (void)requestDataForOderListOperation
{
    NSDictionary * params = @{@"page": [NSNumber numberWithInteger:(_currentPageNumber + 1)], @"size": @10};
    
    FBRequest * request = [FBAPI postWithUrlString:@"/notice/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        NSArray * rowsAry = [dataDic objectForKey:@"rows"];
        
        for (NSDictionary * rowsDic in rowsAry) {
            SystemNoticeModel * model = [SystemNoticeModel mj_objectWithKeyValues:rowsDic];
            [self.noticeAry addObject:model];
        }
        [self.myTbaleView reloadData];
        _currentPageNumber = [dataDic[@"current_page"] integerValue];
        _totalPageNumber = [dataDic[@"total_page"] integerValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.myTbaleView.mj_footer.state == MJRefreshStateNoMoreData) {
                [_myTbaleView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            _myTbaleView.mj_footer.state = MJRefreshStateNoMoreData;
            _myTbaleView.mj_footer.hidden = true;
        }
        
        if ([_myTbaleView.mj_header isRefreshing]) {
            [_myTbaleView.mj_header endRefreshing];
        }
        if ([_myTbaleView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [_myTbaleView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [_myTbaleView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}


-(NSMutableArray *)noticeAry{
    if (!_noticeAry) {
        _noticeAry = [NSMutableArray array];
    }
    return _noticeAry;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _noticeAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellOne";
    SystemInfoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SystemInfoMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.row < self.num) {
        cell.alertTipView.hidden = NO;
    }else{
        cell.alertTipView.hidden = YES;
    }
    
    if (_noticeAry.count == 0) {
        
    }else{
        SystemNoticeModel *model = _noticeAry[indexPath.row];
        [cell setUIWithModel:model];
    }
    
    cell.detailsBtn.tag = indexPath.row;
    [cell.detailsBtn addTarget:self action:@selector(detailsBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)detailsBtn:(UIButton*)sender{
    SystemInfoMessageTableViewCell *cell = [self.myTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    if (cell.alertTipView.hidden == NO) {
        self.num --;
    }
    SystemNoticeModel *model = _noticeAry[sender.tag];
    if ([model.evt isEqualToNumber:@0]) {
        //网页
        //调用safar打开网页
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }else if ([model.evt isEqualToNumber:@1]){
        //情景
        FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
        fiuSceneVC.fiuSceneId = model.url;
        [self.navigationController pushViewController:fiuSceneVC animated:YES];
    }else if ([model.evt isEqualToNumber:@2]){
        //场景
        SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
        sceneInfoVC.sceneId = model.url;
        [self.navigationController pushViewController:sceneInfoVC animated:YES];
    }else if ([model.evt isEqualToNumber:@3]){
        //产品
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = model.url;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

-(void)rightBarItemSelected{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
