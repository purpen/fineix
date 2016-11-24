//
//  THNOrderNumberTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNOrderNumberTableViewCell.h"

@implementation THNOrderNumberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setOrederNumberData:(OrderInfoModel *)model {
    self.number.text = [NSString stringWithFormat:@"订单号：%@", model.expressNo];
    self.state.text = model.statusLabel;
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    [self addSubview:topLine];
    
    [self addSubview:self.number];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.state];
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 44));
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

- (UILabel *)state {
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.font = [UIFont systemFontOfSize:14];
        _state.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _state.textAlignment = NSTextAlignmentRight;
    }
    return _state;
}

@end
