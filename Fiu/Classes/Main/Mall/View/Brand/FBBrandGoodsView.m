//
//  FBBrandGoodsView.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBrandGoodsView.h"
#import "FBBrandGoodsCollectionViewCell.h"
#import "GoodsBrandViewController.h"
#import "SeleBrandViewController.h"

@interface FBBrandGoodsView () {
    NSMutableArray  *   _brandData;
    NSMutableArray  *   _brandIdData;
}

@end

@implementation FBBrandGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.selfBrandList];
        
        [self addSubview:self.allselfBrand];
        
    }
    return self;
}

- (void)setBrandData:(NSMutableArray *)dataMarr withIdData:(NSMutableArray *)idMarr {
    _brandData = dataMarr;
    _brandIdData = idMarr;
    
    [self.selfBrandList reloadData];
}

#pragma mark - 自营商品列表
- (UICollectionView *)selfBrandList {
    if (!_selfBrandList) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 40)/2, ((SCREEN_WIDTH - 40)/2)*0.62);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        
        _selfBrandList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230) collectionViewLayout:flowLayout];
        _selfBrandList.backgroundColor = [UIColor whiteColor];
        _selfBrandList.delegate = self;
        _selfBrandList.dataSource = self;
        [_selfBrandList registerClass:[FBBrandGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"FBBrandGoodsCollectionViewCellID"];
        
    }
    return _selfBrandList;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _brandData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBBrandGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBBrandGoodsCollectionViewCellID" forIndexPath:indexPath];
    [cell setSelfBrandData:_brandData[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsBrandViewController * brandVC = [[GoodsBrandViewController alloc] init];
    brandVC.brandId = _brandIdData[indexPath.row];
    [self.nav pushViewController:brandVC animated:YES];
}

#pragma mark - 查看全部自营品牌按钮
- (UIButton *)allselfBrand {
    if (!_allselfBrand) {
        _allselfBrand = [[UIButton alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 44)];
        [_allselfBrand setTitle:NSLocalizedString(@"lookAllSelfBrand", nil) forState:(UIControlStateNormal)];
        _allselfBrand.titleLabel.font = [UIFont systemFontOfSize:12];
        [_allselfBrand setTitleColor:[UIColor colorWithHexString:@"#999999" alpha:1] forState:(UIControlStateNormal)];
        [_allselfBrand setImage:[UIImage imageNamed:@"button_right_next"] forState:(UIControlStateNormal)];
        [_allselfBrand setImageEdgeInsets:(UIEdgeInsetsMake(0, 170, 0, 0))];
        _allselfBrand.backgroundColor = [UIColor whiteColor];
        [_allselfBrand addTarget:self action:@selector(gotoLookAllBrand) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _allselfBrand;
}

- (void)gotoLookAllBrand {
    SeleBrandViewController * allSelfBrandVC = [[SeleBrandViewController alloc] init];
    [self.nav pushViewController:allSelfBrandVC animated:YES];
}


@end
