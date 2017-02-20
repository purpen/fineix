//
//  THNNewGoodsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNNewGoodsTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;

- (void)thn_setHomeGoodsModelArr:(NSMutableArray *)data;

@end
