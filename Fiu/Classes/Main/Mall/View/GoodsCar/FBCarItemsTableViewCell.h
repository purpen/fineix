//
//  FBCarItemsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CarGoodsModelItem.h"

@interface FBCarItemsTableViewCell : UITableViewCell

@pro_strong UIButton              *       chooseBtn;          //  选择按钮
@pro_strong UIImageView           *       goodsImg;           //  商品图片
@pro_strong UILabel               *       goodsTitle;         //  商品标题
@pro_strong UILabel               *       goodsColor;         //  商品颜色
@pro_strong UILabel               *       goodsNum;           //  商品数量
@pro_strong UILabel               *       goodsPrice;         //  商品价格

- (void)setGoodsCarItemData:(CarGoodsModelItem *)model;

@end
