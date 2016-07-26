//
//  ShareSearchTextTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShareSearchTextTableViewCell.h"

@implementation ShareSearchTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
        
        [self addSubview:self.des];
        [_des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
    }
    return self;
}

- (void)setShareTextData:(ShareInfoRow *)model {
    self.title.text = model.title;
    self.des.text = model.des;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.9];
        _title.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _title.numberOfLines = 0;
    }
    return _title;
}

- (UILabel *)des {
    if (!_des) {
        _des = [[UILabel alloc] init];
        _des.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.8];
        _des.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _des.numberOfLines = 0;
    }
    return _des;
}

@end
