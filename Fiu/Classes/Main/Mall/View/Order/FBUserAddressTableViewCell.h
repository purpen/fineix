//
//  FBUserAddressTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "DeliveryAddressModel.h"

@interface FBUserAddressTableViewCell : UITableViewCell

@pro_strong UIImageView           *addressIcon;
@pro_strong UILabel               *userName;
@pro_strong UILabel               *cityName;
@pro_strong UILabel               *addressLab;
@pro_strong UILabel               *phoneNum;
@pro_strong UIImageView           *openIcon;
@pro_strong UIImageView           *addIcon;
@pro_strong UILabel               *addLab;

- (void)setAddressModel:(DeliveryAddressModel *)addressModel;
- (void)thn_setOrderAddressModel:(DeliveryAddressModel *)model;

@end
