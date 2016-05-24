//
//  RefundmentViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "OrderInfoDetailViewController.h"
@class OrderInfoCell;
@class OrderInfoModel;
@interface RefundmentViewController : FBViewController

@property (nonatomic, strong) OrderInfoCell * orderInfoCell;
@property (nonatomic, strong) OrderInfoModel * orderInfo;

@property (nonatomic, assign) BOOL isFromOrderDetail;

@property (nonatomic, weak) id<OrderInfoDetailVCDelegate> delegate1;
@end
