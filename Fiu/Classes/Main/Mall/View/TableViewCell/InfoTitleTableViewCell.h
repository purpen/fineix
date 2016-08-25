//
//  InfoTitleTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "GoodsInfoData.h"
#import "FBGoodsInfoModelData.h"
#import "UILable+Frame.h"

@interface InfoTitleTableViewCell : UITableViewCell

@pro_strong UILabel         *       goodsTitle;     //  商品标题
@pro_strong UILabel         *       goodsPrice;     //  商品价格
@pro_strong UIButton        *       nextBtn;
@pro_assign CGFloat                 cellHeight;

- (void)setGoodsInfoData:(GoodsInfoData *)model;

- (void)setThnGoodsInfoData:(FBGoodsInfoModelData *)model;

- (void)getContentCellHeight:(NSString *)content;

@end
