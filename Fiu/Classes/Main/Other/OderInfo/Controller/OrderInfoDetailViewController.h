//
//  OrderInfoDetailViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
@class OrderInfoCell;
@class OrderInfoModel;
@protocol OrderInfoDetailVCDelegate <NSObject>

@optional
- (void)operationActionWithCell:(OrderInfoCell *)cell;

@end

@interface OrderInfoDetailViewController : FBViewController

@property (nonatomic, strong) OrderInfoCell * orderInfoCell;
@property (nonatomic, strong) OrderInfoModel * orderInfo;
@property (nonatomic, assign) BOOL isFromPayment;

@property (nonatomic, weak) id<OrderInfoDetailVCDelegate> delegate1;

@end
