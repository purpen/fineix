//
//  THNRecordHintView.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNRecordHintView : UIView

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *centerLable;
@property (nonatomic, strong) UILabel *rightLable;

- (void)setTradingRecord;

- (void)setSettlementRecord;

@end
