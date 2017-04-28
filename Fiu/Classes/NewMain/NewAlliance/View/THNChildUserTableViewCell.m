//
//  THNChildUserTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNChildUserTableViewCell.h"

@implementation THNChildUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self thn_setCellUI];
    }
    return self;
}

- (void)thn_setChildUserData:(THNChildUserModel *)model {
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", model.money];
    [self thn_changeNameTextAttributed:model.name phone:model.phone];
}

- (void)thn_changeNameTextAttributed:(NSString *)name phone:(NSString *)phone {
    NSString *text = [NSString stringWithFormat:@"%@  %@", name, phone];
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:text];
    [nameText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, text.length)];
    [nameText addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]} range:NSMakeRange(0, name.length)];
    [nameText addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(name.length + 2, phone.length)];
    self.nameLabel.attributedText = nameText;
}

#pragma mark -
- (void)thn_setCellUI {
    [self addSubview:self.lineLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.iconImage];
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 24, 16, 9, 15)];
        _iconImage.image = [UIImage imageNamed:@"cell_go"];
    }
    return _iconImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 48)];
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 0, 100, 48)];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    }
    return _lineLabel;
}

@end
