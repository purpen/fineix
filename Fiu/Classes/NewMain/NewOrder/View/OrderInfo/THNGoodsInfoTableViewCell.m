//
//  THNGoodsInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNGoodsInfoTableViewCell.h"
#import "THNApplyRefundViewController.h"
#import "FBGoodsInfoViewController.h"

@interface THNGoodsInfoTableViewCell () {
    NSString *_skuId;
    NSString *_rid;
    NSInteger _refundType;
}

@end

@implementation THNGoodsInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self thn_setCellUI];
    }
    return self;
}

- (void)thn_setGoodsInfoData:(ProductInfoModel *)model withRid:(NSString *)rid type:(NSInteger)type {
    if (type == 1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookGoodsInfo:)];
        [self addGestureRecognizer:tap];
    }
    _skuId = [NSString stringWithFormat:@"%zi", model.sku];
    _rid = rid;
    
    [self.goodsImg downloadImage:model.coverUrl place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.name;
    self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", model.quantity];
    self.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f", [model.salePrice floatValue]];
    self.refundState.text = model.refundLabel;
     [self thn_setRrfundButtonTitleWithType:model.refundButton];
    
    if (model.skuName.length == 0) {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", @"默认"];
    } else {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", model.skuName];
    }
    
    if (model.vopId > 0) {
        self.JDGoodsLab.hidden = NO;
    } else {
        self.JDGoodsLab.hidden = YES;
    }
    
}

- (void)lookGoodsInfo:(UITapGestureRecognizer *)tap {
    FBGoodsInfoViewController *goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = _skuId;
    [self.nav pushViewController:goodsInfoVC animated:YES];
}

- (void)thn_setRrfundButtonTitleWithType:(NSInteger)type {
    switch (type) {
        case 0:
            self.refundBtn.hidden = YES;
            break;
            
        case 1:
            _refundType = 1;
            self.refundState.hidden = YES;
            [self.refundBtn setTitle:@"退款" forState:(UIControlStateNormal)];
            break;
            
        case 2:
            _refundType = 2;
            self.refundState.hidden = YES;
            [self.refundBtn setTitle:@"退货／款" forState:(UIControlStateNormal)];
            break;
            
        default:
            break;
    }
}

#pragma mark -
- (void)thn_setCellUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#E1E1E1"];
    [self addSubview:topLine];
    
    [self addSubview:self.goodsImg];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImg.mas_top).with.offset(0);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-70);
    }];
    
    
    [self addSubview:self.goodsColor];
    [_goodsColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsTitle.mas_bottom).with.offset(5);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
    }];
    
    [self addSubview:self.goodsNum];
    [_goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsColor.mas_top).with.offset(0);
        make.left.equalTo(_goodsColor.mas_right).with.offset(5);
    }];
    
    [self addSubview:self.goodsPrice];
    [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.bottom.equalTo(_goodsImg.mas_bottom).with.offset(0);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
    }];
    
    [self addSubview:self.JDGoodsLab];
    [_JDGoodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(_goodsPrice);
    }];
    
    [self addSubview:self.refundBtn];
    [_refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 25));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(_goodsImg);
    }];
    
    [self addSubview:self.refundState];
    [_refundState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 15));
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(_goodsImg);
    }];
}

- (UILabel *)refundState {
    if (!_refundState) {
        _refundState = [[UILabel alloc] init];
        _refundState.font = [UIFont systemFontOfSize:14];
        _refundState.textAlignment = NSTextAlignmentRight;
        _refundState.textColor = [UIColor colorWithHexString:MAIN_COLOR];
    }
    return _refundState;
}

- (UIButton *)refundBtn {
    if (!_refundBtn) {
        _refundBtn = [[UIButton alloc] init];
        _refundBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_refundBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _refundBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _refundBtn.layer.borderWidth = 0.5f;
        [_refundBtn addTarget:self action:@selector(refundBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _refundBtn;
}

#pragma mark - 点击进行退款
- (void)refundBtnClick:(UIButton *)button {
    THNApplyRefundViewController *applyRefundVC = [[THNApplyRefundViewController alloc] init];
    applyRefundVC.type = _refundType;
    applyRefundVC.skuId = _skuId;
    applyRefundVC.orderId = _rid;
    [self.nav pushViewController:applyRefundVC animated:YES];
}

- (UILabel *)JDGoodsLab {
    if (!_JDGoodsLab) {
        _JDGoodsLab = [[UILabel alloc] init];
        _JDGoodsLab.font = [UIFont systemFontOfSize:10];
        _JDGoodsLab.text = @"京东配货";
        _JDGoodsLab.textAlignment = NSTextAlignmentCenter;
        _JDGoodsLab.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
        _JDGoodsLab.layer.borderWidth = 0.5f;
        _JDGoodsLab.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:1].CGColor;
    }
    return _JDGoodsLab;
}

- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        _goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImg.clipsToBounds = YES;
        _goodsImg.layer.borderWidth = 0.5f;
        _goodsImg.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:0.8].CGColor;
    }
    return _goodsImg;
}

- (UILabel *)goodsTitle {
    if (!_goodsTitle) {
        _goodsTitle = [[UILabel alloc] init];
        _goodsTitle.numberOfLines = 2;
        _goodsTitle.font = [UIFont systemFontOfSize:12];
        _goodsTitle.textAlignment = NSTextAlignmentLeft;
        _goodsTitle.textColor = [UIColor blackColor];
        
    }
    return _goodsTitle;
}

- (UILabel *)goodsColor {
    if (!_goodsColor) {
        _goodsColor = [[UILabel alloc] init];
        _goodsColor.font = [UIFont systemFontOfSize:10];
        _goodsColor.textColor = [UIColor colorWithHexString:@"#666666"];
        _goodsColor.textAlignment = NSTextAlignmentLeft;
        _goodsColor.numberOfLines = 1;
        
    }
    return _goodsColor;
}

- (UILabel *)goodsNum {
    if (!_goodsNum) {
        _goodsNum = [[UILabel alloc] init];
        _goodsNum.font = [UIFont systemFontOfSize:10];
        _goodsNum.textColor = [UIColor colorWithHexString:@"#666666"];
        _goodsNum.textAlignment = NSTextAlignmentLeft;
        
    }
    return _goodsNum;
}

- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.font = [UIFont systemFontOfSize:13];
        _goodsPrice.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        _goodsPrice.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsPrice;
}

@end
