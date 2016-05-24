//
//  MarkGoodsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "MarkGoodsRow.h"

@interface MarkGoodsCollectionViewCell : UICollectionViewCell

@pro_strong UIImageView           *       goodsImage;
@pro_strong UILabel               *       goodsTitle;
@pro_strong UILabel               *       lineLab;
@pro_strong UILabel               *       goodsNewPrice;
@pro_strong UILabel               *       goodsMarketPrice;
@pro_strong UIButton              *       likeBtn;
@pro_strong UILabel               *       likeNumLab;
@pro_strong UIImageView           *       likeIcon;

- (void)setMarkGoodsData:(MarkGoodsRow *)model;

@end
