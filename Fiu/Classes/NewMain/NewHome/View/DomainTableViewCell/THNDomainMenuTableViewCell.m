//
//  THNDomainMenuTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainMenuTableViewCell.h"
#import "THNDomainMenuCollectionViewCell.h"
#import "DomainCategoryRow.h"

static NSString *const domainMenuCollectionCellID = @"THNDomainMenuCollectionViewCellId";

@implementation THNDomainMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.menuCollectionView];
        [_menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        }];
    }
    return self;
}

- (void)setDomainMenuModelArr:(NSMutableArray *)data {
    [self.menuIdMarr removeAllObjects];
    [self.menuMarr removeAllObjects];
    
    self.menuMarr = data;
    for (DomainCategoryRow *model in data) {
        [self.menuIdMarr addObject:[NSString stringWithFormat:@"%zi", model.idField]];
    }
    [self.menuCollectionView reloadData];
}

- (UICollectionView *)menuCollectionView {
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.01f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60)
                                                   collectionViewLayout:flowLayout];
        _menuCollectionView.backgroundColor = [UIColor whiteColor];
        _menuCollectionView.delegate = self;
        _menuCollectionView.dataSource = self;
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        [_menuCollectionView registerClass:[THNDomainMenuCollectionViewCell class] forCellWithReuseIdentifier:domainMenuCollectionCellID];
    }
    return _menuCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuMarr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 30) / 5, 60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:domainMenuCollectionCellID
                                                                                  forIndexPath:indexPath];
    if (self.menuMarr.count) {
        [cell setDomainMenuDataModel:self.menuMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"打开地盘分类：%@", self.menuIdMarr[indexPath.row]]];
}

- (NSMutableArray *)menuMarr {
    if (!_menuMarr) {
        _menuMarr = [NSMutableArray array];
    }
    return _menuMarr;
}

- (NSMutableArray *)menuIdMarr {
    if (!_menuIdMarr) {
        _menuIdMarr = [NSMutableArray array];
    }
    return _menuIdMarr;
}

@end
