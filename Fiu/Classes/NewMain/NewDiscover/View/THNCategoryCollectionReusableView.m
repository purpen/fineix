//
//  THNCategoryCollectionReusableView.m
//  Fiu
//
//  Created by FLYang on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCategoryCollectionReusableView.h"
#import "MallMenuCollectionViewCell.h"
#import "DiscoverCategoryViewController.h"
#import "THNCategoryViewController.h"
//#import "GoodsCategoryViewController.h"

static NSString *const collectionViewCellId = @"CollectionViewCellId";

@interface THNCategoryCollectionReusableView () {
    NSInteger _type;
}

@end

@implementation THNCategoryCollectionReusableView

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
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 180));
        make.left.top.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.left.bottom.equalTo(self).with.offset(0);
    }];
}
    
- (GroupHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[GroupHeaderView alloc] init];
    }
    return _headerView;
}

#pragma mark -
- (void)setCategoryData:(NSMutableArray *)category type:(NSInteger)type {
    _type = type;
    
    if (_type == 0) {
        [self.headerView addGroupHeaderViewIcon:@"discover_newScene"
                                  withTitle:NSLocalizedString(@"disCoverNewScene", nil)
                               withSubtitle:@""
                              withRightMore:@""
                               withMoreType:0];
    } else if (_type == 1) {
        [self.headerView addGroupHeaderViewIcon:@"mall_newGoods"
                                  withTitle:NSLocalizedString(@"newGoods", nil)
                               withSubtitle:@""
                              withRightMore:@""
                               withMoreType:0];
    }
    
    [self.categoryMarr removeAllObjects];
    [self.categoryIdMarr removeAllObjects];
    
    for (NSDictionary *categoryDict in category) {
        CategoryRow *model = [[CategoryRow alloc] initWithDictionary:categoryDict];
        [self.categoryMarr addObject:model];
        [self.categoryIdMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        [self.categoryTitleMarr addObject:model.title];
    }
    [self.menuView reloadData];
}

#pragma mark - 滑动列表
- (UICollectionView *)menuView {
    if (!_menuView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70)/5, (SCREEN_WIDTH - 70)/5);
        flowLayout.minimumLineSpacing = 20.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
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
    return self.categoryMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    if (self.categoryMarr.count) {
        [cell setCategoryData:self.categoryMarr[indexPath.row] type:_type];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        DiscoverCategoryViewController *categoryVC = [[DiscoverCategoryViewController alloc] init];
        categoryVC.vcTitle = self.categoryTitleMarr[indexPath.row];
        categoryVC.categoryId = self.categoryIdMarr[indexPath.row];
        [self.nav pushViewController:categoryVC animated:YES];
    
    } else if (_type == 1) {
        THNCategoryViewController *mallCategoryVC = [[THNCategoryViewController alloc] init];
        mallCategoryVC.vcTitle = self.categoryTitleMarr[indexPath.row];
        mallCategoryVC.categoryId = self.categoryIdMarr[indexPath.row];
        [self.nav pushViewController:mallCategoryVC animated:YES];
    }
}

#pragma mark - NSMutableArray
- (NSMutableArray *)categoryMarr {
    if (!_categoryMarr) {
        _categoryMarr = [NSMutableArray array];
    }
    return _categoryMarr;
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
