//
//  FiltersView.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiltersView.h"
#import "FBFiltersCollectionViewCell.h"
#import "FBFilters.h"

@implementation FiltersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.filtersTitle = @[
                             NSLocalizedString(@"FiltersName", nil),
                             NSLocalizedString(@"FiltersNameA", nil),
                             NSLocalizedString(@"FiltersNameB", nil),
                             NSLocalizedString(@"FiltersNameC", nil),
                             NSLocalizedString(@"FiltersNameD", nil),
                             NSLocalizedString(@"FiltersNameE", nil),
                             NSLocalizedString(@"FiltersNameF", nil),
                             NSLocalizedString(@"FiltersNameG", nil),
                             NSLocalizedString(@"FiltersNameH", nil),
                             NSLocalizedString(@"FiltersNameI", nil),
                             NSLocalizedString(@"FiltersNameJ", nil),
                             NSLocalizedString(@"FiltersNameK", nil)
                             ];
        
        self.filters = @[
                         @"original",
                         @"FS1977Filter",
                         @"FSAmaroFilter",
                         @"FSHudsonFilter",
                         @"FSInkwellFilter",
                         @"FSLomofiFilter",
                         @"FSLordKelvinFilter",
                         @"FSNashvilleFilter",
                         @"FSSierraFilter",
                         @"FSValenciaFilter",
                         @"FSWaldenFilter",
                         @"FSXproIIFilter"
                         ];
        
        [self addSubview:self.filtersCollectionView];
    }
    return self;
}

- (void)thn_getNeedEditSceneImage:(UIImage *)sceneImage {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSUInteger idx = 0; idx < self.filters.count; ++ idx) {
            FSImageFilterManager *filterManager = [[FSImageFilterManager alloc] init];
            UIImage *filterImage = [filterManager randerImageWithIndex:self.filters[idx] WithImage:sceneImage];
            [self.filterImageMarr addObject:filterImage];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.filtersCollectionView reloadData];
        });
    });
}

- (NSMutableArray *)filterImageMarr {
    if (!_filterImageMarr) {
        _filterImageMarr = [NSMutableArray array];
    }
    return _filterImageMarr;
}

#pragma mark - 滤镜菜单
- (UICollectionView *)filtersCollectionView {
    if (!_filtersCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(85, 120);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _filtersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) collectionViewLayout:flowLayout];
        _filtersCollectionView.showsHorizontalScrollIndicator = NO;
        _filtersCollectionView.showsVerticalScrollIndicator = NO;
        _filtersCollectionView.delegate = self;
        _filtersCollectionView.dataSource = self;
        _filtersCollectionView.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:0.8];
        [_filtersCollectionView registerClass:[FBFiltersCollectionViewCell class] forCellWithReuseIdentifier:@"FBFiltersCollectionViewCell"];
    }
    return _filtersCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * filtersCellID = @"FBFiltersCollectionViewCell";
    FBFiltersCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:filtersCellID forIndexPath:indexPath];
    cell.filtersTitle.text = self.filtersTitle[indexPath.row];
    if (self.filterImageMarr.count == self.filters.count) {
        cell.filtersImageView.image = self.filterImageMarr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0.0f;
    [UIView animateWithDuration:.2 animations:^{
        cell.alpha = 1.0f;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_chooseFilterWithName:)]) {
        [self.delegate thn_chooseFilterWithName:self.filters[indexPath.row]];
    }
}

@end
