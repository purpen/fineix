//
//  FBCarGoodsListTabelViewCell.m
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBCarGoodsListTabelViewCell.h"

@implementation FBCarGoodsListTabelViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.newStock = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAllGoods) name:@"checkAll" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canceAllGoods) name:@"cancelAll" object:nil];
    }
    return self;
}

- (void)setGoodsCarModel:(CarGoodsModelItem *)goodsCarModel {
    [self.goodsImg downloadImage:goodsCarModel.cover place:[UIImage imageNamed:@""]];
    self.goodsTitle.text = goodsCarModel.title;
    
    if ([goodsCarModel.skuMode length] == 0) {
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", @"默认"];
    } else
        self.goodsColor.text = [NSString stringWithFormat:@"颜色/分类: %@", goodsCarModel.skuMode];
    
    self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", goodsCarModel.n];
    self.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f", goodsCarModel.price];
    self.stock = goodsCarModel.n; //  默认要购买的商品数量
    [self setCellUI];
    
    NSString * skuID = [NSString stringWithFormat:@"%zi", goodsCarModel.targetId];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsId" object:skuID];
    
    NSString * priceStr = [NSString stringWithFormat:@"%.2f", goodsCarModel.totalPrice];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsPrice" object:priceStr];
    
    NSString * goodsNum = [NSString stringWithFormat:@"%zi", goodsCarModel.n];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsNum" object:goodsNum];
}

- (void)getCarGoodsCount:(NSInteger )stock {
    self.carGoodsCount = stock;
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
    
    [self addSubview:self.goodsPrice];
    [_goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 15));
        make.bottom.equalTo(_goodsImg.mas_bottom).with.offset(0);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        
    }];
    
    [self addSubview:self.goodsColor];
    [_goodsColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_goodsPrice.mas_top).with.offset(-10);
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        
    }];
    
    [self addSubview:self.goodsNum];
    [_goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_goodsPrice.mas_top).with.offset(-10);
        make.left.equalTo(_goodsColor.mas_right).with.offset(5);
        
    }];
    
    [self addSubview:self.lineBgLab];
    [_lineBgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 5));
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
#pragma mark 编辑状态出现的按钮
    
    [self addSubview:self.subBtn];
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(_goodsImg.mas_right).with.offset(15);
        make.top.equalTo(_goodsImg.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(_subBtn);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self addSubview:self.goodsSumNum];
    [_goodsSumNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_subBtn);
        make.top.equalTo(_subBtn.mas_top).with.offset(0);
        make.bottom.equalTo(_subBtn.mas_bottom).with.offset(0);
        make.left.equalTo(_subBtn.mas_right).with.offset(-0.5);
        make.right.equalTo(_addBtn.mas_left).with.offset(0.5);
    }];
    
    [self addSubview:self.openReselectView];
    [_openReselectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.right.equalTo(_addBtn.mas_right).with.offset(0);
        make.bottom.equalTo(_goodsImg.mas_bottom).with.offset(0);
    }];
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn setImage:[UIImage imageNamed:@"Check"] forState:(UIControlStateNormal)];
        [_chooseBtn setImage:[UIImage imageNamed:@"Check_red"] forState:(UIControlStateSelected)];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _chooseBtn.selected = NO;
        self.selectedBtn = _chooseBtn;
    }
    return _chooseBtn;
}

- (void)checkAllGoods {
    self.selectedBtn.selected = YES;
}
- (void)canceAllGoods {
    self.selectedBtn.selected = NO;
}

- (void)chooseBtnClick:(UIButton *)button {
    if (button.selected == NO) {
        self.selectedBtn.selected = YES;
        
    }else if (button.selected == YES) {
        self.selectedBtn.selected = NO;
        
    }
}

- (UIImageView *)goodsImg {
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        
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

- (UILabel *)lineBgLab {
    if (!_lineBgLab) {
        _lineBgLab = [[UILabel alloc] init];
        _lineBgLab.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        
    }
    return _lineBgLab;
}

#pragma mark editCellStyle
- (UILabel *)goodsSumNum {
    if (!_goodsSumNum) {
        _goodsSumNum = [[UILabel alloc] init];
        _goodsSumNum.font = [UIFont systemFontOfSize:13];
        _goodsSumNum.textAlignment = NSTextAlignmentCenter;
        _goodsSumNum.textColor = [UIColor blackColor];
        _goodsSumNum.layer.borderColor = [UIColor colorWithHexString:@"#dfdfdf" alpha:1].CGColor;
        _goodsSumNum.layer.borderWidth = 1;
        
        _goodsSumNum.text = [NSString stringWithFormat:@"%zi",self.stock];
        if (self.stock == 1) {
            self.subBtn.userInteractionEnabled = NO;
            self.subBtn.backgroundColor = [UIColor colorWithHexString:titleColor];
        }
        
    }
    return _goodsSumNum;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_addBtn setTitle:@"＋" forState:(UIControlStateNormal)];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_addBtn addTarget:self action:@selector(addGoodsStock) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _addBtn;
}

- (UIButton *)subBtn {
    if (!_subBtn) {
        _subBtn = [[UIButton alloc] init];
        _subBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_subBtn setTitle:@"－" forState:(UIControlStateNormal)];
        [_subBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_subBtn addTarget:self action:@selector(subGoodsStock) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _subBtn;
}

#pragma mark 数量按钮的方法
- (void)addGoodsStock {
    if (self.carGoodsCount == 1) {
        self.goodsSumNum.text = @"1";
        [SVProgressHUD showInfoWithStatus:@"库存不足，不能更多了"];
        
    } else {
        self.stock ++;
        self.newStock = self.stock;
        self.goodsSumNum.text = [NSString stringWithFormat:@"%zi",self.stock];
        self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", self.stock];
        
        if (self.stock >= self.carGoodsCount) {
            self.addBtn.userInteractionEnabled = NO;
            self.addBtn.backgroundColor = [UIColor colorWithHexString:titleColor];
            [SVProgressHUD showInfoWithStatus:@"库存不足，不能更多了"];
            
        } else {
            self.subBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
            self.subBtn.userInteractionEnabled = YES;
        }
    }
}

- (void)subGoodsStock {
    if (self.carGoodsCount == 1) {
        self.goodsSumNum.text = @"1";
        [SVProgressHUD showInfoWithStatus:@"不能再减少了"];
        
    } else {
        self.stock --;
        self.newStock = self.stock;
        self.goodsSumNum.text = [NSString stringWithFormat:@"%zi",self.stock];
        self.goodsNum.text = [NSString stringWithFormat:@"数量 * %zi", self.stock];
        
        if (self.stock == 1) {
            self.subBtn.userInteractionEnabled = NO;
            self.subBtn.backgroundColor = [UIColor colorWithHexString:titleColor];
            [SVProgressHUD showInfoWithStatus:@"不能再减少了"];
            
        } else {
            self.addBtn.userInteractionEnabled = YES;
            self.addBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        }
    }
}

- (UIButton *)openReselectView {
    if (!_openReselectView) {
        _openReselectView = [[UIButton alloc] init];
        UIImageView * img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
        [_openReselectView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12,7.5 ));
            make.bottom.equalTo(_openReselectView.mas_bottom).with.offset(-5);
            make.right.equalTo(_openReselectView.mas_right).with.offset(0);
        }];
        
    }
    return _openReselectView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkAll" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelAll" object:nil];
    
}

@end
