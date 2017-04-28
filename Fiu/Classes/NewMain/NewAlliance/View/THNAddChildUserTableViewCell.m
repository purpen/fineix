//
//  THNAddChildUserTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAddChildUserTableViewCell.h"

@implementation THNAddChildUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self thn_setCellUI];
    }
    return self;
}

#pragma mark - 
- (void)thn_setCellUI {
    [self addSubview:self.iconImage];
    [self addSubview:self.hintLabel];
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 15, 15)];
        _iconImage.image = [UIImage imageNamed:@"Add_Scene"];
    }
    return _iconImage;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 48)];
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _hintLabel.text = @"添加子账号";
    }
    return _hintLabel;
}

@end
