//
//  THNRecordInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/1/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNRecordInfoTableViewCell.h"

@implementation THNRecordInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 交易详情
- (void)thn_setTradingRecordInfoData:(THNTradingInfoData *)model {
    NSArray *textArr = @[@"产品", @"单价", @"收益比率", @"金额", @"数量"];
    [self setTradingInfoText:textArr];

    if (model) {
        NSString *goodsPrice = [NSString stringWithFormat:@"￥%.2f", model.skuPrice];
        NSString *unitPrice = [NSString stringWithFormat:@"￥%.2f", model.unitPrice];
        NSString *percent = [NSString stringWithFormat:@"%.2f％", model.commisionPercent *100];
        NSString *number = [NSString stringWithFormat:@"%zi", model.quantity];
        NSArray *dataArr = @[model.product.shortTitle, goodsPrice, percent, unitPrice, number];
        [self setTradingInfoData:dataArr];
    }
}

#pragma mark - 结算详情
- (void)thn_setSettlementRecordInfoData:(THNSettlementInfoRow *)model {
    NSArray *textArr = @[@"产品", @"单价", @"收益比率", @"金额", @"数量"];
    [self setTradingInfoText:textArr];
    
    if (model) {
        NSString *goodsPrice = [NSString stringWithFormat:@"￥%.2f", model.balance.skuPrice];
        NSString *unitPrice = [NSString stringWithFormat:@"￥%.2f", model.balance.unitPrice];
        NSString *percent = [NSString stringWithFormat:@"%.2f％", model.balance.commisionPercent *100];
        NSString *number = [NSString stringWithFormat:@"%zi", model.balance.quantity];
        NSArray *dataArr = @[model.balance.product.shortTitle, goodsPrice, percent, unitPrice, number];
        [self setTradingInfoData:dataArr];
    }
}

- (void)setTradingInfoText:(NSArray *)textArr {
    for (NSUInteger idx = 0; idx < textArr.count; ++idx) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.text = textArr[idx];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 35));
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(30 *idx);
        }];
    }
}

- (void)setTradingInfoData:(NSArray *)data {
    for (NSUInteger idx = 0; idx < data.count; ++idx) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.text = data[idx];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 35));
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(30 *idx);
        }];
    }
}

@end
