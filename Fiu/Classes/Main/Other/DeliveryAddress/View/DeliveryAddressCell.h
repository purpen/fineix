//
//  DeliveryAddressCell.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/21.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeliveryAddressCell;
typedef void(^SelectedCellBlock)(DeliveryAddressCell *cell);

@class DeliveryAddressModel;
@interface DeliveryAddressCell : UITableViewCell

@property (nonatomic, strong) DeliveryAddressModel * deliveryAddress;

@property (nonatomic, copy) SelectedCellBlock selectedCellBlock;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImgView;
@property (weak, nonatomic) IBOutlet UILabel *defaultLbl;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;

@end
