//
//  THNSearchBrandTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSearchBrandTableViewCell.h"

@implementation THNSearchBrandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8" alpha:1];
        [self setCellUI];
    }
    return self;
}

- (void)setBrandData:(FiuBrandRow *)model {
    [self.image downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.name.text = model.title;
}

#pragma mark - setCellUI
- (void)setCellUI {
    [self addSubview:self.image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.left.equalTo(_image.mas_right).with.offset(10);
        make.centerY.equalTo(_image);
    }];
    
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 80));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - init
- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.layer.cornerRadius = 50/2;
        _image.layer.masksToBounds = YES;
        _image.layer.borderColor = [UIColor colorWithHexString:@"#D8D8D8" alpha:1].CGColor;
        _image.layer.borderWidth = 0.5f;
        _image.backgroundColor = [UIColor whiteColor];
    }
    return _image;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor blackColor];
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}

- (UIButton *)icon {
    if (!_icon) {
        _icon = [[UIButton alloc] init];
        [_icon setImage:[UIImage imageNamed:@"button_right_next"] forState:(UIControlStateNormal)];
    }
    return _icon;
}

@end
