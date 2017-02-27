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

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIImageView *brandImage;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;

- (void)setGoodsData:(THNMallGoodsModelItem *)model;

@end
