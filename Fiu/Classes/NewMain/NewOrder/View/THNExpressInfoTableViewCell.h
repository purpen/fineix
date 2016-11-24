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

@interface THNExpressInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *expressCompany;  //  快递公司
@property (nonatomic, strong) UILabel *expressNum;      //  快递编号

- (void)thn_setOrederExpressData:(OrderInfoModel *)model;

@end
