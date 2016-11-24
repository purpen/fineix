//
//  FBUserAddressTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBUserAddressTableViewCell.h"

@implementation FBUserAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)setAddressModel:(DeliveryAddressModel *)addressModel {
    self.userName.text = [NSString stringWithFormat:@"收货人：%@", addressModel.name];
    self.cityName.text = [NSString stringWithFormat:@"%@ %@ %@ %@", addressModel.provinceName ,addressModel.cityName ,addressModel.countyName ,addressModel.townName];
    self.addressLab.text = addressModel.address;
    self.phoneNum.text = addressModel.phone;    
}

- (void)thn_setOrderAddressModel:(DeliveryAddressModel *)model {
    if (model) {
        self.userName.text = [NSString stringWithFormat:@"收货人：%@", model.name];
        self.cityName.text = [NSString stringWithFormat:@"%@ %@ %@ %@", model.provinceName ,model.cityName ,model.countyName ,model.townName];
        self.addressLab.text = model.address;
        self.phoneNum.text = model.phone;
    }
    self.addLab.hidden = YES;
    self.addIcon.hidden = YES;
    self.openIcon.hidden = YES;
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.addressIcon];
    [_addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10.5, 17));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.openIcon];
    [_openIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10.5, 17));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 14));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(_addressIcon.mas_right).with.offset(10);
        
    }];
    
    [self addSubview:self.cityName];
    [_cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 12));
        make.top.equalTo(_userName.mas_bottom).with.offset(8);
        make.left.equalTo(_addressIcon.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 25));
        make.top.equalTo(_cityName.mas_bottom).with.offset(5);
        make.left.equalTo(_addressIcon.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.phoneNum];
    [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 12));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(_addressIcon.mas_right).with.offset(10);
    }];
    
    //  没有默认地址时的样式
    [self addSubview:self.addLab];
    [_addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 20));
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.addIcon];
    [_addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self);
        make.right.equalTo(_addLab.mas_left).with.offset(-10);
    }];
}

- (UIImageView *)addIcon {
    if (!_addIcon) {
        _addIcon = [[UIImageView alloc] init];
        _addIcon.image = [UIImage imageNamed:@"ic_add_circle_outline"];
    }
    return _addIcon;
}

- (UILabel *)addLab {
    if (!_addLab) {
        _addLab = [[UILabel alloc] init];
        _addLab.text = @"请添加收货地址";
        _addLab.textColor = [UIColor colorWithHexString:titleColor];
        _addLab.font = [UIFont systemFontOfSize:14];
        _addLab.textAlignment = NSTextAlignmentCenter;
    }
    return _addLab;
}


- (UIImageView *)addressIcon {
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc] init];
        _addressIcon.image = [UIImage imageNamed:@"icon_address"];
    }
    return _addressIcon;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.font = [UIFont systemFontOfSize:13];
    }
    return _userName;
}

- (UILabel *)cityName {
    if (!_cityName) {
        _cityName = [[UILabel alloc] init];
        _cityName.font = [UIFont systemFontOfSize:10];
    }
    return _cityName;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:10];
        _addressLab.numberOfLines = 2;
    }
    return _addressLab;
}

- (UILabel *)phoneNum {
    if (!_phoneNum) {
        _phoneNum = [[UILabel alloc] init];
        _phoneNum.font = [UIFont systemFontOfSize:10];
    }
    return _phoneNum;
}

- (UIImageView *)openIcon {
    if (!_openIcon) {
        _openIcon = [[UIImageView alloc] init];
        _openIcon.image = [UIImage imageNamed:@"icon_next"];
    }
    return _openIcon;
}

@end
