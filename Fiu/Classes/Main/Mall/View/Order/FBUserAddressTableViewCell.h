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
@pro_strong UILabel               *shouHuoFangShiLabel;
@pro_strong UIButton               *kuaiDiBtn;
@pro_strong UILabel               *kuaiDiLabel;
@pro_strong UIButton               *kuaiDiCoverBtn;
@pro_strong UIButton               *ziTiBtn;
@pro_strong UILabel               *ziTiLabel;
@pro_strong UIButton               *ziTiCoverBtn;
@pro_strong UIView               *lineView;
@pro_strong UILabel               *tipLabel;

- (void)setAddressModel:(DeliveryAddressModel *)addressModel;
- (void)thn_setOrderAddressModel:(DeliveryAddressModel *)model;

@end
