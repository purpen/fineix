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

@pro_strong UINavigationController *nav;
@pro_strong UICollectionView *goodList;
@pro_strong NSMutableArray *goodsMarr;
@pro_strong NSMutableArray *goodsIdMarr;

- (void)setNewGoodsData:(NSMutableArray *)data;

@end
