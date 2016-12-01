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
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, 0)];
    [self.goodsTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height+5));
    }];
    
    if (model.stage == 9) {
        NSString *salePrice = [NSString stringWithFormat:@"¥ %zi", model.salePrice];
        NSString *oldPrice = [NSString stringWithFormat:@"¥ %zi",  model.marketPrice];
        NSAttributedString *oldAttPrice = [[NSAttributedString alloc] initWithString:oldPrice
                                                                       attributes:@{NSStrikethroughStyleAttributeName:@1}];
        self.goodsPrice.text = salePrice;
        self.goodsOldPrice.attributedText = oldAttPrice;
        CGFloat priceWidth = [salePrice boundingRectWithSize:CGSizeMake(320, 17) options:(NSStringDrawingUsesDeviceMetrics) attributes:nil context:nil].size.width;
        CGFloat oldPriceWidth = [oldPrice boundingRectWithSize:CGSizeMake(320, 17) options:(NSStringDrawingUsesDeviceMetrics) attributes:nil context:nil].size.width;
        
        [self.goodsPrice mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(priceWidth *1.5));
        }];
        
        [self.goodsOldPrice mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(oldPriceWidth *1.5));
        }];
        
    } else {
        self.goodsPrice.font = [UIFont systemFontOfSize:11];
        self.goodsPrice.text = @"此产品为用户标记，暂未销售。浮游正在努力上架产品中ing...";
        [self.goodsPrice mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
    }
    
    if (model.marketPrice == model.salePrice) {
        [self.goodsOldPrice mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
    if (model.orderReduce == 1) {
        self.activityLab.hidden = NO;
    }
}

- (void)setGoodsInfoData:(GoodsInfoData *)model {
    self.goodsTitle.text = model.title;
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, 0)];
    [self.goodsTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height+5));
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
    CGSize size = [self.goodsTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, 0)];
    self.cellHeight = size.height + 50;
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-90);
    }];
    
    [self addSubview:self.goodsPrice];
    [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30 , 17));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70 , 20));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self addSubview:self.goodsOldPrice];
    [_goodsOldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70 , 17));
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(_goodsPrice.mas_right).with.offset(3);
    }];
    
    [self addSubview:self.activityLab];
    [_activityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66 , 18));
        make.centerY.equalTo(_goodsOldPrice);
        make.left.equalTo(_goodsOldPrice.mas_right).with.offset(3);
    }];
    
    UILabel *botLine = [[UILabel alloc] init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#666666" alpha:0.2];
    [self addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

#pragma mark -  标题
- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] init];
        _goodsTitle.textColor = [UIColor colorWithHexString:titleColor];
        _goodsTitle.font = [UIFont systemFontOfSize:Font_InfoTitle];
        _goodsTitle.numberOfLines = 2;
    }
    return _goodsTitle;
}

#pragma mark - 价格
- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.textColor = [UIColor colorWithHexString:fineixColor];
        _goodsPrice.font = [UIFont systemFontOfSize:Font_GoodsPrice];
    }
    return _goodsPrice;
}

#pragma mark - 原价
- (UILabel *)goodsOldPrice {
    if (!_goodsOldPrice) {
        _goodsOldPrice = [[UILabel alloc] init];
        _goodsOldPrice.textColor = [UIColor colorWithHexString:@"#999999"];
        _goodsOldPrice.font = [UIFont systemFontOfSize:14];
    }
    return _goodsOldPrice;
}

#pragma mark - 活动
- (UILabel *)activityLab {
    if (!_activityLab) {
        _activityLab = [[UILabel alloc] init];
        _activityLab.layer.cornerRadius = 3.0f;
        _activityLab.layer.borderWidth = 0.5f;
        _activityLab.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        _activityLab.font = [UIFont systemFontOfSize:14];
        _activityLab.textAlignment = NSTextAlignmentCenter;
        _activityLab.textColor = [UIColor colorWithHexString:fineixColor];
        _activityLab.text = @"随机立减";
        _activityLab.hidden = YES;
    }
    return _activityLab;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_nextBtn setTitle:NSLocalizedString(@"goodsInfoShow", nil) forState:(UIControlStateNormal)];
        _nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_nextBtn setImage:[UIImage imageNamed:@"button_right_next"] forState:(UIControlStateNormal)];
        [_nextBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 60, 0, 0))];
        _nextBtn.userInteractionEnabled = NO;
    }
    return _nextBtn;
}

@end
