//
//  DeliveryAddressViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class DeliveryAddressModel;
typedef void(^SelectedAddressBlock)(DeliveryAddressModel *deliveryAddress);

@interface DeliveryAddressViewController : FBViewController

@property (nonatomic, assign) BOOL isSelectType;
@property (nonatomic, strong) DeliveryAddressModel * selectedAddress;
@property (nonatomic, copy) SelectedAddressBlock selectedAddressBlock;

@end
