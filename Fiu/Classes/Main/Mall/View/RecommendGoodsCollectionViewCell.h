//
//  RecommendGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface RecommendGoodsCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView             *   goodsImg;       //  商品图片
@pro_strong UILabel                 *   title;          //  商品标题
@pro_strong UILabel                 *   line;           //  分割线
@pro_strong UILabel                 *   price;          //  价格

- (void)setUI;

@end
