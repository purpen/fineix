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
- (void)thn_setTradingRecordInfoData {
    NSArray *textArr = @[@"产品", @"单价", @"佣金", @"收益比率", @"数量"];
    [self setTradingInfoText:textArr];
    
    NSArray *dataArr = @[@"云马电动车", @"￥2000.00", @"￥29.20", @"4％", @"2"];
    [self setTradingInfoData:dataArr];
}

#pragma mark - 结算详情
- (void)thn_setSettlementRecordInfoData {
    NSArray *textArr = @[@"产品", @"单价", @"佣金", @"收益比率", @"数量", @"时间"];
    [self setTradingInfoText:textArr];
    
    NSArray *dataArr = @[@"云马电动车", @"￥2000.00", @"￥29.20", @"4％", @"2", @"2017-01-16"];
    [self setTradingInfoData:dataArr];
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
            make.size.mas_equalTo(CGSizeMake(80, 35));
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(30 *idx);
        }];
    }
}

@end
