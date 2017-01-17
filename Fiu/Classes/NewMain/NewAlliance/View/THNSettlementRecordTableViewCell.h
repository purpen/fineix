//
//  THNSettlementRecordTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNSettlementRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *numLable;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UIImageView *icon;

- (void)thn_setSettlementRecordData:(NSInteger)data;
@end
