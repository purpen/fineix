//
//  FBGoodsColorTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBGoodsColorTableViewCell.h"

@implementation FBGoodsColorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.goodsColorLab];
        [_goodsColorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 15));
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
        [self addSubview:self.nextIcon];
        [_nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_goodsColorLab);
            make.right.equalTo(self.mas_right).with.offset(-16);
        }];
        
    }
    return self;
}

- (UILabel *)goodsColorLab {
    if (!_goodsColorLab) {
        _goodsColorLab = [[UILabel alloc] init];
        if (IS_iOS9) {
            _goodsColorLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _goodsColorLab.font = [UIFont systemFontOfSize:14];
        }
        _goodsColorLab.textAlignment = NSTextAlignmentLeft;
        _goodsColorLab.textColor = [UIColor blackColor];
    }
    return _goodsColorLab;
}

- (UIImageView *)nextIcon {
    if (!_nextIcon) {
        _nextIcon = [[UIImageView alloc] init];
        _nextIcon.image = [UIImage imageNamed:@"entr"];
    }
    return _nextIcon;
}

@end
