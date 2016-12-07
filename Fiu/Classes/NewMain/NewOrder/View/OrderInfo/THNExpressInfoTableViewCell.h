//
//  THNExpressInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "OrderInfoModel.h"
#import "SubOrderModel.h"

@interface THNExpressInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UILabel *expressCompany;  //  快递公司
@property (nonatomic, strong) UILabel *expressNum;      //  快递编号
@property (nonatomic, strong) UILabel *noExpressInfo;   //  没有物流

- (void)thn_setOrederExpressData:(OrderInfoModel *)model;

//  子订单
- (void)thn_setSubOrederExpressData:(SubOrderModel *)model withRid:(NSString *)rid;

@end
