//
//  THNOrderNumberTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "OrderInfoModel.h"
#import "SubOrderModel.h"

@interface THNOrderNumberTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *number;      //  订单号
@property (nonatomic, strong) UILabel *state;       //  状态

- (void)thn_setOrederNumberData:(OrderInfoModel *)model;

//  子订单
- (void)thn_setSubOrderNumberData:(SubOrderModel *)model;

@end
