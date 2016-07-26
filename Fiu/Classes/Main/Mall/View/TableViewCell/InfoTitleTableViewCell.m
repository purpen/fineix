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
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
        
    }
    return self;
}

- (void)setThnGoodsInfoData:(FBGoodsInfoModelData *)model {
    self.goodsTitle.text = model.title;
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    [self.goodsTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30 , size.height+5));
    }];
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %.2f", model.salePrice];
}

- (void)setGoodsInfoData:(GoodsInfoData *)model {
    self.goodsTitle.text = model.title;
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    [self.goodsTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30 , size.height+5));
    }];
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %.2f", model.salePrice];
    
    UILabel * botLine = [[UILabel alloc] init];
    botLine.backgroundColor = [UIColor colorWithHexString:cellBgColor];
    [self addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 5));
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];

}

- (void)getContentCellHeight:(NSString *)content {
    self.goodsTitle.text = content;
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    self.cellHeight = size.height + 50;
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
        _goodsTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_InfoTitle];
        _goodsTitle.numberOfLines = 2;
    }
    return _goodsTitle;
}

#pragma mark - 价格
- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.textColor = [UIColor colorWithHexString:fineixColor];
        _goodsPrice.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_GoodsPrice];
        
    }
    return _goodsPrice;
}

@end
