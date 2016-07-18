//
//  CategoryMenuView.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CategoryMenuView.h"
#import "CategoryMenuCollectionViewCell.h"
#import "GoodsCategoryViewController.h"

@implementation CategoryMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        
        [self addSubview:self.categoryMenu];
    }
    return self;
}

- (void)setCategoryData:(NSMutableArray *)category {
    self.rowMarr = category;
    self.titleMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"title"]];
    self.categoryIdMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"tagId"]];
    self.idMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"idField"]];
    [self.categoryMenu reloadData];
}

- (UICollectionView *)categoryMenu {
    if (!_categoryMenu) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50, 65);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.minimumLineSpacing = 10.0f;
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        
        _categoryMenu = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65) collectionViewLayout:flowLayout];
        _categoryMenu.delegate = self;
        _categoryMenu.dataSource = self;
        _categoryMenu.backgroundColor = [UIColor clearColor];
        _categoryMenu.showsVerticalScrollIndicator = NO;
        _categoryMenu.showsHorizontalScrollIndicator = NO;
        [_categoryMenu registerClass:[CategoryMenuCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryMenuCollectionViewCellID"];
    }
    return _categoryMenu;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"CategoryMenuCollectionViewCellID";
    CategoryMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell setCategoryData:self.rowMarr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCategoryViewController * goodsCategoryVC = [[GoodsCategoryViewController alloc] init];
    goodsCategoryVC.categoryTitleArr = self.titleMarr;
    goodsCategoryVC.categoryId = self.categoryIdMarr[indexPath.row];
    goodsCategoryVC.categoryIdMarr = self.categoryIdMarr;
    [goodsCategoryVC.categoryMenuView updateMenuBtnState:indexPath.row];
    [goodsCategoryVC showCategoryTag:indexPath.row];
    goodsCategoryVC.idMarr = self.idMarr;
    [self.nav pushViewController:goodsCategoryVC animated:YES];
}


@end
