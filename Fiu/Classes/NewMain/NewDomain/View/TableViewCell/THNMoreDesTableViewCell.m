//
//  THNMoreDesTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNMoreDesTableViewCell.h"

@implementation THNMoreDesTableViewCell

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
    [self addSubview:self.moreButton];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerY.centerX.equalTo(self);
    }];
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:(UIControlStateNormal)];
        [_moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_open"] forState:(UIControlStateNormal)];
        [_moreButton setTitle:@"点击收起" forState:(UIControlStateSelected)];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_close"] forState:(UIControlStateSelected)];
        [_moreButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 80, 0, 0))];
        [_moreButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        _moreButton.selected = NO;
        _moreButton.userInteractionEnabled = NO;
    }
    return _moreButton;
}

@end
