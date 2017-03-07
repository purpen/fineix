//
//  THNZhangHuView.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/7.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNZhangHuView.h"
#import "Fiu.h"
#import "THNBangDingTiXianZhangHuViewController.h"

@interface THNZhangHuView ()

/**  */
@property (nonatomic, strong) UIView *noneView;

@end

@implementation THNZhangHuView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setZhangHu:(ZhangHu)zhangHu{
    _zhangHu = zhangHu;
    if (self.zhangHu == none) {
        self.noneView = [[UIView alloc] init];
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"绑定提现账户";
        [self.noneView addSubview:tipLabel];
        tipLabel.font = [UIFont systemFontOfSize:13];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.noneView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(self.noneView.mas_left).mas_offset(35/2);
        }];
        UIImageView *goImageView = [[UIImageView alloc] init];
        goImageView.image = [UIImage imageNamed:@"entr"];
        [self.noneView addSubview:goImageView];
        [goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.noneView.mas_centerY).mas_offset(0);
            make.right.mas_equalTo(self.noneView.mas_right).mas_offset(-15);
        }];
        [self addSubview:self.noneView];
        [_noneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self).mas_offset(0);
        }];
        self.noneView.userInteractionEnabled = YES;
        [self.noneView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)]];
    }
}

-(void)viewTap{
    THNBangDingTiXianZhangHuViewController *vc = [[THNBangDingTiXianZhangHuViewController alloc] init];
    [self.nav pushViewController:vc animated:YES];
}

@end
