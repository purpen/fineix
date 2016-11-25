//
//  THNApplyRefundView.h
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNApplyRefundView : UIView

/**
 退款类型
 *  1:退款 ／ 2:退货
 */
- (NSArray *)thn_setShowType:(NSInteger)type;

- (void)thn_setRefundInfoData:(NSDictionary *)data;

@end
