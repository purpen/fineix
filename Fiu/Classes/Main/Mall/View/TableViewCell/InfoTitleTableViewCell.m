//
//  InfoTitleTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoTitleTableViewCell.h"

@implementation InfoTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
        
    }
    return self;
}

- (void)setGoodsInfoData:(GoodsInfoData *)model {
    self.goodsTitle.text = model.title;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %.2f", model.marketPrice];
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30 , 17));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.goodsPrice];
    [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30 , 17));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
}

#pragma mark -  标题
- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] init];
        _goodsTitle.textColor = [UIColor colorWithHexString:titleColor];
        _goodsTitle.font = [UIFont systemFontOfSize:Font_InfoTitle];
    }
    return _goodsTitle;
}

#pragma mark - 价格
- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.textColor = [UIColor colorWithHexString:fiuRedColor];
        _goodsPrice.font = [UIFont systemFontOfSize:Font_GoodsPrice];
        
    }
    return _goodsPrice;
}

@end
