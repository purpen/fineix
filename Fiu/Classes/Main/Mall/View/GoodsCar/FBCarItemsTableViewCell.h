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

@property (nonatomic, strong) UIButton *chooseBtn;         //  选择按钮
@property (nonatomic, strong) UIImageView *goodsImg;       //  商品图片
@property (nonatomic, strong) UILabel *goodsTitle;         //  商品标题
@property (nonatomic, strong) UILabel *goodsColor;         //  商品颜色
@property (nonatomic, strong) UILabel *goodsNum;           //  商品数量
@property (nonatomic, strong) UILabel *goodsPrice;         //  商品价格
@property (nonatomic, strong) UILabel *JDGoodsLab;         //  京东商品

- (void)setGoodsCarItemData:(CarGoodsModelItem *)model;

@end
