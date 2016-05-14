//
//  GoodsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "GoodsRow.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface GoodsTableViewCell : UITableViewCell <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UICollectionView    *       goodsImgView;   //  图片滚动视图
@pro_strong NSMutableArray      *       goodsImgMarr;   //  图片
@pro_strong UILabel             *       price;          //  价格
@pro_strong UIImageView         *       priceBg;        //  价格背景
@pro_strong UILabel             *       title;          //  标题
@pro_strong UIImageView         *       titleBg;        //  标题背景
@pro_strong UIImageView         *       typeImg;        //  品牌
@pro_strong NSMutableArray      *       goodsId;        //  商品id

- (void)setGoodsData:(GoodsRow *)model;

@end