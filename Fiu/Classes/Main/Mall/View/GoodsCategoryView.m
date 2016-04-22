//
//  GoodsCategoryView.m
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCategoryView.h"
#import "GoodsInfoViewController.h"
#import "GoodsTableViewCell.h"

@implementation GoodsCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
    }
    return self;
}

#pragma mark - 改变视图的偏移量
- (void)changeContentOffSet:(NSInteger)index {
    CGPoint contentPoint = self.contentOffset;
    contentPoint.x = SCREEN_WIDTH * index;
    self.contentOffset = contentPoint;
}

#pragma mark - 创建商品列表
- (void)addGoodsCategoryTableView:(NSArray *)number {
    for (NSInteger idx = 0; idx < number.count; ++ idx) {
        UITableView * goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, BOUNDS_HEIGHT) style:(UITableViewStylePlain)];
        goodsTable.delegate = self;
        goodsTable.dataSource = self;
        goodsTable.showsVerticalScrollIndicator = NO;
        goodsTable.showsHorizontalScrollIndicator = NO;
        [self addSubview:goodsTable];
    }
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH * number.count, 0);
}

#pragma mark - tableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * GoodsCategoryCellId = @"GoodsCategoryCellId";
    GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GoodsCategoryCellId];
    if (!cell) {
        cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsCategoryCellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"商品 %zi", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 266.5;
}

#pragma mark - 产看商品的详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝ 跳转到商品详情 %zi", indexPath.row);
    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];

    [self.nav pushViewController:goodsInfoVC animated:YES];
}

@end
