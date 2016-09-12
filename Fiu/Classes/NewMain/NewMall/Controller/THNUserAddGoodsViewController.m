//
//  THNUserAddGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/9/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNUserAddGoodsViewController.h"
#import "GoodsCarViewController.h"

#import "THNUserAddGoodsTitleTableViewCell.h"
#import "InfoBrandTableViewCell.h"

@interface THNUserAddGoodsViewController ()

@end

@implementation THNUserAddGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.goodsTable];
}

#pragma mark - 品牌图
- (UIImageView *)rollImageView {
    if (!_rollImageView) {
        _rollImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rollImageView.clipsToBounds = YES;
        _rollImageView.image = [UIImage imageNamed:@"user_goods_banner"];
    }
    return _rollImageView;
}

#pragma mark - 商品信息列表
- (UITableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.showsVerticalScrollIndicator = NO;
        _goodsTable.showsHorizontalScrollIndicator = NO;
        _goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsTable.tableHeaderView = self.rollImageView;
    }
    return _goodsTable;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
        static NSString * InfoTitleCellId = @"InfoTitleCellId";
        THNUserAddGoodsTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoTitleCellId];
        cell = [[THNUserAddGoodsTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoTitleCellId];
        cell.goodsTitle.text = self.goodsTitle;
        return cell;
        
//    }
//    else if (indexPath.row == 1) {
//        static NSString * InfoBrandCellId = @"InfoBrandCellId";
//        InfoBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
//        cell = [[InfoBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
//        cell.brandTitle.text = self.brandTitle;
//        return cell;
//    }
//    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
        THNUserAddGoodsTitleTableViewCell * cell = [[THNUserAddGoodsTitleTableViewCell alloc] init];
        [cell getContentCellHeight:self.brandTitle];
        return cell.cellHeight;
//        
//    } else if (indexPath.row == 1) {
//        return 70;
//    }
//    return 0;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = NSLocalizedString(@"niceGoodsInfo", nil);
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"" image:@"mall_car"];
    [self setNavGoodsCarNumLab];
}

- (void)thn_rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

@end
