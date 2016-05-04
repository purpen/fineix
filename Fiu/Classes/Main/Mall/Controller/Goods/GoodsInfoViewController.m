//
//  GoodsInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "InfoTitleTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "InfoGoodsHighlightsTableViewCell.h"
#import "InfoUseSceneTableViewCell.h"
#import "InfoRecommendTableViewCell.h"
#import "GoodsBrandViewController.h"
#import "GoodsCarViewController.h"
#import "GoodsInfoData.h"

static NSString *const URLGoodsInfo = @"/scene_product/view";
static NSString *const URLRecommendGoods = @"/scene_product/getlist";

@interface GoodsInfoViewController ()

@pro_strong GoodsInfoData       *   goodsInfo;

@end

@implementation GoodsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkGoodsInfoData];

}

#pragma mark - 网络请求
#pragma mark 商品详情
- (void)networkGoodsInfoData {
    [SVProgressHUD show];
    
    self.goodsInfoRequest = [FBAPI getWithUrlString:URLGoodsInfo requestDictionary:@{@"id":self.goodsID} delegate:self];
    [self.goodsInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.goodsInfo = [[GoodsInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self setGoodsInfoVcUI];
        [self.rollImgView setGoodsRollimageView:self.goodsInfo];
        [self.goodsInfoTable reloadData];
        NSLog(@"商品详情:%@", result);
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark 相关推荐
- (void)networkRecommendGoodsData:(NSString *)ids {
    self.reGoodsRequest = [FBAPI getWithUrlString:URLRecommendGoods requestDictionary:@{@"category_tag_ids":ids} delegate:self];
    [self.reGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"商品详情中的相关推荐：%@", result);
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark -
- (void)setGoodsInfoVcUI {
    
    [self.view addSubview:self.goodsInfoTable];
    
    [self.view addSubview:self.buyView];
    [_buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.top.equalTo(self.goodsInfoTable.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
    
}

#pragma mark - 去购买
- (UIView *)buyView {
    if (!_buyView) {
        _buyView = [[UIView alloc] init];
        UIButton * gobuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [gobuyBtn setTitle:NSLocalizedString(@"goBuyGoods", nil) forState:(UIControlStateNormal)];
        gobuyBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [gobuyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        gobuyBtn.titleLabel.font = [UIFont systemFontOfSize:Font_InfoTitle];
        [gobuyBtn addTarget:self action:@selector(buyCarBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_buyView addSubview:gobuyBtn];
    }
    return _buyView;
}

- (void)buyCarBtnClick {
    if (self.goodsInfo.kind == 1) {
        NSLog(@"————————————————————————————去购买 太火鸟");
    
    } else if (self.goodsInfo.kind == 2) {
        NSLog(@"————————————————————————————去购买 第三方 %@", self.goodsInfo.link);
    }
    
}

#pragma mark - 轮播图
- (FBRollImages *)rollImgView {
    if (!_rollImgView) {
        _rollImgView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.48)];
        _rollImgView.navVC = self.navigationController;
    }
    return _rollImgView;
}

#pragma mark - 商品信息
- (UITableView *)goodsInfoTable {
    if (!_goodsInfoTable) {
        _goodsInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _goodsInfoTable.delegate = self;
        _goodsInfoTable.dataSource = self;
        _goodsInfoTable.showsHorizontalScrollIndicator = NO;
        _goodsInfoTable.showsVerticalScrollIndicator = NO;
        _goodsInfoTable.tableHeaderView = self.rollImgView;
        _goodsInfoTable.tableFooterView = [UIView new];
    }
    return _goodsInfoTable;
}

#pragma mark - tableViewDelegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * InfoTitleCellId = @"InfoTitleCellId";
        InfoTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoTitleCellId];
        if (!cell) {
            cell = [[InfoTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoTitleCellId];
        }
        [cell setGoodsInfoData:self.goodsInfo];
        return cell;
    
    } else if (indexPath.section == 1) {
        static NSString * InfoBrandCellId = @"InfoBrandCellId";
        InfoBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
        if (!cell) {
            cell = [[InfoBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
        }
        [cell setGoodsBrandData:self.goodsInfo];
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString * InfoUseSceneCellId = @"InfoUseSceneCellId";
        InfoUseSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoUseSceneCellId];
        if (!cell) {
            cell = [[InfoUseSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoUseSceneCellId];
        }
        [cell setUI:@[@"午后的星巴克时光", @"长城脚下的巨人", @"极地的阳光", @"最美的不是下雨天，是与你躲雨的屋檐"]];
        return cell;
        
    } else if (indexPath.section == 3) {
        static NSString * InfoRecommendCellId = @"InfoUseSceneCellId";
        InfoRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoRecommendCellId];
        if (!cell) {
            cell = [[InfoRecommendTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoRecommendCellId];
        }
        cell.nav = self.navigationController;
        return cell;
    }
    
    static NSString * GoodsInfoCellId = @"GoodsInfoCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GoodsInfoCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsInfoCellId];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else if (indexPath.section == 1) {
        return 75;
    } else if (indexPath.section == 2) {
        return 90;
    } else if (indexPath.section == 3) {
        return 280;
    }
    return 100;
}

#pragma mark - 点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GoodsBrandViewController * goodsBrandVC = [[GoodsBrandViewController alloc] init];
        goodsBrandVC.brandId = self.goodsInfo.brandId;
        goodsBrandVC.brandBgImg = self.goodsInfo.coverUrl;
        goodsBrandVC.titleLab.text = self.goodsInfo.brand.title;
        [self.navigationController pushViewController:goodsBrandVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"GoodsInfoVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car" isTransparent:NO];
    self.delegate = self;
}

- (void)rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

@end
