//
//  THNPaymentTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "OrderInfoModel.h"

@interface THNPaymentTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *freight;     //  运费
@property (nonatomic, strong) UILabel *payWay;      //  支付方式
@property (nonatomic, strong) UILabel *goodsPrice;  //  商品总价
@property (nonatomic, strong) UILabel *payPrice;    //  支付总额

- (void)thn_setOrderPaymentData:(OrderInfoModel *)model;

@end
