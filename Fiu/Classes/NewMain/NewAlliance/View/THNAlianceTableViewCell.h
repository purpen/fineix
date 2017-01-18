//
//  THNAlianceTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNAllinaceData.h"

@interface THNAlianceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *oldMoneyLable;
@property (nonatomic, strong) UIImageView *moneyIcon;

- (void)thn_setShowAlianceWithdrawData:(THNAllinaceData *)model;

- (void)thn_setShowRecordCellData:(NSInteger)index;

@end
