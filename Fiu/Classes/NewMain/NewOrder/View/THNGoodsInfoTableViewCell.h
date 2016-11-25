//
//  THNGoodsInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "ProductInfoModel.h"
#import "SubOrderModel.h"

@interface THNGoodsInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *goodsImg;      //  商品图片
@property (nonatomic, strong) UILabel       *goodsTitle;    //  商品标题
@property (nonatomic, strong) UILabel       *goodsColor;    //  商品颜色
@property (nonatomic, strong) UILabel       *goodsNum;      //  商品数量
@property (nonatomic, strong) UILabel       *goodsPrice;    //  商品价格
@property (nonatomic, strong) UILabel       *JDGoodsLab;    //  京东商品
@property (nonatomic, strong) UIButton      *refundBtn;     //  退款按钮
@property (nonatomic, strong) UILabel       *refundState;   //  退款状态

- (void)thn_setGoodsInfoData:(ProductInfoModel *)model;

//  子订单
//- (void)thn_setSubOrderGoodsInfoData:(SubOrderModel *)model;

@end
