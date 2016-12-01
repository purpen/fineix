//
//  FBOrderOtherTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBOrderOtherTableViewCell.h"

@implementation FBOrderOtherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 13));
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(10);
        }];
        
        [self addSubview:self.textLab];
        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 14));
            make.centerY.equalTo(self);
            make.left.equalTo(_titleLab.mas_right).with.offset(5);
        }];
        
        [self addSubview:self.seletedIcon];
        [_seletedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7.5, 13));
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).with.offset(-20);
        }];
    }
    return self;
}

- (void)thn_setFreightMoney:(NSString *)price {
    self.seletedIcon.hidden = YES;
    self.titleLab.text = @"运      费：";
    self.textLab.text = price;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _titleLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _titleLab.font = [UIFont systemFontOfSize:14];
        }
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.textColor = [UIColor blackColor];
        if (IS_iOS9) {
            _textLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _textLab.font = [UIFont systemFontOfSize:14];
        }
        _textLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _textLab;
}

- (UIImageView *)seletedIcon {
    if (!_seletedIcon) {
        _seletedIcon = [[UIImageView alloc] init];
        _seletedIcon.image = [UIImage imageNamed:@"icon_next"];
    }
    return _seletedIcon;
}

@end
