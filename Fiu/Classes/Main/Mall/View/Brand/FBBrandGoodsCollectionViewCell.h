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

@pro_strong UIImageView     *   brandImg;

- (void)setSelfBrandData:(BrandListModel *)model;

@end
