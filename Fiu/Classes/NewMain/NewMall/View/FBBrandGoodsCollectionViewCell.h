//
//  FBBrandGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "BrandListModel.h"

@interface FBBrandGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *brandImg;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)thn_setBrandData:(BrandListModel *)model;

@end
