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

static const NSInteger BuyBtnTag = 754;

@interface GoodsInfoViewController ()

@end

@implementation GoodsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGoodsInfoVcUI];
    
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

#pragma mark - 去购买&加入购物车
- (UIView *)buyView {
    if (!_buyView) {
        _buyView = [[UIView alloc] init];
        _buyView.backgroundColor = [UIColor redColor];
//        if (self.goodsType == ) {
        NSArray * btnTitleArr = @[NSLocalizedString(@"addGoodsCar", nil), NSLocalizedString(@"buyingGoods", nil)];
        NSArray * btnBgColor = @[@"DB9E18", @"BE8914"];
        for (NSInteger idx = 0; idx < 2; ++ idx) {
            UIButton * buyBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) * idx, 0, SCREEN_WIDTH / 2, 44)];
            [buyBtn setTitle:btnTitleArr[idx] forState:(UIControlStateNormal)];
            [buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [buyBtn setBackgroundColor:[UIColor colorWithHexString:btnBgColor[idx]]];
            buyBtn.titleLabel.font = [UIFont systemFontOfSize:Font_InfoTitle];
            buyBtn.tag = BuyBtnTag + idx;
            [buyBtn addTarget:self action:@selector(buyCarBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
             [_buyView addSubview:buyBtn];
        }
        
//        } else if (self.goodsType == ) {
//        UIButton * gobuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//        [gobuyBtn setTitle:NSLocalizedString(@"goBuyGoods", nil) forState:(UIControlStateNormal)];
//        [gobuyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//        gobuyBtn.titleLabel.font = [UIFont systemFontOfSize:Font_InfoTitle];
//        [_buyView addSubview:gobuyBtn];
//        }
    }
    return _buyView;
}

- (void)buyCarBtnClick:(UIButton *)button {
    if (button.tag == BuyBtnTag) {
        NSLog(@"————————————————————————————加入购物车");
        
    } else if (button.tag == BuyBtnTag + 1) {
        NSLog(@"————————————————————————————立即购买");
    }
}

#pragma mark - 轮播图
- (FBRollImages *)rollImgView {
    if (!_rollImgView) {
        _rollImgView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollImgView.navVC = self.navigationController;
        [_rollImgView setRollimageView];
    }
    return _rollImgView;
}

#pragma mark - 商品信息
- (UITableView *)goodsInfoTable {
    if (!_goodsInfoTable) {
        _goodsInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
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
    return 5;
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
        [cell setUI];
        return cell;
    
    } else if (indexPath.section == 1) {
        static NSString * InfoBrandCellId = @"InfoBrandCellId";
        InfoBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
        if (!cell) {
            cell = [[InfoBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
        }
        [cell setUI];
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString * InfoGoodsHighlightsCellId = @"InfoGoodsHighlightsCellId";
        InfoGoodsHighlightsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoGoodsHighlightsCellId];
        if (!cell) {
            cell = [[InfoGoodsHighlightsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoGoodsHighlightsCellId];
        }
        [cell setUI];
        return cell;
        
    } else if (indexPath.section == 3) {
        static NSString * InfoUseSceneCellId = @"InfoUseSceneCellId";
        InfoUseSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoUseSceneCellId];
        if (!cell) {
            cell = [[InfoUseSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoUseSceneCellId];
        }
        [cell setUI:@[@"午后的星巴克时光", @"长城脚下的巨人", @"极地的阳光", @"最美的不是下雨天，是与你躲雨的屋檐"]];
        return cell;
        
    } else if (indexPath.section == 4) {
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
        InfoGoodsHighlightsTableViewCell * cell = [[InfoGoodsHighlightsTableViewCell alloc] init];
        [cell getContentCellHeight:@"太火鸟致力于帮助设计师和创意者实现商业价值，是中国顶尖的创新产品孵化器兼原创产品社会化电商平台。"];
        return cell.cellHeight;
    } else if (indexPath.section == 3) {
        return 90;
    } else if (indexPath.section == 4) {
        return 280;
    }
    return 100;
}

#pragma mark - 点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GoodsBrandViewController * goodsBrandVC = [[GoodsBrandViewController alloc] init];
        goodsBrandVC.title = @"AMD";
        [self.navigationController pushViewController:goodsBrandVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.title = NSLocalizedString(@"GoodsInfoVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car"];
    self.delegate = self;
    [self navBarNoTransparent];
}

- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊购物车");
}

@end
