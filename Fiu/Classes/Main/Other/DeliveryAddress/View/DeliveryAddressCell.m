//
//  DeliveryAddressCell.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/21.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "DeliveryAddressCell.h"

#import "DeliveryAddressModel.h"

@interface DeliveryAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

- (IBAction)editBtnAction:(id)sender;

@end

@implementation DeliveryAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDeliveryAddress:(DeliveryAddressModel *)deliveryAddress
{
    if (_deliveryAddress != deliveryAddress) {
        _deliveryAddress = deliveryAddress;
    }
    self.nameLbl.text = deliveryAddress.name;
    self.areaLbl.text = [NSString stringWithFormat:@"%@ %@", deliveryAddress.provinceName, deliveryAddress.cityName];
    self.addressLbl.text = deliveryAddress.address;
    self.phoneLbl.text = deliveryAddress.phone;
    //self.provinceId = deliveryAddress.
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnAction:(id)sender {
    self.selectedCellBlock(self);
}

@end