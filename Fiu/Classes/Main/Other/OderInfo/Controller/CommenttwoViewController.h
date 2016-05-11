//
//  CommenttwoViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "OrderInfoDetailViewController.h"

@class OrderInfoCell;
@interface CommenttwoViewController : FBViewController

@property (nonatomic, strong) OrderInfoCell * orderInfoCell;

@property (nonatomic, weak) id<OrderInfoDetailVCDelegate> delegate1;
@end

