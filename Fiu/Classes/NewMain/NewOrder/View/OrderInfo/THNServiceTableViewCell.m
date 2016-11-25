//
//  THNServiceTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNServiceTableViewCell.h"

@implementation THNServiceTableViewCell

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
    
    [self addSubview:self.contact];
    [_contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)contact {
    if (!_contact) {
        _contact = [[UILabel alloc] init];
        _contact.textColor = [UIColor colorWithHexString:@"#666666"];
        _contact.textAlignment = NSTextAlignmentCenter;
        _contact.font = [UIFont systemFontOfSize:14];
        _contact.text = @"联系客服";
    }
    return _contact;
}

@end
