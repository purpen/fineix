//
//  FBCategoryView.m
//  Fiu
//
//  Created by FLYang on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBCategoryView.h"
#import "MallMenuCollectionViewCell.h"
#import "GoodsCategoryViewController.h"

static NSString *const collectionViewCellId = @"CollectionViewCellId";

@implementation FBCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    [self addSubview:self.menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).with.offset(10);
        make.right.bottom.equalTo(self).with.offset(-10);
    }];
}

#pragma mark -
- (void)setCategoryData:(NSMutableArray *)category {
    self.rowMarr = category;
    self.titleMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"title"]];
    self.categoryIdMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"tagId"]];
    self.idMarr = [NSMutableArray arrayWithArray:[category valueForKey:@"idField"]];
    [self.menuView reloadData];
}

#pragma mark - 滑动列表
- (UICollectionView *)menuView {
    if (!_menuView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70)/5, (SCREEN_WIDTH - 70)/5);
        flowLayout.minimumLineSpacing = 20.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
        [flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
        
        _menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140) collectionViewLayout:flowLayout];
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.scrollEnabled = NO;
        _menuView.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _menuView.showsVerticalScrollIndicator = NO;
        _menuView.showsHorizontalScrollIndicator = NO;
        [_menuView registerClass:[MallMenuCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellId];
    }
    return _menuView;
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.rowMarr.count;
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
//    [cell setCategoryData:self.rowMarr[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showSuccessWithStatus:@"打开分类"];
//    GoodsCategoryViewController * goodsCategoryVC = [[GoodsCategoryViewController alloc] init];
//    goodsCategoryVC.categoryTitleArr = self.titleMarr;
//    goodsCategoryVC.categoryId = self.categoryIdMarr[indexPath.row];
//    goodsCategoryVC.categoryIdMarr = self.categoryIdMarr;
//    [goodsCategoryVC.categoryMenuView updateMenuBtnState:indexPath.row];
//    [goodsCategoryVC showCategoryTag:indexPath.row];
//    goodsCategoryVC.idMarr = self.idMarr;
//    [self.nav pushViewController:goodsCategoryVC animated:YES];
}

@end
