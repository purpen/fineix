//
//  THNHasSubOrdersTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHasSubOrdersTableViewCell.h"

static NSString *const promptText = @"    您购买的商品将由以下订单分开进行派送";

@implementation THNHasSubOrdersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_getOrderStateAndNumber:(OrderInfoModel *)model {
    self.number.text = [NSString stringWithFormat:@"订单号：%@", model.rid];
    self.stateLab.text = model.statusLabel;
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.number];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.prompt];
    [_prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(_number.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.stateLab];
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 44));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
}

- (UILabel *)number {
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.font = [UIFont systemFontOfSize:14];
        _number.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _number;
}

- (UILabel *)prompt {
    if (!_prompt) {
        _prompt = [[UILabel alloc] init];
        _prompt.font = [UIFont systemFontOfSize:12];
        _prompt.textColor = [UIColor colorWithHexString:@"#999999"];
        _prompt.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _prompt.text = promptText;
    }
    return _prompt;
}

- (UILabel *)stateLab {
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.font = [UIFont systemFontOfSize:14];
        _stateLab.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _stateLab.textAlignment = NSTextAlignmentRight;
    }
    return _stateLab;
}

@end
