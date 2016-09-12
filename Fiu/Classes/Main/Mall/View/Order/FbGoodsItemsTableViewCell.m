//
//  FbGoodsItemsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBGoodsItemsTableViewCell.h"

@implementation FBGoodsItemsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.goodsImg];
        [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 75));
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(10);
        }];
        
        [self addSubview:self.goodsTitle];
        [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImg.mas_top).with.offset(0);
            make.left.equalTo(_goodsImg.mas_right).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-10);
        }];
        
        [self addSubview:self.goodsColor];
        [_goodsColor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsTitle.mas_bottom).with.offset(5);
            make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        }];
        
        [self addSubview:self.goodsNum];
        [_goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsColor.mas_top).with.offset(0);
            make.left.equalTo(_goodsColor.mas_right).with.offset(5);
        }];
        
        [self addSubview:self.goodsPrice];
        [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 15));
            make.bottom.equalTo(_goodsImg.mas_bottom).with.offset(0);
            make.left.equalTo(_goodsImg.mas_right).with.offset(15);
            
        }];
        
        [self addSubview:self.lineBgLab];
        [_lineBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
        
    }
    return self;
}

- (void)setOrderModelData:(OrderItems *)orderModel {
    [self.goodsImg downloadImage:orderModel.cover place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = orderModel.title;
    
    if ([orderModel.skuMode isKindOfClass:[NSNull class]] || orderModel.skuMode == NULL) {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", @"默认"];
    } else
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", orderModel.skuMode];
    self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", orderModel.quantity];
    self.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f", orderModel.salePrice];
    
}

- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        _goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImg.clipsToBounds = YES;
    }
    return _goodsImg;
}

- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] init];
        _goodsTitle.numberOfLines = 2;
        if (IS_iOS9) {
            _goodsTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _goodsTitle.font = [UIFont systemFontOfSize:14];
        }
        _goodsTitle.textAlignment = NSTextAlignmentLeft;
        _goodsTitle.textColor = [UIColor blackColor];
        
    }
    return _goodsTitle;
}

- (UILabel *)goodsColor {
    if (!_goodsColor) {
        _goodsColor = [[UILabel alloc] init];
        if (IS_iOS9) {
            _goodsColor.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _goodsColor.font = [UIFont systemFontOfSize:12];
        }
        _goodsColor.textColor = [UIColor colorWithHexString:titleColor];
        _goodsColor.textAlignment = NSTextAlignmentLeft;
        _goodsColor.numberOfLines = 1;
        
    }
    return _goodsColor;
}

- (UILabel *)goodsNum {
    if (!_goodsNum) {
        _goodsNum = [[UILabel alloc] init];
        if (IS_iOS9) {
            _goodsNum.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _goodsNum.font = [UIFont systemFontOfSize:12];
        }
        _goodsNum.textColor = [UIColor colorWithHexString:titleColor];
        _goodsNum.textAlignment = NSTextAlignmentLeft;
        
    }
    return _goodsNum;
}

- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        if (IS_iOS9) {
            _goodsPrice.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _goodsPrice.font = [UIFont systemFontOfSize:14];
        }
        _goodsPrice.textColor = [UIColor colorWithHexString:fineixColor];
        _goodsPrice.textAlignment = NSTextAlignmentLeft;
        
    }
    return _goodsPrice;
}

- (UILabel *)lineBgLab {
    if (!_lineBgLab) {
        _lineBgLab = [[UILabel alloc] init];
        _lineBgLab.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    }
    return _lineBgLab;
}

@end
