//
//  THNSearchGoodsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSearchGoodsTableViewCell.h"

@implementation THNSearchGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setCellUI];
    }
    return self;
}

- (void)setGoodsInfo:(NSString *)brandTitle withGoods:(NSString *)goodsTitle {
    CGSize width = [brandTitle boundingRectWithSize:CGSizeMake(320, 0)
                                       options:(NSStringDrawingUsesFontLeading)
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                       context:nil].size;
    
    self.brandName.text = brandTitle;
    [self.brandName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width.width * 1.3));
    }];
    
    self.goodsName.text = goodsTitle;

}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.brandName];
    [_brandName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.goodsName];
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(_brandName.mas_right).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - init
- (UILabel *)brandName {
    if (!_brandName) {
        _brandName = [[UILabel alloc] init];
        _brandName.textColor = [UIColor colorWithHexString:@"#999999"];
        _brandName.font = [UIFont systemFontOfSize:14];
    }
    return _brandName;
}

- (UILabel *)goodsName {
    if (!_goodsName) {
        _goodsName = [[UILabel alloc] init];
        _goodsName.textColor = [UIColor colorWithHexString:@"#000000"];
        _goodsName.font = [UIFont systemFontOfSize:14];
    }
    return _goodsName;
}

@end
