//
//  THNRecordStateTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/1/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNTradingInfoData.h"
#import "THNSettlementInfoRow.h"

@interface THNRecordStateTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;

/**
 交易记录
 */
- (void)thn_setTradingRecordInfoDataTop:(THNTradingInfoData *)model;
- (void)thn_setTradingRecordInfoDataBottom:(THNTradingInfoData *)model;

/**
 结算记录
 */
- (void)thn_setSettlementRecordInfoData:(THNSettlementInfoRow *)model;

@end
