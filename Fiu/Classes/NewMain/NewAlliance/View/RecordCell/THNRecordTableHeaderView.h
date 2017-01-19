//
//  THNRecordTableHeaderView.h
//  Fiu
//
//  Created by FLYang on 2017/1/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNRecordTableHeaderView : UIView

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;

- (void)thn_setSettlementMoney:(NSString *)money;

@end
