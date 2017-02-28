//
//  THNMallNewGoodsCollectionViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallNewGoodsCollectionViewCell.h"
#import "NewGoodsCollectionViewCell.h"
#import "FBGoodsInfoViewController.h"

static NSString *const GoodsCellId = @"goodsCellId";

@implementation THNMallNewGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self addSubview:self.titleLabel];
        [self addSubview:self.goodList];
    }
    return self;
}

- (void)setNewGoodsData:(NSMutableArray *)data {
    self.titleLabel.text = @"新鲜好货早知道";
    [self.goodsIdMarr removeAllObjects];
    
    self.goodsMarr = data;
    for (THNMallGoodsModelItem *model in self.goodsMarr) {
        [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
    }
    [self.goodList reloadData];
}

- (void)setHotGoodsData:(NSMutableArray *)data {
    self.titleLabel.text = @"好货人气王";
    [self.goodsIdMarr removeAllObjects];
    
    self.goodsMarr = data;
    for (THNMallGoodsModelItem *model in self.goodsMarr) {
        [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
    }
    [self.goodList reloadData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

- (UICollectionView *)goodList {
    if (!_goodList) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(150, 185);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _goodList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 185) collectionViewLayout:flowLayout];
        _goodList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodList.delegate = self;
        _goodList.dataSource = self;
        _goodList.showsHorizontalScrollIndicator = NO;
        [_goodList registerClass:[NewGoodsCollectionViewCell class] forCellWithReuseIdentifier:GoodsCellId];
    }
    return _goodList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCellId
                                                                                 forIndexPath:indexPath];
    if (self.goodsMarr.count) {
        [cell setGoodsData:self.goodsMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
    [self.nav pushViewController:goodsVC animated:YES];
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


@end
