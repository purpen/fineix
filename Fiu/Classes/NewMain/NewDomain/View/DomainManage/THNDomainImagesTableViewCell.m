//
//  THNDomainImagesTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainImagesTableViewCell.h"

@implementation THNDomainImagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellViewUI];
    }
    return self;
}

- (void)setCellViewUI {
    [self addSubview:self.titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLable.text = @"地盘图片";
    }
    return _titleLable;
}

@end
