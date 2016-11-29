//
//  THNRefundTimeTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRefundTimeTableViewCell.h"

@implementation THNRefundTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setRefundPriceData:(RefundGoodsModel *)model {
    if (model) {
        self.timeLab.text = model.createdAt;
        NSString *priceModel = [NSString stringWithFormat:@"退款金额:￥%.2f", model.refundPrice];
        NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:priceModel];
        [price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, 5)];
        self.priceLab.attributedText = price;
        
    }
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 13));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 13));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    [self addSubview:topLine];
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _timeLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = [UIFont systemFontOfSize:12];
        _priceLab.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _priceLab.textAlignment = NSTextAlignmentRight;
    }
    return _priceLab;
}
@end
