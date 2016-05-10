//
//  PaySuccessViewController.h
//  parrot
//
//  Created by THN-Huangfei on 16/1/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class OrderInfoModel;
@interface PaySuccessViewController : FBViewController

@property (nonatomic, strong) OrderInfoModel * orderInfo;
@property (nonatomic, copy) NSString * paymentWay;

@end
