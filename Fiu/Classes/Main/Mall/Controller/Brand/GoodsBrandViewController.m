//
//  GoodsBrandViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsBrandViewController.h"
#import "GoodsBrandTableViewCell.h"
#import "BrandInfoData.h"
#import "GoodsRow.h"
#import "GoodsTableViewCell.h"
#import "GoodsInfoViewController.h"

static NSString *const URLBrandInfo = @"/scene_brands/view";
static NSString *const URLGoodslist = @"/scene_product/getlist";

@interface GoodsBrandViewController ()

@pro_strong BrandInfoData               *   brandInfo;
@pro_strong NSMutableArray              *   goodsList;
@pro_strong NSMutableArray              *   goodsIdList;

@end

@implementation GoodsBrandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkBrandInfoData];
    [self networkBrandGoodsList];
    [self.view addSubview:self.goodsBrandTable];
}

#pragma mark - 网络请求
#pragma mark 品牌详情
- (void)networkBrandInfoData {
    self.brandRequest = [FBAPI getWithUrlString:URLBrandInfo requestDictionary:@{@"id":self.brandId} delegate:self];
    [self.brandRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.brandInfo = [[BrandInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        self.title = [[result valueForKey:@"data"] valueForKey:@"title"];
        self.titleLab.text = self.title;
        [self.view addSubview:self.titleLab];
        [self.goodsBrandTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 品牌商品
- (void)networkBrandGoodsList  {
    [SVProgressHUD show];
    self.brandGoodsRequest = [FBAPI getWithUrlString:URLGoodslist requestDictionary:@{@"size":@"8", @"page":@(self.currentpageNum + 1), @"brand_id":self.brandId} delegate:self];
    [self.brandGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsList addObject:goodsModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
    
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        if (self.totalPageNum > 1) {
            [self addMJRefresh:self.goodsBrandTable];
            [self requestIsLastData:self.goodsBrandTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        }
        [self.goodsBrandTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];

}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    } else {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark 上拉加载
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkBrandGoodsList];
            
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 品牌视图
- (UITableView *)goodsBrandTable {
    if (!_goodsBrandTable) {
        _goodsBrandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, SCREEN_HEIGHT + 40) style:(UITableViewStyleGrouped)];
        _goodsBrandTable.showsVerticalScrollIndicator = NO;
        _goodsBrandTable.showsHorizontalScrollIndicator = NO;
        _goodsBrandTable.delegate = self;
        _goodsBrandTable.dataSource = self;
        _goodsBrandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsBrandTable.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _goodsBrandTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else  {
        return self.goodsList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * goodsBrandCellId = @"GoodsBrandCellId";
        GoodsBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsBrandCellId];
        if (!cell) {
            cell = [[GoodsBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsBrandCellId];
        }
        [cell setBrandInfoData:self.brandInfo];
        return cell;
    
    } else {
        static NSString * brandGoodsCellId = @"BrandGoodsCellId";
        GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:brandGoodsCellId];
        cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandGoodsCellId];
        
        cell.nav = self.navigationController;
        [cell setGoodsData:self.goodsList[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsBrandTableViewCell * cell = [[GoodsBrandTableViewCell alloc] init];
        [cell getContentCellHeight:self.brandInfo.des];
        return  cell.cellHeight;
    } else {
        return 210;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}
#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"icon_back" isTransparent:YES];
}

- (void)leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

#pragma mark - 控制器标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, 20, 200, 44)];
        if (IS_iOS9) {
            _titleLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        } else {
            _titleLab.font = [UIFont systemFontOfSize:17];
        }
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

#pragma mark - 
- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

- (NSMutableArray *)goodsIdList {
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}


@end
