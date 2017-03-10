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
#import "UIView+FSExtension.h"

@interface THNZhangHuView () <THNBangDingTiXianZhangHuViewControllerDelaget>

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

-(void)setModel:(THNZhangHuModel *)model{
    _model = model;
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
    } else if (self.zhangHu == zhiFuBao) {
        self.noneView = [[UIView alloc] init];
        
        UIImageView *tuBiao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alipayBig"]];
        [_noneView addSubview:tuBiao];
        [tuBiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noneView.mas_centerY).mas_offset(0);
            make.width.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
            make.left.mas_equalTo(_noneView.mas_left).mas_offset(15);
        }];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"支付宝";
        [self.noneView addSubview:tipLabel];
        tipLabel.font = [UIFont systemFontOfSize:13];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.noneView.mas_centerY).mas_offset(-10);
            make.left.mas_equalTo(tuBiao.mas_right).mas_offset(10);
        }];
        
        UILabel *zhangHuLabel = [[UILabel alloc] init];
        zhangHuLabel.text = [NSString stringWithFormat:@"支付宝帐号（%@）",self.model.account];
        zhangHuLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self.noneView addSubview:zhangHuLabel];
        zhangHuLabel.font = [UIFont systemFontOfSize:13];
        [zhangHuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.noneView.mas_centerY).mas_offset(10);
            make.left.mas_equalTo(tuBiao.mas_right).mas_offset(10);
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
    } else if (self.zhangHu == YingHangKa) {
        self.noneView = [[UIView alloc] init];
        
        UIImageView *tuBiao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yinHangKaBig"]];
        [_noneView addSubview:tuBiao];
        [tuBiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noneView.mas_centerY).mas_offset(0);
            make.width.height.mas_equalTo(44*SCREEN_HEIGHT/667.0);
            make.left.mas_equalTo(_noneView.mas_left).mas_offset(15);
        }];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = self.model.pay_type_label;
        [self.noneView addSubview:tipLabel];
        tipLabel.font = [UIFont systemFontOfSize:13];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.noneView.mas_centerY).mas_offset(-10);
            make.left.mas_equalTo(tuBiao.mas_right).mas_offset(10);
        }];
        
        UILabel *zhangHuLabel = [[UILabel alloc] init];
        zhangHuLabel.text = [NSString stringWithFormat:@"储蓄卡（尾号%@）",[self.model.account substringFromIndex:self.model.account.length-4]];
        zhangHuLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self.noneView addSubview:zhangHuLabel];
        zhangHuLabel.font = [UIFont systemFontOfSize:13];
        [zhangHuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.noneView.mas_centerY).mas_offset(10);
            make.left.mas_equalTo(tuBiao.mas_right).mas_offset(10);
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
    } else {
        //巴拉巴拉
    }
}

-(void)setBangZhangHu:(ZhangHu)zhangHu andModel:(THNZhangHuModel *)model{
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    [self setModel:model];
    [self setZhangHu:zhangHu];
    switch (self.zhangHu) {
        case none:
        {self.height = 44;}
            break;
        case zhiFuBao:
        {self.height = 60;}
            break;
        case YingHangKa:
        {self.height = 60;}
            break;
            
        default:
            break;
    }
}

-(void)viewTap{
    THNBangDingTiXianZhangHuViewController *vc = [[THNBangDingTiXianZhangHuViewController alloc] init];
    vc.bangDingDelegate = self;
    [self.nav pushViewController:vc animated:YES];
}

@end
