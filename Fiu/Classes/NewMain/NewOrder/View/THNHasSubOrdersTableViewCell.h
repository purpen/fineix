//
//  THNHasSubOrdersTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "OrderInfoModel.h"

@interface THNHasSubOrdersTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *number;      //  订单编号
@property (nonatomic, strong) UILabel *prompt;      //  拆单提示
@property (nonatomic, strong) UILabel *stateLab;    //  状态提示

- (void)thn_getOrderStateAndNumber:(OrderInfoModel *)model;

@end
