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

- (void)setGoodsBrandData:(GoodsInfoData *)model {
    [self.brandImg downloadImage:model.brand.coverUrl place:[UIImage imageNamed:@""]];
    self.brandTitle.text = model.brand.title;
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.brandImg];
    [_brandImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(self.mas_top).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.brandTitle];
    [_brandTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.centerY.equalTo(_brandImg);
        make.left.equalTo(_brandImg.mas_right).with.offset(10);
    }];
    
    [self addSubview:self.nextIcon];
    [_nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 15.5));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    UILabel * botLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 5)];
    botLine.backgroundColor = [UIColor colorWithHexString:cellBgColor];
    [self addSubview:botLine];
}

#pragma mark - LOGO
- (UIImageView *)brandImg {
    if (!_brandImg) {
        _brandImg = [[UIImageView alloc] init];
        _brandImg.contentMode = UIViewContentModeScaleAspectFill;
        _brandImg.layer.masksToBounds = YES;
        _brandImg.layer.cornerRadius = 25;
        _brandImg.layer.borderWidth = 1.0f;
        _brandImg.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1" alpha:1].CGColor;
    }
    return _brandImg;
}

#pragma mark - 名称
- (UILabel *)brandTitle {
    if (!_brandTitle) {
        _brandTitle = [[UILabel alloc] init];
        _brandTitle.textColor = [UIColor colorWithHexString:titleColor];
        if (IS_iOS9) {
            _brandTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_GoodsTitle];
        } else {
            _brandTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
        }
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
