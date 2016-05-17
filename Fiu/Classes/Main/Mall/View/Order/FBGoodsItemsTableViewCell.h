//
//  FbGoodsItemsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "OrderItems.h"

@interface FBGoodsItemsTableViewCell : UITableViewCell

@pro_strong UIImageView           *       goodsImg;       //  商品图片
@pro_strong UILabel               *       goodsTitle;     //  商品标题
@pro_strong UILabel               *       goodsColor;     //  商品颜色
@pro_strong UILabel               *       goodsNum;       //  商品数量
@pro_strong UILabel               *       goodsPrice;     //  商品价格
@pro_strong UILabel               *       lineBgLab;      //  分割线

- (void)setOrderModelData:(OrderItems *)orderModel;

@end
