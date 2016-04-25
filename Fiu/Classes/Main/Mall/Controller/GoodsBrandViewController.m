//
//  GoodsBrandViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsBrandViewController.h"
#import "GoodsBrandTableViewCell.h"

@interface GoodsBrandViewController ()

@end

@implementation GoodsBrandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.goodsBrandTable];
}

#pragma mark - 品牌视图
- (UITableView *)goodsBrandTable {
    if (!_goodsBrandTable) {
        _goodsBrandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
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
    } else {
        return 5;
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
        [cell setUI];
        return cell;
    
    } else {
        static NSString * brandGoodsListCellId = @"BrandGoodsListCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:brandGoodsListCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandGoodsListCellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"商品 %zi", indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsBrandTableViewCell * cell = [[GoodsBrandTableViewCell alloc] init];
        [cell getContentCellHeight:@"Being the savage's bowsman, that is, the person who pulled the bow-oar in his boat (the second one from forward), it was my cheerful duty to attend upon him while taking that hard-scrabble scramble upon the dead whale's back. You have seen Italian organ-boys holding a dancing-ape by a long cord. "];
        return  cell.cellHeight;
    } else {
        return 266.5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBarTransparent];
}

@end
