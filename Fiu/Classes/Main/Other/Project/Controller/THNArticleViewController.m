//
//  THNArticleViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNArticleViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "THNArticleModel.h"
#import <MJExtension.h>
#import "Fiu.h"
#import "UIView+FSExtension.h"
#import "THNArticleCollectionViewCell.h"
#import <MJRefresh.h>
#import "SVProgressHUD.h"
#import "THNArticleDetalViewController.h"

@interface THNArticleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, strong) UICollectionView *contenView;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSDictionary *params;

@end

static NSString *const cellId = @"THNArticleCollectionViewCell";

@implementation THNArticleViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpRefresh];
    
    [self.view addSubview:self.contenView];
}


-(void)setUpRefresh{
    self.contenView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.contenView.mj_header.automaticallyChangeAlpha = YES;
    [self.contenView.mj_header beginRefreshing];
    
    self.contenView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadNew{
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"size" : @8,
                             @"fine" : @1,
                             @"type" : @1,
                             @"sort" : @2
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"文章 %@",result);
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            self.modelAry = [THNArticleModel mj_objectArrayWithKeyValuesArray:rows];
            if (self.params != params) {
                return;
            }
            [self.contenView reloadData];
            [self.contenView.mj_header endRefreshing];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contenView.mj_footer endRefreshing];
        }
    } failure:nil];

}

-(void)loadMore{
    NSDictionary *params = @{
                             @"page" : @(++self.current_page),
                             @"size" : @8,
                             @"fine" : @1,
                             @"type" : @1,
                             @"sort" : @2
                             };
    self.params = params;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/getlist" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            self.current_page = [result[@"data"][@"current_page"] integerValue];
            self.total_rows = [result[@"data"][@"total_rows"] integerValue];
            NSArray *rows = result[@"data"][@"rows"];
            NSArray *ary = [THNArticleModel mj_objectArrayWithKeyValuesArray:rows];
            [self.modelAry addObjectsFromArray:ary];
            if (self.params != params) {
                return;
            }
            [self.contenView reloadData];
            [self checkFooterState];
        }else{
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.contenView.mj_footer endRefreshing];
        }
    } failure:nil];
}

-(void)checkFooterState{
    self.contenView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.contenView.mj_footer.hidden = YES;
    }else{
        [self.contenView.mj_footer endRefreshing];
    }
}

-(UICollectionView *)contenView{
    if (!_contenView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _contenView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height) collectionViewLayout:layout];
        _contenView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _contenView.showsVerticalScrollIndicator = NO;
        _contenView.delegate = self;
        _contenView.dataSource = self;
        _contenView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        [_contenView registerNib:[UINib nibWithNibName:@"THNArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    return _contenView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    [self checkFooterState];
    return self.modelAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    THNArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 211);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    THNArticleDetalViewController *vc = [[THNArticleDetalViewController alloc] init];
    vc.id = ((THNArticleModel*)self.modelAry[indexPath.row])._id;
    vc.title = @"文章详情";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
