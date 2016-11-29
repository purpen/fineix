//
//  THNRefundNumberTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "RefundGoodsModel.h"

@interface THNRefundNumberTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *stageLab;

- (void)thn_setRefundNumberData:(RefundGoodsModel *)model;

@end
