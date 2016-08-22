//
//  THNActiveResultViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveResultViewController.h"
#import "Fiu.h"
#import "THNSenceModel.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "THNSenecCollectionViewCell.h"
#import "SVProgressHUD.h"

@interface THNActiveResultViewController ()<UITableViewDelegate,UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *contentView;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property (nonatomic, strong) NSDictionary *params;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;

@end

static NSString * collectionViewCellId = @"allSceneCollectionViewCellID";

@implementation THNActiveResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view addSubview:self.contentView];
    [self setUpRefresh];
}

-(UITableView *)contentView{
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 211 - 50)];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        [_contentView registerNib:[UINib nibWithNibName:@"THNSenecCollectionViewCell" bundle:nil] forCellReuseIdentifier:collectionViewCellId];
    }
    return _contentView;
}

-(void)setUpRefresh{
    [self load];
    
    self.contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


-(void)loadMore{
    NSDictionary *params = @{
                             @"page" : @(++self.current_page),
                             @"size" : @8,
                             @"subject_id" : self.id
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            NSArray *ary = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            [self.modelAry addObjectsFromArray:ary];
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contentView.mj_footer endRefreshing];
        }
    } failure:nil];
}


-(void)load{
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"size" : @8,
                             @"subject_id" : self.id
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"文章 %@",result);
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            self.modelAry = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            if (self.params != params) {
                return;
            }
            [self.contentView reloadData];
            [self.contentView.mj_header endRefreshing];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contentView.mj_footer endRefreshing];
        }
    } failure:nil];
}


-(void)checkFooterState{
    self.contentView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.contentView.mj_footer.hidden = YES;
    }else{
        [self.contentView.mj_footer endRefreshing];
    }
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.modelAry.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    THNSenecCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionViewCellId];
////    cell.
//}

@end
