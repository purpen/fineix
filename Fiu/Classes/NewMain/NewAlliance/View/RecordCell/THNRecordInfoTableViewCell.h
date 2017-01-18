//
//  THNRecordInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/1/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNTradingInfoData.h"
#import "THNSettlementInfoRow.h"

@interface THNRecordInfoTableViewCell : UITableViewCell

/**
 交易记录
 */
- (void)thn_setTradingRecordInfoData:(THNTradingInfoData *)model;

/**
 结算记录
 */
- (void)thn_setSettlementRecordInfoData:(THNSettlementInfoRow *)model;

@end
