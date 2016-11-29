//
//  THNOrderOperationView.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

typedef NS_ENUM(NSInteger, THNOrderState) {
    OrderCancel              = 0,  //  已取消
    OrderWaitPay             = 1,  //  待付款
    OrderWaitDeliver         = 10, //  待发货
    OrderWaitTakeDelivery    = 15, //  待收货
    OrderWaitComment         = 16, //  待评价
    OrderWaitDone            = 20, //  已完成
};

@protocol THNOrderOperationViewDelegate <NSObject>

@optional
- (void)thn_mainButtonSelected:(THNOrderState)state;
- (void)thn_subButtonSelected:(THNOrderState)state;

@end

@interface THNOrderOperationView : UIView

@property (nonatomic, strong) UIButton *mainBtn;    //  订单操作按钮
@property (nonatomic, strong) UIButton *subBtn;     //  退款／退货按钮
@property (nonatomic, weak) id <THNOrderOperationViewDelegate> delegate;

- (void)set_orderStateForOperationButton:(THNOrderState)state;

@end
