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
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %zi", model.salePrice];
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
