//
//  FindGoodsView.h
//  Fiu
//
//  Created by FLYang on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "TaoBaoGoodsResult.h"
#import "JDGoodsListproductbaseResult.h"

@interface FindGoodsView : UIView

@pro_strong UIView          *   findView;       
@pro_strong UIButton        *   sureBtn;        //  确认找到
@pro_strong UIImageView     *   goodsImg;       //  商品图片
@pro_strong UITextField     *   goodsTitle;     //  商品标题
@pro_strong UITextField     *   goodsPrice;     //  商品价格

- (void)setFindGoodsViewData:(TaoBaoGoodsResult *)model;

- (void)setJDGoodsViewData:(JDGoodsListproductbaseResult *)model;

@end
