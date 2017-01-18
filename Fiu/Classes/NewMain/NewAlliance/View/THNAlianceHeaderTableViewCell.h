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

@property (nonatomic, strong) UILabel *hintLable;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UILabel *oldHintLable;
@property (nonatomic, strong) UILabel *oldMoneyLable;

- (void)thn_showAllianceData:(THNAllinaceData *)model;

@end
