//
//  InfoBrandTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoBrandTableViewCell.h"

@implementation InfoBrandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
        
    }
    return self;
}

- (void)setUI {
    self.brandTitle.text = @"colorstar";
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.brandImg];
    [_brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.brandTitle];
    [_brandTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.centerY.equalTo(self);
        make.left.equalTo(self.brandImg.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.nextIcon];
    [_nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 15.5));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

#pragma mark - LOGO
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] init];
        _brandImg.layer.cornerRadius = 25;
        _brandImg.layer.masksToBounds = YES;
        _brandImg.backgroundColor = [UIColor grayColor];
    }
    return _brandImg;
}

#pragma mark - 名称
- (UILabel *)brandTitle {
    if (!_brandTitle) {
        _brandTitle = [[UILabel alloc] init];
        _brandTitle.textColor = [UIColor colorWithHexString:titleColor];
        _brandTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
    }
    return _brandTitle;
}

#pragma mark - 指示图标
- (UIImageView *)nextIcon {
    if (!_nextIcon) {
        _nextIcon = [[UIImageView alloc] init];
        _nextIcon.image = [UIImage imageNamed:@"entr"];
    }
    return _nextIcon;
}

@end
