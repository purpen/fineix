//
//  THNDomainGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 2017/5/18.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainGoodsViewController.h"
#import "GoodsRow.h"
#import <MJRefresh/MJRefresh.h>
#import "THNDomainGoodsTableViewCell.h"
#import "THNPromotionGoodsViewController.h"
#import "UIView+TYAlertView.h"
#import "FBRefresh.h"
#import "FBGoodsInfoViewController.h"

static NSString *const GoodsCellId = @"THNDomainGoodsTableViewCellId";
static NSString *const URLProductList = @"/scene_scene/product_list";
static NSString *const URLDelegate = @"/scene_scene/del_product";

@interface THNDomainGoodsViewController ()

@end

@implementation THNDomainGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.goodsTable];
    [self thn_networkGoodsListData:NO];
}
    
#pragma mark - 地盘商品列表
- (void)thn_networkGoodsListData:(BOOL)remove {
    [SVProgressHUD show];
    self.goodsRequests = [FBAPI getWithUrlString:URLProductList requestDictionary:@{@"page":@(self.goodsCurrentpageNum + 1),
                                                                                    @"size":@"10",
                                                                                    @"sort":@"0",
                                                                                    @"scene_id":self.domainId} delegate:nil];
    [self.goodsRequests startRequestSuccess:^(FBRequest *request, id result) {
        if (remove) {
            [self.goodsListMarr removeAllObjects];
            [self.goodsIdMarr removeAllObjects];
            [self.idMarr removeAllObjects];
        }
        
//        NSLog(@"===== 地盘商品 %@", result);
        NSArray *goodsArr = [[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"product"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.idMarr addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
        
        NSArray *goodsIdArr = [[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"];
        [self.goodsIdMarr addObjectsFromArray:goodsIdArr];
        
        [self.goodsTable reloadData];
        self.goodsCurrentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.goodsTotalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsTable currentPage:self.goodsCurrentpageNum withTotalPage:self.goodsTotalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}
    
#pragma mark  是否分页加载
- (void)requestIsLastData:(UIScrollView *)scrollView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if ([scrollView.mj_header isRefreshing]) {
        [scrollView.mj_header endRefreshing];
    }
    
    if (total == 0) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (scrollView.mj_footer.state == MJRefreshStateNoMoreData) {
            [scrollView.mj_footer resetNoMoreData];
        }
    }
    
    if (current == total == 1) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    if ([scrollView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [scrollView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 地盘商品列表
- (void)thn_networkDelegateGoods:(NSString *)goodsId tableIndexPath:(NSIndexPath *)indexPath {
    self.delegateRequest = [FBAPI postWithUrlString:URLDelegate requestDictionary:@{@"id":goodsId} delegate:nil];
    [self.delegateRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
//            NSLog(@"----------- 删除了商品%@", result);
            NSInteger index = [self.goodsIdMarr indexOfObject:goodsId];
            [self.goodsListMarr removeObjectAtIndex:index];
            [self.idMarr removeObjectAtIndex:index];
            [self.goodsIdMarr removeObject:goodsId];
            [self.goodsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            
            [SVProgressHUD showSuccessWithStatus:@"已删除"];
        }
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"-- %@ --", error);
    }];
}

#pragma mark 加载商品的列表
- (UITableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsTable.showsVerticalScrollIndicator = NO;
//        _goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTable.tableFooterView = [UIView new];
        [self addMJRefresh:_goodsTable];
    }
    return _goodsTable;
}

/**
 下拉刷新
 */
- (void)addMJRefresh:(UITableView *)table {
    FBRefresh *header = [FBRefresh headerWithRefreshingBlock:^{
        self.goodsCurrentpageNum = 0;
        [self thn_networkGoodsListData:YES];
    }];
    table.mj_header = header;
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.goodsCurrentpageNum < self.goodsTotalPageNum) {
            [self thn_networkGoodsListData:NO];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsListMarr.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCellId];
    if (!cell) {
        cell = [[THNDomainGoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsCellId];
    }
    if (self.goodsListMarr.count) {
        [cell thn_setGoodsItemData:self.goodsListMarr[indexPath.row] chooseHidden:YES domainId:self.domainId];
    }
    return cell;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
    goodsInfoVC.storageId = _domainId;
    goodsInfoVC.goodsID = self.idMarr[indexPath.row];
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

#pragma mark - 删除商品
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"确认删除商品？" message:nil];
        alertView.layer.cornerRadius = 5;
        alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
        TYAlertAction *cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
            [tableView setEditing:false];
        }];
        TYAlertAction *confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
            [self thn_networkDelegateGoods:self.goodsIdMarr[indexPath.row] tableIndexPath:indexPath];
        }];
        [alertView addAction:cancel];
        [alertView addAction:confirm];
        [alertView showInWindowWithBackgoundTapDismissEnable:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"商品列表";
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"添加商品" image:@""];
}

- (void)thn_rightBarItemSelected {
    THNPromotionGoodsViewController *promotionGoodsVC = [[THNPromotionGoodsViewController alloc] init];
    promotionGoodsVC.domainId = self.domainId;
    [self.navigationController pushViewController:promotionGoodsVC animated:YES];
}
    
#pragma mark - NSMutableArray
- (NSMutableArray *)goodsListMarr {
    if (!_goodsListMarr) {
        _goodsListMarr = [NSMutableArray array];
    }
    return _goodsListMarr;
}
    
- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
}

- (NSMutableArray *)idMarr {
    if (!_idMarr) {
        _idMarr = [NSMutableArray array];
    }
    return _idMarr;
}

@end
