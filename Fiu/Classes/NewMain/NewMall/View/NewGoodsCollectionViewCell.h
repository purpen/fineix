//
//  NewGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "GoodsRow.h"

@interface NewGoodsCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *image;
@pro_strong UIView *blackView;
@pro_strong UIImageView *brandImage;
@pro_strong UILabel *name;
@pro_strong UILabel *price;

- (void)setGoodsData:(GoodsRow *)model;

@end
