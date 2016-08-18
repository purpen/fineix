//
//  THNAddGoodsBtn.m
//  Fiu
//
//  Created by FLYang on 16/8/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAddGoodsBtn.h"

@implementation THNAddGoodsBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#8F8F8"];
        [self setCellUI];
    }
    return self;
}

- (void)setAddGoodsOrBrandInfo:(NSInteger)type withText:(NSString *)text {
    if (type == 1) {
        self.add.text = NSLocalizedString(@"tapAddBrand", nil);
    } else {
        self.add.text = NSLocalizedString(@"tapAddGoods", nil);
    }
    
    self.name.text = text;
}

#pragma mark - setCellUI
- (void)setCellUI {
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 44));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.add];
    [_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.left.equalTo(_icon.mas_right).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(_add.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    UILabel *botLine = [[UILabel alloc] init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.bottom.equalTo(self).with.offset(0);
    }];
}

#pragma mark - init
- (UIButton *)icon {
    if (!_icon) {
        _icon = [[UIButton alloc] init];
        [_icon setImage:[UIImage imageNamed:@"ic_add_circle_outline"] forState:(UIControlStateNormal)];
    }
    return _icon;
}

- (UILabel *)add {
    if (!_add) {
        _add = [[UILabel alloc] init];
        _add.textColor = [UIColor colorWithHexString:@"#666666"];
        _add.font = [UIFont systemFontOfSize:14];
    }
    return _add;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor colorWithHexString:@"#000000"];
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}
@end
