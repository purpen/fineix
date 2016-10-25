//
//  NewGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNMallGoodsModelItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewGoodsCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView *goodsImageView;
@pro_strong UIView *blackView;
@pro_strong UIImageView *brandImage;
@pro_strong UILabel *name;
@pro_strong UILabel *price;

- (void)setGoodsData:(THNMallGoodsModelItem *)model;

@end
