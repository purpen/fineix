//
//  FBCarItemsTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBCarItemsTableViewCell.h"

@implementation FBCarItemsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
        
        //  from #import "GoodsCarViewController.h"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseAllClick) name:@"chooseAll" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacelAllClick) name:@"cacelAll" object:nil];
    }
    return self;
}

- (void)chooseAllClick {
    self.chooseBtn.selected = YES;
}

- (void)cacelAllClick {
    self.chooseBtn.selected = NO;
}

- (void)setGoodsCarItemData:(CarGoodsModelItem *)model {
    [self.goodsImg downloadImage:model.cover place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = model.title;
    
    if ([model.skuMode length] == 0) {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", @"默认"];
    } else {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", model.skuMode];
    }
    
    if (model.vopId > 0) {
        self.JDGoodsLab.hidden = NO;
    } else {
        self.JDGoodsLab.hidden = YES;
    }
    
    self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", model.n];
    self.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f", model.price];
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 90));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.goodsImg];
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.centerY.equalTo(self);
        make.left.equalTo(_chooseBtn.mas_right).with.offset(0);
    }];
    
    [self addSubview:self.goodsTitle];
    [_goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImg.mas_top).with.offset(0);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-10);
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
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn setImage:[UIImage imageNamed:@"Check"] forState:(UIControlStateNormal)];
        [_chooseBtn setImage:[UIImage imageNamed:@"Check_red"] forState:(UIControlStateSelected)];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _chooseBtn.selected = NO;
    }
    return _chooseBtn;
}

#pragma mark - 选中状态
- (void)chooseBtnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        
    } else if (button.selected == YES) {
        button.selected = NO;
    }
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
        _goodsColor.textColor = [UIColor colorWithHexString:titleColor];
        _goodsColor.textAlignment = NSTextAlignmentLeft;
        _goodsColor.numberOfLines = 1;
        
    }
    return _goodsColor;
}

- (UILabel *)goodsNum {
    if (!_goodsNum) {
        _goodsNum = [[UILabel alloc] init];
        _goodsNum.font = [UIFont systemFontOfSize:10];
        _goodsNum.textColor = [UIColor colorWithHexString:titleColor];
        _goodsNum.textAlignment = NSTextAlignmentLeft;
        
    }
    return _goodsNum;
}

- (UILabel *)goodsPrice {
    if (!_goodsPrice) {
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.font = [UIFont systemFontOfSize:13];
        _goodsPrice.textColor = [UIColor colorWithHexString:fineixColor];
        _goodsPrice.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsPrice;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseAll" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cacelAll" object:nil];
}

@end
