//
//  THNWithdrawRecordTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNWithdrawRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *stateLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *moneyLable;

- (void)thn_setWithdrawRecordData:(NSInteger)data;

- (void)thn_showTotalMoney;

@end
