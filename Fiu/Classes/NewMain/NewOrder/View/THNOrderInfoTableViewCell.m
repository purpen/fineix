//
//  THNOrderInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNOrderInfoTableViewCell.h"

@implementation THNOrderInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.number];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.state];
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.expressCompany];
    [_expressCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.expressNum];
    [_expressNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (UILabel *)number {
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.font = [UIFont systemFontOfSize:14];
        _number.textColor = [UIColor colorWithHexString:@"#666666"];
        _number.text = @"订单号：125345345345";
    }
    return _number;
}

- (UILabel *)state {
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.font = [UIFont systemFontOfSize:14];
        _state.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _state.textAlignment = NSTextAlignmentRight;
        _state.text = @"代发货";
    }
    return _state;
}

- (UILabel *)expressCompany {
    if (!_expressCompany) {
        _expressCompany = [[UILabel alloc] init];
        _expressCompany.font = [UIFont systemFontOfSize:13];
        _expressCompany.textColor = [UIColor colorWithHexString:@"#666666"];
        _expressCompany.text = @"承运来源：圆通速递";
    }
    return _expressCompany;
}

- (UILabel *)expressNum {
    if (!_expressNum) {
        _expressNum = [[UILabel alloc] init];
        _expressNum.font = [UIFont systemFontOfSize:13];
        _expressNum.textColor = [UIColor colorWithHexString:@"#666666"];
        _expressNum.textAlignment = NSTextAlignmentRight;
        _expressNum.text = @"快递编号：3325324153145";
    }
    return _expressNum;
}

@end
