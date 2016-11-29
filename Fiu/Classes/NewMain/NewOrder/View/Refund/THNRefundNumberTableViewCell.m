//
//  THNRefundNumberTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRefundNumberTableViewCell.h"

@implementation THNRefundNumberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setRefundNumberData:(RefundGoodsModel *)model {
    if (model) {
        self.numLab.text = [NSString stringWithFormat:@"退款单号：%@", model.idField];
        self.stageLab.text = model.stageLabel;
    }
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.numLab];
    [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 13));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.stageLab];
    [_stageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 13));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont systemFontOfSize:12];
        _numLab.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _numLab;
}

- (UILabel *)stageLab {
    if (!_stageLab) {
        _stageLab = [[UILabel alloc] init];
        _stageLab.font = [UIFont systemFontOfSize:12];
        _stageLab.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _stageLab.textAlignment = NSTextAlignmentRight;
    }
    return _stageLab;
}

@end
