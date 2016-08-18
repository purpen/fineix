//
//  THNMarkGoodsView.m
//  Fiu
//
//  Created by FLYang on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMarkGoodsView.h"
#import "MarkBrandsViewController.h"
#import "THNMarkGoodsViewController.h"

@implementation THNMarkGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.0f];
    
        [self addSubview:self.bgView];
        
        [self setViewUI];
    }
    return self;
}

#pragma mark - setViewUI
- (void)setViewUI {
    [self addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        make.left.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.brand];
    [_brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 80, 35));
        make.centerY.centerX.equalTo(self);
    }];
    
    [self addSubview:self.goods];
    [_goods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.left.right.equalTo(_brand).with.offset(0);
        make.top.equalTo(_brand.mas_bottom).with.offset(10);
    }];
    
    [self addSubview:self.writeLab];
    [_writeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.right.equalTo(_brand).with.offset(0);
        make.bottom.equalTo(_brand.mas_top).with.offset(-10);
    }];
    
    [self addSubview:self.chooseGoods];
    [_chooseGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.right.equalTo(_brand).with.offset(0);
        make.bottom.equalTo(_writeLab.mas_top).with.offset(-25);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffect.frame = self.bounds;
        [_bgView addSubview:visualEffect];
    }
    return _bgView;
}

- (UIButton *)chooseGoods {
    if (!_chooseGoods) {
        _chooseGoods = [[UIButton alloc] init];
        [_chooseGoods setTitle:NSLocalizedString(@"chooseGoodsImage", nil) forState:(UIControlStateNormal)];
        [_chooseGoods setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_chooseGoods setTitleEdgeInsets:(UIEdgeInsetsMake(0, -5, 0, 0))];
        _chooseGoods.titleLabel.font = [UIFont systemFontOfSize:14];
        _chooseGoods.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_chooseGoods setImage:[UIImage imageNamed:@"thn_icon_next_white"] forState:(UIControlStateNormal)];
        [_chooseGoods setImageEdgeInsets:(UIEdgeInsetsMake(0, SCREEN_WIDTH - 90, 0, 0))];
        for (NSUInteger idx = 0; idx < 2; ++ idx) {
            UILabel *btnLine = [[UILabel alloc] initWithFrame:CGRectMake(0, idx * 39, SCREEN_WIDTH-80, 0.5)];
            btnLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6f];
            [_chooseGoods addSubview:btnLine];
        }
        [_chooseGoods addTarget:self action:@selector(markGoodsClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _chooseGoods;
}

- (void)markGoodsClick {
    if ([self.delegate respondsToSelector:@selector(mark_GoodsImageAndInfo)]) {
        [self.delegate mark_GoodsImageAndInfo];
    }
}

- (UILabel *)writeLab {
    if (!_writeLab) {
        _writeLab = [[UILabel alloc] init];
        _writeLab.font = [UIFont systemFontOfSize:12];
        _writeLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _writeLab.text = NSLocalizedString(@"writeGoodsInfo", nil);
    }
    return _writeLab;
}

- (UITextField *)brand {
    if (!_brand) {
        _brand = [[UITextField alloc] init];
        _brand.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"goodsBrand", nil)
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _brand.textColor = [UIColor whiteColor];
        _brand.font = [UIFont systemFontOfSize:14];
        _brand.backgroundColor = [UIColor clearColor];
        _brand.layer.borderWidth = 0.5f;
        _brand.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6f].CGColor;
        _brand.layer.cornerRadius = 5.0f;
        
        _brand.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _brand.leftViewMode = UITextFieldViewModeAlways;
        _brand.delegate = self;
    }
    return _brand;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == self.brand) {
        MarkBrandsViewController *markBrandVC = [[MarkBrandsViewController alloc] init];
        [self.vc presentViewController:markBrandVC animated:YES completion:nil];
        
        if ([self.delegate respondsToSelector:@selector(mark_AddBands)]) {
            [self.delegate mark_AddBands];
        }
    
    } else if (textField == self.goods) {
        THNMarkGoodsViewController *markGoodVC = [[THNMarkGoodsViewController alloc] init];
        [self.vc presentViewController:markGoodVC animated:YES completion:nil];
        
        if ([self.delegate respondsToSelector:@selector(mark_AddGoods)]) {
            [self.delegate mark_AddGoods];
        }
    }
    return YES;
}

- (UITextField *)goods {
    if (!_goods) {
        _goods = [[UITextField alloc] init];
        _goods.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"goodsName", nil)
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _goods.textColor = [UIColor whiteColor];
        _goods.font = [UIFont systemFontOfSize:14];
        _goods.backgroundColor = [UIColor clearColor];
        _goods.layer.borderWidth = 0.5f;
        _goods.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6f].CGColor;
        _goods.layer.cornerRadius = 5.0f;
        
        _goods.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        _goods.leftViewMode = UITextFieldViewModeAlways;
        _goods.delegate = self;
    }
    return _goods;
}

#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:NSLocalizedString(@"cancel", nil), NSLocalizedString(@"Done", nil), nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleArr = arr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor whiteColor];
        [_footView addFootViewButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        [SVProgressHUD showInfoWithStatus:@"完成"];
    } else if (index == 0) {
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}


@end
