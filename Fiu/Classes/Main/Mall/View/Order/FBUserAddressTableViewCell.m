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
    if (addressModel.countyName.length == 0) {
        addressModel.countyName = @"";
    }
    if (addressModel.townName.length == 0) {
        addressModel.townName = @"";
    }
    self.userName.text = [NSString stringWithFormat:@"收货人：%@", addressModel.name];
    self.cityName.text = [NSString stringWithFormat:@"%@ %@ %@ %@", addressModel.provinceName ,addressModel.cityName ,addressModel.countyName ,addressModel.townName];
    self.addressLab.text = addressModel.address;
    self.phoneNum.text = addressModel.phone;
}

- (void)thn_setOrderAddressModel:(DeliveryAddressModel *)model {
    if (model) {
        if (model.countyName.length == 0) {
            model.countyName = @"";
        }
        if (model.townName.length == 0) {
            model.townName = @"";
        }
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
    
    [self addSubview:self.shouHuoFangShiLabel];
    [_shouHuoFangShiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.mas_equalTo(self.mas_top).mas_offset(20);
    }];
    
    [self addSubview:self.kuaiDiBtn];
    [_kuaiDiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shouHuoFangShiLabel.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.shouHuoFangShiLabel.mas_centerY).mas_offset(0);
    }];
    
    [self addSubview:self.kuaiDiLabel];
    [_kuaiDiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kuaiDiBtn.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.shouHuoFangShiLabel.mas_centerY).mas_offset(0);
    }];
    
    [self addSubview:self.kuaiDiCoverBtn];
    [_kuaiDiCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kuaiDiBtn.mas_left).with.offset(0);
        make.top.mas_equalTo(self.kuaiDiBtn.mas_top).mas_offset(0);
        make.right.mas_equalTo(self.kuaiDiLabel.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.kuaiDiBtn.mas_bottom).mas_offset(0);
    }];
    
    [self addSubview:self.ziTiBtn];
    [_ziTiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kuaiDiLabel.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.shouHuoFangShiLabel.mas_centerY).mas_offset(0);
    }];
    
    [self addSubview:self.ziTiLabel];
    [_ziTiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ziTiBtn.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.shouHuoFangShiLabel.mas_centerY).mas_offset(0);
    }];
    
    [self addSubview:self.ziTiCoverBtn];
    [_ziTiCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ziTiBtn.mas_left).with.offset(0);
        make.top.mas_equalTo(self.ziTiBtn.mas_top).mas_offset(0);
        make.right.mas_equalTo(self.ziTiLabel.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.ziTiBtn.mas_bottom).mas_offset(0);
    }];
    
    [self addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.mas_equalTo(self.ziTiBtn.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.mas_right).mas_offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(10);
    }];
    
    [self addSubview:self.addressIcon];
    [_addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10.5, 17));
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(30);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.openIcon];
    [_openIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10.5, 17));
        make.centerY.mas_equalTo(self.addressIcon.mas_centerY).mas_offset(0);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];
    
    [self addSubview:self.userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 14));
        make.top.equalTo(self.lineView.mas_bottom).with.offset(20);
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
        make.centerY.mas_equalTo(self.addressIcon.mas_centerY).mas_offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.addIcon];
    [_addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self.addressIcon.mas_centerY).mas_offset(0);
        make.right.equalTo(_addLab.mas_left).with.offset(-10);
    }];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
    }
    return _lineView;
}

-(UIButton *)ziTiCoverBtn{
    if (!_ziTiCoverBtn) {
        _ziTiCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _ziTiCoverBtn;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = [UIColor colorWithHexString:@"#F05958"];
        _tipLabel.text = @"* 联系所在店铺工作人员领取该商品";
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

-(UILabel *)ziTiLabel{
    if (!_ziTiLabel) {
        _ziTiLabel = [[UILabel alloc] init];
        _ziTiLabel.font = [UIFont systemFontOfSize:13];
        _ziTiLabel.textColor = [UIColor colorWithRed:93/255.0 green:98/255.0 blue:102/255.0 alpha:1];
        _ziTiLabel.text = @"自提";
    }
    return _ziTiLabel;
}

-(UIButton *)ziTiBtn{
    if (!_ziTiBtn) {
        _ziTiBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_ziTiBtn setImage:[UIImage imageNamed:@"NotSelected"] forState:UIControlStateNormal];
        [_ziTiBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateDisabled];
    }
    return _ziTiBtn;
}

-(UIButton *)kuaiDiCoverBtn{
    if (!_kuaiDiCoverBtn) {
        _kuaiDiCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _kuaiDiCoverBtn;
}

-(UILabel *)kuaiDiLabel{
    if (!_kuaiDiLabel) {
        _kuaiDiLabel = [[UILabel alloc] init];
        _kuaiDiLabel.font = [UIFont systemFontOfSize:13];
        _kuaiDiLabel.textColor = [UIColor colorWithRed:93/255.0 green:98/255.0 blue:102/255.0 alpha:1];
        _kuaiDiLabel.text = @"快递";
    }
    return _kuaiDiLabel;
}

-(UIButton *)kuaiDiBtn{
    if (!_kuaiDiBtn) {
        _kuaiDiBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_kuaiDiBtn setImage:[UIImage imageNamed:@"NotSelected"] forState:UIControlStateNormal];
        [_kuaiDiBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateDisabled];
    }
    return _kuaiDiBtn;
}

-(UILabel *)shouHuoFangShiLabel{
    if (!_shouHuoFangShiLabel) {
        _shouHuoFangShiLabel = [[UILabel alloc] init];
        _shouHuoFangShiLabel.font = [UIFont systemFontOfSize:13];
        _shouHuoFangShiLabel.textColor = [UIColor colorWithRed:93/255.0 green:98/255.0 blue:102/255.0 alpha:1];
        _shouHuoFangShiLabel.text = @"收货方式:";
    }
    return _shouHuoFangShiLabel;
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
