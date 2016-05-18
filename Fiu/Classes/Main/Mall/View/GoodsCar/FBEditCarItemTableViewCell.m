//
//  FBEditCarItemTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBEditCarItemTableViewCell.h"

@interface FBEditCarItemTableViewCell () 

@end

@implementation FBEditCarItemTableViewCell

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

- (void)setEditCarItemData:(CarGoodsModelItem *)model withStock:(NSInteger)stock {
    [self.goodsImg downloadImage:model.cover place:[UIImage imageNamed:@""]];
    if ([model.skuMode length] == 0) {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", @"默认"];
    } else {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", model.skuMode];
    }
    self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", model.n];
    self.numLab.text = [NSString stringWithFormat:@"%zi", model.n];
    
    self.nowNum = model.n;
    self.newNum = self.nowNum;
    self.stockNum = stock;
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
    
    [self addSubview:self.subNumBtn];
    [_subNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(_goodsImg.mas_top).with.offset(10);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
    }];
    
    [self addSubview:self.addNumBtn];
    [_addNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(_goodsImg.mas_top).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [self addSubview:self.numLab];
    [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImg.mas_top).with.offset(10);
        make.left.equalTo(_subNumBtn.mas_right).with.offset(0);
        make.right.equalTo(_addNumBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    [self addSubview:self.goodsColor];
    [_goodsColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subNumBtn.mas_bottom).with.offset(10);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        
    }];
    
    [self addSubview:self.goodsNum];
    [_goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subNumBtn.mas_bottom).with.offset(10);
        make.left.equalTo(_goodsColor.mas_right).with.offset(5);
        
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

- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
    }
    return _goodsImg;
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

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont systemFontOfSize:13];
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.textColor = [UIColor blackColor];
        _numLab.layer.borderColor = [UIColor colorWithHexString:@"#dfdfdf" alpha:1].CGColor;
        _numLab.layer.borderWidth = 1.0f;
    }
    return _numLab;
}

- (UIButton *)addNumBtn {
    if (!_addNumBtn) {
        _addNumBtn = [[UIButton alloc] init];
        _addNumBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_addNumBtn setTitle:@"＋" forState:(UIControlStateNormal)];
        [_addNumBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addNumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addNumBtn addTarget:self action:@selector(addGoodsStock:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addNumBtn;
}

#pragma mark - 增加数量
- (void)addGoodsStock:(UIButton *)button {
    self.newNum += 1;
    if (self.newNum == self.stockNum) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"StockNone", nil)];
        button.userInteractionEnabled = NO;
        
    } else {
        self.subNumBtn.userInteractionEnabled = YES;
        self.subNumBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
    }
    
    self.numLab.text = [NSString stringWithFormat:@"%zi", self.newNum];
}

- (UIButton *)subNumBtn {
    if (!_subNumBtn) {
        _subNumBtn = [[UIButton alloc] init];
        _subNumBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_subNumBtn setTitle:@"－" forState:(UIControlStateNormal)];
        [_subNumBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _subNumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_subNumBtn addTarget:self action:@selector(subGoodsStock:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _subNumBtn;
}

#pragma mark - 减少数量
- (void)subGoodsStock:(UIButton *)button {
    self.newNum -= 1;
    if (self.newNum == 1) {
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorWithHexString:titleColor];
        
    } else {
        self.addNumBtn.userInteractionEnabled = YES;
    }

    self.numLab.text = [NSString stringWithFormat:@"%zi", self.newNum];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseAll" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cacelAll" object:nil];
}

@end
