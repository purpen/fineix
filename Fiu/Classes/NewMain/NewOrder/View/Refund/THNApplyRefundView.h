//
//  THNApplyRefundView.h
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@protocol THNApplyRefundViewDelegate <NSObject>

@optional
- (void)thn_beginChooseRefundReason;
- (void)thn_doneChooseRefundReasonId:(NSInteger)reasonId;
- (void)thn_finishWritingRefundReason:(NSString *)reason;

@end

@interface THNApplyRefundView : UIView <
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, weak) id <THNApplyRefundViewDelegate> delegate;
@property (nonatomic, strong) UITableView *reasonTable;

/**
 退款类型
 *  1:退款 ／ 2:退货
 */
- (NSArray *)thn_setShowType:(NSInteger)type;

- (void)thn_setRefundInfoData:(NSDictionary *)data;

- (void)thn_showRefundReasonTable:(BOOL)show;

@end
