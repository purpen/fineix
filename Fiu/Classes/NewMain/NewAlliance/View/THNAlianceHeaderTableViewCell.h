//
//  THNAlianceHeaderTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNAllinaceData.h"

@interface THNAlianceHeaderTableViewCell : UITableViewCell

/**
 可提现金额
 */
@property (nonatomic, strong) UILabel *withdrawMoney;
@property (nonatomic, strong) UILabel *withdrawMoneyHint;

/**
 总收益金额
 */
@property (nonatomic, strong) UILabel *totalMoney;
@property (nonatomic, strong) UILabel *totalMoneyHint;

/**
 已提现金额
 */
@property (nonatomic, strong) UILabel *oldMoney;
@property (nonatomic, strong) UILabel *oldMoneyHint;

@property (nonatomic, strong) UIImageView *icon;

- (void)thn_showAllianceData:(THNAllinaceData *)model;

@end
