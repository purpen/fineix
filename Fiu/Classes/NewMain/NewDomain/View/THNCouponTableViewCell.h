//
//  THNCouponTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *coupon;

- (void)thn_setCouponCount;

@end
