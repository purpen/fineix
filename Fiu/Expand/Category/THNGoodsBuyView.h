//
//  THNGoodsBuyView.h
//  Fiu
//
//  Created by FLYang on 16/9/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@protocol THNGoodsBuyViewBtnDelegate <NSObject>

@optional
/**
 *  index
 *  0:收藏／1:分享／2:加入购物车／3:立即购买
 */
- (void)selectedGoodsBuyViewBtnIndex:(NSInteger)index selectedState:(BOOL)selected;

@end

@interface THNGoodsBuyView : UIView

@pro_strong UIButton *collect;
@pro_strong UIButton *share;
@pro_strong UIButton *addCar;
@pro_strong UIButton *nowBuy;
@pro_strong UILabel *topLine;

@pro_weak id <THNGoodsBuyViewBtnDelegate> delegate;

/**
 *  collect
 *  0:未收藏／1:已收藏
 */
- (void)isCollectTheGoods:(NSInteger)collect;

- (void)changeCollectBtnState:(BOOL)selected;

@end
