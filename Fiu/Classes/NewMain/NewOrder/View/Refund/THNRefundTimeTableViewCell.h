//
//  THNRefundTimeTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "RefundGoodsModel.h"

@interface THNRefundTimeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *priceLab;

- (void)thn_setRefundPriceData:(RefundGoodsModel *)model;

@end
