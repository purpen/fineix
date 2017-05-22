//
//  THNInfoTitleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNInfoTitleTableViewCell.h"

@implementation THNInfoTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
    }
    return self;
}

- (void)thn_setInfoTitleLeftText:(NSString *)leftText andRightText:(NSString *)rightText {
    self.leftLabel.text = leftText;
    if (rightText.length == 0) {
        self.rightLabel.hidden = YES;
    } else {
        self.rightLabel.hidden = NO;
        self.rightLabel.text = rightText;
    }
}

- (void)thn_showImage:(NSString *)imageUrl {
    [self.infoImageView downloadImage:imageUrl place:[UIImage imageNamed:@""]];
    [self addSubview:self.infoImageView];
    [_infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.equalTo(_nextButton.mas_left).with.offset(-10);
        make.centerY.equalTo(self);
    }];
}

- (void)thn_showLeftButton {
    [self addSubview:self.leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(40);
    }];
}

- (void)thn_hiddenNextIcon:(BOOL)hidden {
    self.nextButton.hidden = hidden;
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@110);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.bottom.equalTo(self).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@7);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.bottom.equalTo(self).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@150);
        make.right.equalTo(_nextButton.mas_left).with.offset(-10);
        make.top.bottom.equalTo(self).with.offset(0);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _leftLabel.font = [UIFont systemFontOfSize:14];
    }
    return _leftLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
//        [_leftButton setImage:[UIImage imageNamed:@"Add_Scene"] forState:(UIControlStateNormal)];
    }
    return _leftButton;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton setImage:[UIImage imageNamed:@"icon_Next"] forState:(UIControlStateNormal)];
    }
    return _nextButton;
}

- (UIImageView *)infoImageView {
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] init];
        _infoImageView.layer.cornerRadius = 15.0f;
        _infoImageView.layer.masksToBounds = YES;
        _infoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _infoImageView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _infoImageView;
}

@end
