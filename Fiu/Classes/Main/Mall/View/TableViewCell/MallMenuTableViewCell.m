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
        [self addSubview:self.menuView];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 209, SCREEN_WIDTH, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:@"E6E6E6" alpha:.8];
        [self addSubview:lineLab];
        
        [self addSubview:lineLab];
        
    }
    return self;
}

#pragma mark -
- (void)setCategoryData:(NSMutableArray *)category {
    self.rowMarr = category;
    self.titleMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"title"]];
    [self.titleMarr insertObject:NSLocalizedString(@"AllGoods", nil) atIndex:0];
    self.categoryIdMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"tagId"]];
    self.idMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"idField"]];
    [self.menuView reloadData];
}

#pragma mark - 滑动列表
- (UICollectionView *)menuView {
    if (!_menuView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70) / 5, 95);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
        
        _menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210) collectionViewLayout:flowLayout];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.scrollEnabled = NO;
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.showsVerticalScrollIndicator = NO;
        _menuView.showsHorizontalScrollIndicator = NO;
        [_menuView registerClass:[MallMenuCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellId"];
    }
    return _menuView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellId = @"collectionViewCellId";
    MallMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [cell setCategoryData:self.rowMarr[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCategoryViewController * goodsCategoryVC = [[GoodsCategoryViewController alloc] init];
    goodsCategoryVC.categoryTitleArr = self.titleMarr;
    goodsCategoryVC.categoryId = self.categoryIdMarr[indexPath.row];
    goodsCategoryVC.categoryIdMarr = self.categoryIdMarr;
    [goodsCategoryVC.categoryMenuView updateMenuBtnState:indexPath.row + 1];
    goodsCategoryVC.idMarr = self.idMarr;
    [self.nav pushViewController:goodsCategoryVC animated:YES];
}


@end
