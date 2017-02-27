//
//  THNMallNewGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNMallNewGoodsCollectionViewCell : UICollectionViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UICollectionView *goodList;
@property (nonatomic, strong) NSMutableArray *goodsMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setNewGoodsData:(NSMutableArray *)data;

@end
