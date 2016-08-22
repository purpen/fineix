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

@interface MallListGoodsCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *image;
@pro_strong UIView *blackView;
@pro_strong UILabel *title;
@pro_strong UILabel *price;

- (void)setGoodsListData:(GoodsRow *)model;

@end
