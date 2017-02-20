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
#import "HomeGoodsRow.h"

@interface MallListGoodsCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *goodsImageView;
@pro_strong UIView *blackView;
@pro_strong UILabel *title;
@pro_strong UILabel *price;

- (void)thn_setHomeGoodsData:(HomeGoodsRow *)model;

- (void)setGoodsListData:(GoodsRow *)model;

- (void)setMallSubjectGoodsListData:(THNMallSubjectModelProduct *)model;

@end
