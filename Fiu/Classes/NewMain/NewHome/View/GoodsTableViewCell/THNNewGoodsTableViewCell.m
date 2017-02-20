//
//  THNNewGoodsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNNewGoodsTableViewCell.h"
#import "MallListGoodsCollectionViewCell.h"
#import "HomeGoodsRow.h"
#import "FBGoodsInfoViewController.h"

static const CGFloat newGoodsCellHeight = ((SCREEN_WIDTH - 45)/2)*1.21;
static NSString *const goodsCollectionCellID = @"MallListGoodsCollectionViewCellId";

@implementation THNNewGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self addSubview:self.goodsCollectionView];
    }
    return self;
}

- (NSMutableArray *)goodsMarr {
    if (!_goodsMarr) {
        _goodsMarr = [NSMutableArray array];
    }
    return _goodsMarr;
}

- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
}

- (void)thn_setHomeGoodsModelArr:(NSMutableArray *)data {
    self.goodsMarr = data;
    for (HomeGoodsRow *model in data) {
        [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi", model.idField]];
    }
    [self.goodsCollectionView reloadData];
}

- (UICollectionView *)goodsCollectionView {
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, newGoodsCellHeight);
        flowLayout.minimumLineSpacing = 15.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (newGoodsCellHeight * 2) +15)
                                                   collectionViewLayout:flowLayout];
        _goodsCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.scrollEnabled = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        [_goodsCollectionView registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsCollectionCellID];
    }
    return _goodsCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCollectionCellID
                                                                                      forIndexPath:indexPath];
    if (self.goodsMarr.count) {
        [cell thn_setHomeGoodsData:self.goodsMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
    [self.nav pushViewController:goodsVC animated:YES];
}

@end
