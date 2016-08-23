//
//  THNAttendSenceViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAttendSenceViewController.h"
#import "UIView+FSExtension.h"
#import "UIColor+Extension.h"
#import "Fiu.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import <MJRefresh.h>
#import "UserInfoEntity.h"
#import "THNSenceModel.h"
#import <MJExtension.h>
#import "SVProgressHUD.h"

@interface THNAttendSenceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) UICollectionView *myCollectionView;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property (nonatomic, strong) NSDictionary *params;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;

@end

static NSString * collectionViewCellId = @"THNDiscoverSceneCollectionViewCell";

@implementation THNAttendSenceViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myCollectionView];
    
    [self setUpRefresh];
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 211 - 50) collectionViewLayout:flowLayout];
        
        _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellId];
    }
    return _myCollectionView;
}



-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(void)setUpRefresh{
    [self load];
    
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)load{
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"size" : @8,
                             @"subject_id" : self.id
                             };
    self.params = params;
    NSLog(@"参与 %@",self.id);
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"参与的情境 %@",result);
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            self.modelAry = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            if (self.params != params) {
                return;
            }
            [self.myCollectionView reloadData];
            [self.myCollectionView.mj_header endRefreshing];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.myCollectionView.mj_footer endRefreshing];
        }
    } failure:nil];
}

-(void)checkFooterState{
    self.myCollectionView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.myCollectionView.mj_footer.hidden = YES;
    }else{
        [self.myCollectionView.mj_footer endRefreshing];
    }
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
            NSLog(@"参与的情境 %@",result);
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            NSArray *ary = [THNSenceModel mj_objectArrayWithKeyValuesArray:rows];
            [self.modelAry addObjectsFromArray:ary];
            if (self.params != params) {
                return;
            }
            [self.myCollectionView reloadData];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.myCollectionView.mj_footer endRefreshing];
        }
    } failure:nil];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    return cell;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelAry.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.3 * SCREEN_HEIGHT);
}

@end
