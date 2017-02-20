//
//  THNCouponTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNCouponTableViewCell.h"

@implementation THNCouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)thn_setCouponCount {
    [self.coupon setTitle:@"领取10元优惠券" forState:(UIControlStateNormal)];
}

- (void)setCellViewUI {
    [self addSubview:self.coupon];
    [_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self).with.offset(0);
    }];
}

- (UIButton *)coupon {
    if (!_coupon) {
        _coupon = [[UIButton alloc] init];
        [_coupon setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:(UIControlStateNormal)];
        _coupon.titleLabel.font = [UIFont systemFontOfSize:14];
        [_coupon setImage:[UIImage imageNamed:@"icon_coupon"] forState:(UIControlStateNormal)];
        [_coupon setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    }
    return _coupon;
}

@end
