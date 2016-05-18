//
//  FBCarGoodsListTabelViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CarGoodsModelItem.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBCarGoodsListTabelViewCell : UITableViewCell

@pro_strong UIButton              *       chooseBtn;          //  选择按钮
@pro_strong UIImageView           *       goodsImg;           //  商品图片
@pro_strong UILabel               *       goodsTitle;         //  商品标题
@pro_strong UILabel               *       goodsColor;         //  商品颜色
@pro_strong UILabel               *       goodsNum;           //  商品数量
@pro_strong UILabel               *       goodsPrice;         //  商品价格
@pro_strong UILabel               *       lineBgLab;          //  分割线
@pro_assign NSInteger                     stock;
@pro_assign NSInteger                     newStock;
@pro_assign NSInteger                     carGoodsCount;      //  购物车商品库存
@pro_strong UIButton              *       addBtn;             //  增加数量
@pro_strong UILabel               *       goodsSumNum;        //  商品的总数
@pro_strong UIButton              *       subBtn;             //  减少数量
@pro_strong UIButton              *       openReselectView;   //  打开属性面板按钮
@pro_strong UIButton              *       selectedBtn;        //  保@pro_strong存按钮的活动状态

- (void)setGoodsCarModel:(CarGoodsModelItem *)goodsCarModel;

/*
 *  获取购物车商品的库存数量
 */
- (void)getCarGoodsCount:(NSInteger )stock;

@end
