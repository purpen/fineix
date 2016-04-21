//
//  MallMenuTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallMenuTableViewCell.h"
#import "MallMenuCollectionViewCell.h"
#import "GoodsCategoryViewController.h"

@implementation MallMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleArr = @[@"全部", @"智能出行", @"健康周边", @"母婴产品", @"3C数码", @"智能出行", @"健康周边", @"母婴产品"];
        [self addSubview:self.menuView];
    }
    return self;
}

#pragma mark - 情景滑动列表
- (UICollectionView *)menuView {
    if (!_menuView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(60, 105);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        
        _menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105) collectionViewLayout:flowLayout];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.showsVerticalScrollIndicator = NO;
        _menuView.showsHorizontalScrollIndicator = NO;
        [_menuView registerClass:[MallMenuCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _menuView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    MallMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setUI:self.titleArr[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"打开商品分类 ＝＝＝＝＝＝＝＝ %zi", indexPath.row);
    GoodsCategoryViewController * goodsCategoryVC = [[GoodsCategoryViewController alloc] init];
    goodsCategoryVC.categoryTitleArr = self.titleArr;
    [goodsCategoryVC.categoryMenuView updateMenuBtnState:indexPath.row];
    [goodsCategoryVC.goodsCategoryView changeContentOffSet:indexPath.row];
    [self.nav pushViewController:goodsCategoryVC animated:YES];
}
@end
