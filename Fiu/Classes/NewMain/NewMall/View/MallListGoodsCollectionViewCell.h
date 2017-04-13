//
//  MallListGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "GoodsRow.h"
#import "THNMallSubjectModelProduct.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "THNMallGoodsModelItem.h"

@interface MallListGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *price;

- (void)thn_setHomeGoodsData:(THNMallGoodsModelItem *)model;

- (void)setGoodsListData:(GoodsRow *)model;

- (void)setMallSubjectGoodsListData:(THNMallSubjectModelProduct *)model;

@end
