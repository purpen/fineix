//
//  THNRefundViewController.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNRefundViewController : THNViewController

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) FBRequest *refundRequest;

@end
