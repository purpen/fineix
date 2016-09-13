//
//  CategoryMenuView.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CategoryMenuView.h"
#import "CategoryMenuCollectionViewCell.h"
#import "DiscoverCategoryViewController.h"
#import "THNCategoryViewController.h"

@interface CategoryMenuView () {
    NSInteger _type;
}

@end

@implementation CategoryMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        
        [self addSubview:self.categoryMenu];
    }
    return self;
}

- (void)setCategoryData:(NSMutableArray *)category withType:(NSInteger)type {
    _type = type;
    
    [self.rowMarr removeAllObjects];
    [self.categoryIdMarr removeAllObjects];
    [self.categoryTitleMarr removeAllObjects];
    
    for (NSDictionary *categoryDic in category) {
        CategoryRow *model = [[CategoryRow alloc] initWithDictionary:categoryDic];
        [self.rowMarr addObject:model];
        [self.categoryIdMarr addObject:[NSString stringWithFormat:@"%zi", model.idField]];
        [self.categoryTitleMarr addObject:model.title];
    }
    [self.categoryMenu reloadData];
}

- (UICollectionView *)categoryMenu {
    if (!_categoryMenu) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.minimumLineSpacing = 10.0f;
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        
        _categoryMenu = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) collectionViewLayout:flowLayout];
        _categoryMenu.delegate = self;
        _categoryMenu.dataSource = self;
        _categoryMenu.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8" alpha:0];
        _categoryMenu.showsVerticalScrollIndicator = NO;
        _categoryMenu.showsHorizontalScrollIndicator = NO;
        [_categoryMenu registerClass:[CategoryMenuCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryMenuCollectionViewCellID"];
    }
    return _categoryMenu;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"CategoryMenuCollectionViewCellID";
    CategoryMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (self.rowMarr.count) {
        [cell setCategoryData:self.rowMarr[indexPath.row] withType:_type];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        DiscoverCategoryViewController *categoryVC = [[DiscoverCategoryViewController alloc] init];
        categoryVC.vcTitle = self.categoryTitleMarr[indexPath.row];
        categoryVC.categoryId = self.categoryIdMarr[indexPath.row];
        [self.nav pushViewController:categoryVC animated:YES];
        
    } else if (_type == 2) {
        THNCategoryViewController *mallCategoryVC = [[THNCategoryViewController alloc] init];
        mallCategoryVC.vcTitle = self.categoryTitleMarr[indexPath.row];
        mallCategoryVC.categoryId = self.categoryIdMarr[indexPath.row];
        [self.nav pushViewController:mallCategoryVC animated:YES];
    }
}

- (NSMutableArray *)rowMarr {
    if (!_rowMarr) {
        _rowMarr = [NSMutableArray array];
    }
    return _rowMarr;
}

- (NSMutableArray *)categoryIdMarr {
    if (!_categoryIdMarr) {
        _categoryIdMarr = [NSMutableArray array];
    }
    return _categoryIdMarr;
}

- (NSMutableArray *)categoryTitleMarr {
    if (!_categoryTitleMarr) {
        _categoryTitleMarr = [NSMutableArray array];
    }
    return _categoryTitleMarr;
}

@end
