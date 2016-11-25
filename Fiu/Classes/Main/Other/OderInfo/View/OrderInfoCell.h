//
//  OrderInfoCell.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/23.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundGoodsModel.h"

@class OrderInfoCell;
@protocol OrderInfoCellDelegate <NSObject>

@optional
- (void)operation1stBtnAction:(UIButton *)button withOrderInfoCell:(OrderInfoCell *)orderInfoCell;
- (void)operation2ndBtnAction:(UIButton *)button withOrderInfoCell:(OrderInfoCell *)orderInfoCell;
- (void)tapProductViewWithOrderInfoCell:(OrderInfoCell *)orderInfoCell orderId:(NSString *)orderId type:(NSInteger)type;

@end

@class OrderInfoModel;
@interface OrderInfoCell : UITableViewCell

@property (nonatomic, strong) OrderInfoModel * orderInfo;
@property (nonatomic, weak) id<OrderInfoCellDelegate> delegate;

- (void)thn_setRefundGoodsListData:(RefundGoodsModel *)model;

@end
